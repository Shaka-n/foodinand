defmodule FoodinandWeb.FoodTrucksLive do
  alias Foodinand.FoodTrucks.FoodTrucks
  alias FoodinandWeb.CoreComponents
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="flex m-10 px-5 max-w-4xl">
    <div>
    <h1 class=" font-bold text-xl"> Foodinand: The Food Explorer</h1>
    <p>Discover new foods in SF! Search for a particular dish or cuisine in the bar below, or hit the random button for a random food truck!</p>
      <div class="flex flex-col pt-5">
        <h2>Feeling Lucky? Hit the button for a random SF Food Truck!</h2>
        <button class="rounded bg-emerald-600 pl-1 pr-1 py-1 hover:bg-gradient-to-br from-emerald-500 to-emerald-200 w-20 mt-2 text-white font-bold" phx-click="random-food-truck">Random</button>
        <div>
            <%= for ft <- @random_food_trucks do %>
              <.food_truck_info ft={ft} />
            <% end %>
        </div>
      </div>
      <div>
        <CoreComponents.simple_form for={@form} class="w-3/4 max-w-xs">
        <CoreComponents.input
          type="text"
          placeholder="Type to Search by Food Item or Cuisine"
          field={@form[:search_term]}
          phx-change="update-incremental-search"
          phx-debounce="300"
        />
        </CoreComponents.simple_form>
        <div >
            <%= for ft <- @food_truck_search_results do %>
              <.food_truck_info ft={ft} />
            <% end %>
        </div>
      </div>
      </div>
      <div>
      </div>
    </div>
    """
  end

  def food_truck_info(assigns) do
    ~H"""
      <div class="flex flex-col w-7/12 max-w-3/4 px-4 py-2 my-5 bg-gradient-to-b from-emerald-200 rounded">
        <h3 class="font-semibold"><%= @ft.applicant %></h3>
        <a class="text-sky-800" rel="noreferrer noopener" target="_blank" href={"https://www.google.com/maps/search/San+Francisco,+CA+#{@ft.address}"}><%= @ft.address %></a>
        <p> <%=@ft.location_description %> </p>
        <a class="text-sky-800" href={@ft.schedule} rel="noreferrer noopener" target="_blank">Link to Schedule</a>
        <div>
          <h3> Menu </h3>
          <p> <%= @ft.food_items %> </p>
        </div>
      </div>
    """
  end

  def mount(_params, _, socket) do
    socket = assign(socket, form: to_form(%{"search_term" => ""}))
    socket = assign(socket, :random_food_trucks, [])
    socket = assign(socket, :food_truck_search_results, [])
    {:ok, socket}
  end

  def handle_event("update-incremental-search", %{"search_term" => search_term} = _payload, socket) do
    food_truck_search_results = FoodTrucks.get_food_trucks_by_search_term(search_term, 10)

    {:noreply, assign(socket, :food_truck_search_results, food_truck_search_results)}
  end

  def handle_event("random-food-truck", _, socket) do
    random_food_trucks = FoodTrucks.get_random_food_trucks()
    {:noreply, assign(socket, :random_food_trucks, random_food_trucks)}
  end
end
