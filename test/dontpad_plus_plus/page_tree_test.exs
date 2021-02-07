defmodule DontpadPlusPlus.PageTreeTest do
  use ExUnit.Case, async: true

  alias DontpadPlusPlus.{Page, PageTree}

  setup do
    {:ok, page_tree} = PageTree.start_link([])

    %{page_tree: page_tree}
  end

  test "stores root pages by key", %{page_tree: page_tree} do
    assert PageTree.get(page_tree, "bojack") == nil

    PageTree.put(page_tree, "bojack", %Page{})
    assert %Page{} = PageTree.get(page_tree, "bojack")
  end
end
