defmodule FoodinandWeb.PageController do
  use FoodinandWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
