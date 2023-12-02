defmodule FrankFerreiraWeb.PageControllerTest do
  use FrankFerreiraWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    content = html_response(conn, 200)
    assert content =~ "About"
    assert content =~ "Blog"
    assert content =~ "Timeline"
  end
end
