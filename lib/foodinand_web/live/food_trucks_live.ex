defmodule FoodinandWeb.FoodTrucksLive do
  alias Foodinand.FoodTrucks.FoodTrucks
  alias FoodinandWeb.CoreComponents
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h2>Feeling Lucky? Hit the button for a random SF Food Truck!</h2>
        <button phx-click="random-food-truck">Random</button>
        <div>
          <%= if length(@random_food_trucks) > 0 do %>
            <%= for ft <- @random_food_trucks do %>
              <.food_truck_info ft={ft} />
            <% end %>
          <% end %>
        </div>
      </div>
      <div>
        <CoreComponents.simple_form for={@form} >
        <CoreComponents.input
          type="text"
          placeholder="Type to Search by Food Item or Cuisine"
          field={@form[:search_term]}
          phx-change="update-incremental-search"
          phx-debounce="300"
        />
        </CoreComponents.simple_form>
        <div>
            <%= for ft <- @food_truck_search_results do %>
              <div>
                <h3><%= ft.applicant %></h3>
                <p><%= ft.address %></p>
                <p> <%= ft.location_description %> </p>
                <a href={ft.schedule}>Schedule</a>
                <p> <%= ft.food_items %> </p>
              </div>
            <% end %>
        </div>
      </div>
    </div>
    """
  end

  def food_truck_info(assigns) do
    ~H"""
      <div>
        <h3><%= @ft.applicant %></h3>
        <p><%= @ft.address %></p>
        <p> <%=@ft.location_description %> </p>
        <a href="#"><%= @ft.schedule%></a>
        <p> <%= @ft.food_items %> </p>
      </div>
    """
  end

  def mount(_params, _, socket) do
    socket = assign(socket, form: to_form(%{"search_term" => ""}))
    socket = assign(socket, :random_food_trucks, [])
    socket = assign(socket, :food_truck_search_results, [])
    {:ok, socket}
  end

  def handle_event("update-incremental-search", %{"search_term" => search_term}=_payload, socket) do
    food_truck_search_results = FoodTrucks.get_food_trucks_by_search_term(search_term, 10)

    {:noreply, assign(socket, :food_truck_search_results, food_truck_search_results)}
  end

  def handle_event("random-food-truck", _, socket) do
    random_food_trucks = FoodTrucks.get_random_food_trucks()
    IO.inspect(random_food_trucks)
    {:noreply, assign(socket, :random_food_truck, random_food_trucks)}
  end
end
