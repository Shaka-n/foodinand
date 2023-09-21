defmodule Foodinand.FoodTruck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_trucks" do
    field :address, :string
    field :applicant, :string
    field :approved, :naive_datetime
    field :block, :string
    field :blocklot, :string
    field :cnn, :integer
    field :days_hours, :string
    field :expiration_date, :naive_datetime
    field :facility_type, :string
    field :food_items, :string
    field :latitude, :float
    field :location, :string
    field :location_description, :string
    field :location_id, :integer
    field :longitude, :float
    field :lot, :string
    field :noi_sent, :naive_datetime
    field :permit, :string
    field :prior_permit, :integer
    field :received, :string
    field :schedule, :string
    field :status, Ecto.Enum, values: [:REQUESTED, :APPROVED, :ISSUED, :SUSPEND, :EXPIRED]
    field :x, :float
    field :y, :float

    timestamps()
  end

  @doc false
  def changeset(food_truck, attrs) do
    food_truck
    |> cast(attrs, __MODULE__.__schema__(:fields))
    |> validate_required([:location_id, :applicant, :cnn, :address, :status])
  end
end
