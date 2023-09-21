defmodule FoodinandWeb.PageControllerTest do
  use FoodinandWeb.ConnCase

  describe "GET" do
    test "home", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Discover new food with Foodinand!"
    end
  end

  test "food-trucks", %{conn: conn} do
    conn = get(conn, ~p"/food-trucks")
    assert html_response(conn, 200) =~ "Foodinand: The Food Explorer"
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
