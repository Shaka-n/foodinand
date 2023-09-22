# Foodinand
An exploration tool for foodies looking for food trucks in SF.

Built in Elixir/Phoenix and LiveView, this is a web app that lets you search for food trucks based on food item or cuisine, or spin to a random food truck for fun.

As a rough overview, data flows through the app like so: A context function (FoodTrucks.insert_food_trucks_from_file/1) ingests a JSON file of raw data downloaded from
the official San Francisco Mobile Food Facility API. The JSON is decoded and streamed through a pipeline which cleans and filters the data to our desired shape before making
a bulk insert. The resulting records are now available to be viewed through the LiveView page. Context functions allow for viewing all inserted food trucks, a set of random
food trucks, or a food trucks whose `food-items` field contains a target substring. The latter two functions are connected to event handlers in the LiveView page, where users
can follow the spirit of adventure by finding a random food truck from the database, or be a bit choosier by searching food trucks based on dish, cuisine, or other target terms.

The architecture was designed with the idea that the official API is the single source of truth and our database is more of a heavy-weight cache. 
If I had more time I would have set up a cron job with Oban to regularly refresh our data from the official source. Were the domain to get more complicated,
for example with user reviews or comments, then I would have to consider some degree of synchronization, perhaps by more directly mapping the 'objectid' of 
the official database with the location_id of our database.

## Run in Docker
(Recommended)
With Docker and Docker Compose installed, run:

```
docker-compose build
docker-compose up
```
...and check it out on localhost:4000/food-trucks.

## Run Locally 
(Not Recommended)
Requirements at time of initialization:
- Elixir ~> 1.14.3
- Phoenix ~> 1.7.2
- PostgreSQL ~> 14.6

You can install via brew:
```
brew install elixir
brew install postgres
```

Run these commands to install dependencies, setup the database, and get the app running:
```
mix deps.get
mix ecto.setup
iex -S mix phx.server
```

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
