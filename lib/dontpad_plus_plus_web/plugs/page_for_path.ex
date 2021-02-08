defmodule DontpadPlusPlusWeb.Plugs.PageForPath do
  import Plug.Conn

  alias DontpadPlusPlus.PageTree

  def init(default), do: default

  def call(%Plug.Conn{path_info: path_info} = conn, _) when path_info != [] do
    page = PageTree.get_or_put_in({:global, PageTree}, path_info)

    conn
    |> put_session("page", page)
    |> put_session("path", path_info)
  end

  def call(conn, _default), do: conn
end
