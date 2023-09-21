defmodule FoodinandWeb.PageController do
  use FoodinandWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  # def food_truck_random(conn, _params) do
  #   truck = Foodinand.FoodTrucks.get_random_food_trucks()
  #   render(conn, :random_food_truck, layout: false, truck: truck)
  # end

  # def food_trucks_by_search(conn, %{"search_term" => search_term}) do
  #   trucks = Foodinand.FoodTrucks.get_food_trucks_by_food_item(search_term)

  #   render(conn, :food_truck_search_results, layout: false, trucks: trucks)
  # end
end
