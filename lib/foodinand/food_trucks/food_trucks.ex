 defmodule Foodinand.FoodTrucks.FoodTrucks do
   @moduledoc """
   Context functions for interacting with Food Trucks
   """

   import Ecto.Query
   require Logger

   alias Ecto.Multi
   alias Foodinand.Repo
   alias Foodinand.FoodTruck

   @doc """
   Primarily for demonstration purposes. Since we ingest food truck data directly from a download or the API,
   there shouldn't be much call for inserting an individual record.
   """
   @spec insert_food_truck(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
   def insert_food_truck(attrs) do
    %FoodTruck{}
    |> FoodTruck.changeset(attrs)
    |> Repo.insert()
   end

   @spec list_food_trucks() :: list(FoodTruck.t())
   def list_food_trucks() do
    Repo.all(FoodTruck)
   end

   @doc """
   Retrieves a list of food trucks who's food items column contains a substring matching the input term. Defaults to 10 results.
   """

   @spec get_food_trucks_by_search_term(String.t(), integer()) :: list(FoodTruck.t())
   def get_food_trucks_by_search_term(search_term, limit \\ 10) do
    wildcard_term = "%#{search_term}%"
     FoodTruck
     |> where([ft], ilike(ft.food_items, ^wildcard_term))
     |> limit(^limit)
     |> Repo.all()
   end

   @doc """
   Retrieves a list of random food trucks. Defaults to 1.

   While Postgres has a random() function for randomly selecting a row, Ecto does not, so we need to use a raw query here.
   TABLESAMPLE SYSTEM will pick up 10% of the table and select a random row from within that block.
   """
   @spec get_random_food_trucks(integer()) :: [FoodTruck.t()]
   def get_random_food_trucks(number \\ 1) do
    qry = "SELECT * FROM food_trucks TABLESAMPLE SYSTEM (10) LIMIT #{number}"
    result = Ecto.Adapters.SQL.query!(Repo, qry, [])
    Enum.map(result.rows, &Repo.load(FoodTruck, {result.columns, &1}))
   end

   @doc """
   Inserts food trucks from the raw JSON file. In practice we would need this to regularly update
   our food truck data via cron job. Relies on parse_keys/1 to format keys.

   I use the Stream to lazily filter out non-food-trucks and expired or suspended food trucks while building up
   a list of changesets for a mass insert. I prefer this to Repo.insert_all/3 because I like
   the validation that changesets provide. It also allows me to easily drop keys from the Food Truck API
   that I don't need.

   Link to the official data source:
   https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data

   API Endpoint:
   https://data.sfgov.org/resource/rqzj-sfat.json
   """
   @spec insert_food_trucks_from_file(String.t()) :: binary() | {binary(), module()} | {:error, Jason.DecodeError}
   def insert_food_trucks_from_file(file_path) do
    case decode_source_file(file_path) do
      {:ok, data} ->
          data
          |> Stream.map(&parse_keys_to_changeset(&1))
          |> Stream.filter(fn fcs ->
            fcs.valid? == true && fcs.changes.facility_type == "Truck" && fcs.changes.status != :EXPIRED && fcs.changes.status != :SUSPEND
          end)
          |> Stream.map(fn food_truck_cs ->
            key = "food_truck_#{food_truck_cs.changes.location_id}"
            Multi.insert(Multi.new(), key, food_truck_cs)
          end)
          |> Enum.reduce(Multi.new(), &Multi.append/2)
          |> Repo.transaction()

      {:error, %Jason.DecodeError{data: reason} = decode_error} ->
        Logger.error("Problem encountered decoding source file: #{reason}" )
        {:error, decode_error}
    end
   end

  @doc """
  This helper function renames some keys to match the schema fields and returns a FoodTruck changeset.
  Ecto will map strings to atoms in most cases, but I'd like to alter the keys to be in keeping
  with Elixir formatting conventions and some values need to be converted to their respective types.


  Keys not found in the schema (i.e. @computed_region_XXXX) will be discarded by the changeset.

  For example, objectid is the location id of the facility, per the official API docs, so we rename it.
  """
   def parse_keys_to_changeset(food_truck) do

    parsed_attrs =
    Map.new(food_truck, fn
      {"objectid", value} ->
        {:location_id, value}
      {"fooditems", value} ->
        {:food_items, value}
      {"location", %{"latitude" => latitude, "longitude" => longitude}} ->
        {:location, "#{latitude}, #{longitude}"}
      {"facilitytype", value} ->
        {:facility_type, value}
      {"locationdescription", value} ->
        {:location_description, value}
      {"dayshours", value} ->
        {:days_hours, value}
      {"noisent", value} ->
        {:noi_sent, value}
      {"expirationdate", value} ->
        {:expiration_date, naive_date_parse_helper(value)}
      {"approved", value} ->
        {:approved, naive_date_parse_helper(value)}
      {"priorpermit", value} ->
        {:prior_permit, value}
      {key, value} ->
        # Need to convert remaining keys to atoms for consistency
        {String.to_atom(key), value}
        end)

      FoodTruck.changeset(%FoodTruck{}, parsed_attrs)
   end

   defp decode_source_file(file_path) do
    file_path
    |> File.read!()
    |> Jason.decode()
   end

  # Necessary because apparently Ecto can't accept microseconds for NaiveDateTime
   defp naive_date_parse_helper(date) do
     date
     |> NaiveDateTime.from_iso8601!()
     |> NaiveDateTime.truncate(:second)
   end
 end
