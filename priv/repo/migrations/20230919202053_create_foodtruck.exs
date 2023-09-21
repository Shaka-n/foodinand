defmodule Foodinand.Repo.Migrations.CreateFoodtruck do
  use Ecto.Migration

  def change do
    create table(:food_trucks) do
      add :location_id, :integer, null: false
      add :applicant, :string, null: false
      add :facility_type, :string
      add :cnn, :integer, null: false
      add :location_description, :string
      add :address, :string
      add :blocklot, :string
      add :block, :string
      add :lot, :string
      add :permit, :string
      add :status, :string, size: 10
      add :food_items, :text
      add :x, :float
      add :y, :float
      add :latitude, :float
      add :longitude, :float
      add :schedule, :text
      add :days_hours, :string
      add :noi_sent, :naive_datetime
      add :approved, :naive_datetime
      add :received, :string
      add :prior_permit, :integer
      add :expiration_date, :naive_datetime
      add :location, :string

      timestamps()
    end
  end
end
