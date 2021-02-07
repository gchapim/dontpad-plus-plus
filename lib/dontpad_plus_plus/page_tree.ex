defmodule DontpadPlusPlus.PageTree do
  use Agent

  alias DontpadPlusPlus.Page

  @doc """
  Starts a new page tree.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `page_tree` by `key`.
  """
  def get(page_tree, key) do
    Agent.get(page_tree, &Map.get(&1, key))
  end

  def get_or_put(page_tree, key) do
    if page = get(page_tree, key) do
      page
    else
      put(page_tree, key)
    end
  end

  def get_in(page_tree, []), do: nil

  def get_in(page_tree, [root | tree_children]) do
    page_tree
    |> get(root)
    |> do_get_in(tree_children)
  end

  defp do_get_in(current_page, []), do: current_page

  defp do_get_in(nil, _tree_children), do: nil

  defp do_get_in(current_page, [current_level | tree_children]) do
    current_page
    |> Map.get(:children)
    |> Map.get(current_level)
    |> do_get_in(tree_children)
  end

  def get_or_put_in(_, []), do: nil

  def get_or_put_in(page_tree, [root | tree_children] = children) do
    root_page =
      page_tree
      |> get_or_put(root)

    page = %Page{root_page | children: do_get_or_put_in(root_page.children, tree_children)}
    put(page_tree, root, page)

    __MODULE__.get_in(page_tree, children)
  end

  defp do_get_or_put_in(children, []), do: children

  defp do_get_or_put_in(nil, _tree_children), do: nil

  defp do_get_or_put_in(children, [key | tree_children]) do
    children
    |> Map.update(
      key,
      %Page{name: key, children: do_get_or_put_in(%{}, tree_children)},
      fn page -> %Page{page | children: do_get_or_put_in(page.children, tree_children)} end
    )
  end

  @doc """
  Puts a new page for the given `key` in the `page_tree`. Returns the new `page`
  """
  def put(page_tree, key) do
    page = %Page{name: key}

    put(page_tree, key, page)
    page
  end

  @doc """
  Puts the `value` for the given `key` in the `page_tree`.
  """
  def put(page_tree, key, value) do
    Agent.update(page_tree, &Map.put(&1, key, value))
  end
end
