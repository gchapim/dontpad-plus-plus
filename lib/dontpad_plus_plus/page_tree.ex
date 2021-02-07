defmodule DontpadPlusPlus.PageTree do
  use Agent

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

  @doc """
  Puts the `value` for the given `key` in the `page_tree`.
  """
  def put(page_tree, key, value) do
    Agent.update(page_tree, &Map.put(&1, key, value))
  end
end
