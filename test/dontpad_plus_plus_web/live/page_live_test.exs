defmodule DontpadPlusPlusWeb.PageLiveTest do
  use DontpadPlusPlusWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Dontpad++"
    assert render(page_live) =~ "Dontpad++"
  end
end
