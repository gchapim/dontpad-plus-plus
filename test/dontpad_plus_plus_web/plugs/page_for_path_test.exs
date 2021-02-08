defmodule DontpadPlusPlusWeb.Plugs.PageForPathTest do
  use DontpadPlusPlusWeb.ConnCase, async: true

  describe "root call" do
    test "call/2" do
      assert %{conn: get(build_conn(), "/")}
    end
  end

  describe "nested path" do
    setup do
      conn = get(build_conn(), "/foo/bar")

      %{conn: conn}
    end

    test "call/2", %{conn: conn} do
      assert %Plug.Conn{assigns: %{page: page, path: ["foo", "bar"]}} = conn

      assert page
    end
  end
end
