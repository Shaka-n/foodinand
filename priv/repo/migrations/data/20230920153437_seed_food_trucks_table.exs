defmodule Foodinand.Repo.Migrations.SeedFoodTrucksTable do
  @doc """
  This is a data migration to provide the initial seed for our food trucks table.

  Intended to be run against the "production" database, in practice, this migration
  would be deleted after a period of time to prevent invalid data states for fresh
  installations of our app.
  """
  use Ecto.Migration

  alias Foodinand.FoodTrucks.FoodTrucks


  @file_path "priv/static/data/rqzj-sfat.json"

  def change do
    case FoodTrucks.insert_food_trucks_from_file(@file_path) do
      {:ok, data}->
        {:ok, data}

      err->
        err
    end
  end
end
