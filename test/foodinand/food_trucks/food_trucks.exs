defmodule Foodinand.FoodTrucksTest do
  @moduledoc """
  Contains tests for the Food Trucks context. Including all CRUD actions.
  """
  use Foodinand.DataCase, async: true
  alias Foodinand.FoodTrucks.FoodTrucks
  @file_path "priv/static/data/rqzj-sfat.json"

  describe "adding new food trucks" do
    setup do
      raw_attrs_1 = %{
        "objectid"=>"95300099",
        "applicant"=>"Wonderful Test Truck #1",
        "facilitytype"=>"Truck",
        "cnn"=>"270002",
        "locationdescription"=>"04TH ST: BERRY ST to MISSION CREEK (900 - 999)",
        "address"=>"960 04TH ST",
        "blocklot"=>"8708002",
        "block"=>"8708",
        "lot"=>"002",
        "permit"=>"17MFF-0166",
        "status"=>"ISSUED",
        "fooditems"=>"Hot dogs: sausages: cheesesteaks: chips: drinks",
        "x"=>"6014277.187",
        "y"=>"2109955.224",
        "latitude"=>"37.77433766636957",
        "longitude"=>"-122.39405328631256",
        "schedule"=>"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=17MFF-0166&ExportPDF=1&Filename=17MFF-0166_schedule.pdf",
        "dayshours"=>"Mo-We:9AM-5PM",
        "approved"=>"2018-04-09T00:00:00.000",
        "received"=>"20170320",
        "priorpermit"=>"0",
        "expirationdate"=>"2019-07-15T00:00:00.000",
        "location"=>%{
          "latitude"=>"37.77433766636957",
          "longitude"=>"-122.39405328631256",
          "human_address"=>"{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}"},
        ":@computed_region_yftq_j783"=>"6",
        ":@computed_region_p5aj_wyqh"=>"2",
        ":@computed_region_rxqg_mtj9"=>"9",
        ":@computed_region_bh8s_q3mv"=>"310",
        ":@computed_region_fyvs_ahh9"=>"20"
      }
      raw_attrs_2 = %{
        "objectid"=>"9530019999",
        "applicant"=>"Wonderful Test Truck #2",
        "facilitytype"=>"Truck",
        "cnn"=>"270002",
        "locationdescription"=>"04TH ST: BERRY ST to MISSION CREEK (900 - 999)",
        "address"=>"960 04TH ST",
        "blocklot"=>"8708002",
        "block"=>"8708",
        "lot"=>"002",
        "permit"=>"17MFF-0166",
        "status"=>"ISSUED",
        "fooditems"=>"Hot dogs: sausages: cheesesteaks: chips: drinks",
        "x"=>"6014277.187",
        "y"=>"2109955.224",
        "latitude"=>"37.77433766636957",
        "longitude"=>"-122.39405328631256",
        "schedule"=>"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=17MFF-0166&ExportPDF=1&Filename=17MFF-0166_schedule.pdf",
        "dayshours"=>"Mo-We:9AM-5PM",
        "approved"=>"2018-04-09T00:00:00.000",
        "received"=>"20170320",
        "priorpermit"=>"0",
        "expirationdate"=>"2019-07-15T00:00:00.000",
        "location"=>%{
          "latitude"=>"37.77433766636957",
          "longitude"=>"-122.39405328631256",
          "human_address"=>"{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}"},
        ":@computed_region_yftq_j783"=>"6",
        ":@computed_region_p5aj_wyqh"=>"2",
        ":@computed_region_rxqg_mtj9"=>"9",
        ":@computed_region_bh8s_q3mv"=>"310",
        ":@computed_region_fyvs_ahh9"=>"20"
      }
      valid_attrs = FoodTrucks.parse_keys_to_changeset(raw_attrs_1).changes
      food_truck = FoodTrucks.insert_food_truck(valid_attrs)

      {:ok, %{raw_attrs: raw_attrs_2, valid_attrs: valid_attrs, food_truck: food_truck}}
    end

    test "parse_keys_to_changeset/1 produces valid changeset, drops keys not specified in schema", %{raw_attrs: raw_attrs} do

      changeset = FoodTrucks.parse_keys_to_changeset(raw_attrs)
      assert changeset.valid? == true
      assert changeset.changes[":@computed_region_yftq_j783"] == nil
      # assert 1==2
    end

      # Ordinarily I would keep a dataset on hand for testing the file ingestion, but in this case I think it is fine to use the real one.
      # MAKE A FILE, WRITE SOME VALUES IN, READ FROM THE FILE, DELETE IT
    test "insert_food_trucks_from_file/1" do
      {:ok, food_trucks} = FoodTrucks.insert_food_trucks_from_file(@file_path)
      assert length(Map.keys(food_trucks)) == 262
    end

    test "insert_food_truck/1", %{valid_attrs: valid_attrs} do

      {:ok, result} = FoodTrucks.insert_food_truck(valid_attrs)
      assert result.applicant == valid_attrs.applicant
    end
  end

  describe "retrieving food trucks" do

    test "list_food_trucks/0"do
      list_food_trucks = FoodTrucks.list_food_trucks()
      assert length(list_food_trucks) == 262
    end

# Normally I would have many more tests around this function, primarily because
# the search functionality relies on the ILIKE SQL function, which is a potential
# security risk. Substring seach also has many edge cases that would ideally be
# tested for, given more time.
    test "get_food_trucks_by_search_term/2" do
      [food_truck |_] = FoodTrucks.get_food_trucks_by_search_term("taco")
      assert String.downcase(food_truck.food_items) =~ "taco"
    end

# This could also use more testing, as I am inherently wary of raw SQL fragments.
    test "get_random_food_trucks/2" do
      [food_truck1 | _] = FoodTrucks.get_random_food_trucks(1)
      [food_truck2| _] = FoodTrucks.get_random_food_trucks(1)
      assert food_truck1.id != food_truck2.id
    end
  end
end
