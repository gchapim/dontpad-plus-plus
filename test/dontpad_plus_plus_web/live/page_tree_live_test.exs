defmodule DontpadPlusPlusWeb.PageTreeLiveTest do
  use DontpadPlusPlusWeb.ConnCase

  alias DontpadPlusPlus.PageTree

  import Phoenix.LiveViewTest

  @page_tree_name {:global, PageTree}

  describe "existing page" do
    setup do
      PageTree.get_or_put_in(@page_tree_name, ["bojack", "horseman"])
      page = PageTree.update_in(@page_tree_name, ["bojack", "horseman"], "Test content")

      %{page: page}
    end

    test "showing content", %{conn: conn} do
      {:ok, page_live, html} = live(conn, "/bojack/horseman")

      html =~ "Test content"

      assert render(page_live) =~ "Test content"
    end

    test "editing content", %{conn: conn} do
      {:ok, view, _} = live(conn, "/bojack/horseman")

      view
      |> element("form")
      |> render_change(%{page: %{content: "New content"}})

      assert %_{content: "New content"} = PageTree.get_in(@page_tree_name, ["bojack", "horseman"])
    end

    test "sync content", %{conn: conn} do
      {:ok, view, _} = live(conn, "/bojack/horseman")

      {:ok, second_view, _} = live(conn, "/bojack/horseman")

      assert render(second_view) =~ "Test content"

      view
      |> element("form")
      |> render_change(%{page: %{content: "New content"}})

      assert render(second_view) =~ "New content"
    end

    test "reload content on reload message", %{conn: conn} do
      {:ok, view, _} = live(conn, "/bojack/horseman")

      assert render(view) =~ "Test content"

      PageTree.update_in(@page_tree_name, ["bojack", "horseman"], "New content")

      send(view.pid, "reload")

      assert render(view) =~ "New content"
    end

    test "sends reload to itself", %{conn: conn} do
      {:ok, _, _} = live(conn, "/bojack/horseman")

      assert_receive("reload")
    end
  end
end
