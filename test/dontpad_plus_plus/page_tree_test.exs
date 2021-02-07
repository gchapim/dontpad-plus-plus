defmodule DontpadPlusPlus.PageTreeTest do
  use ExUnit.Case, async: true

  alias DontpadPlusPlus.{Page, PageTree}

  setup do
    {:ok, page_tree} = PageTree.start_link([])

    %{page_tree: page_tree}
  end

  test "stores root pages by key", %{page_tree: page_tree} do
    assert PageTree.get(page_tree, "bojack") == nil

    assert %Page{name: "bojack"} = PageTree.put(page_tree, "bojack")
    assert %Page{name: "bojack"} = PageTree.get(page_tree, "bojack")
  end

  test "stores value by key", %{page_tree: page_tree} do
    assert PageTree.get(page_tree, "bojack") == nil

    PageTree.put(page_tree, "bojack", 3)
    assert 3 = PageTree.get(page_tree, "bojack")
  end

  test "get_in/2 with empty array", %{page_tree: page_tree} do
    assert is_nil(PageTree.get_in(page_tree, []))
  end

  test "get_in/2 for not existing nested input", %{page_tree: page_tree} do
    nested_tree = ["bojack", "horseman"]

    assert is_nil(PageTree.get_in(page_tree, nested_tree))
  end

  test "get_in/2 for existing nested input", %{page_tree: page_tree} do
    nested_tree = ["bojack", "horseman"]
    nested_page = %Page{name: "horseman"}

    PageTree.put(page_tree, "bojack", %Page{children: %{"horseman" => nested_page}})

    assert nested_page == PageTree.get_in(page_tree, nested_tree)
  end

  test "get_or_put_in/2 with empty array", %{page_tree: page_tree} do
    assert is_nil(PageTree.get_or_put_in(page_tree, []))
  end

  test "get_or_put_in/2 for nested input", %{page_tree: page_tree} do
    nested_tree = ["bojack", "horseman", "63"]

    assert %Page{name: "63", children: %{}} = PageTree.get_or_put_in(page_tree, nested_tree)

    assert %Page{name: "horseman", children: %{"63" => %Page{name: "63"}}} =
             PageTree.get_in(page_tree, ["bojack", "horseman"])

    assert %Page{
             name: "bojack",
             children: %{"horseman" => %Page{name: "horseman", children: %{"63" => %Page{}}}}
           } = PageTree.get_in(page_tree, ["bojack"])
  end

  test "get_or_put_in/2 respects siblings", %{page_tree: page_tree} do
    nested_tree = ["bojack", "horseman", "63"]
    sibling = %Page{children: %{}, content: "", name: "sibling"}

    PageTree.put(page_tree, "bojack", %Page{name: "bojack", children: %{"sibling" => sibling}})

    assert %Page{name: "63", children: %{}} = PageTree.get_or_put_in(page_tree, nested_tree)

    assert %Page{name: "horseman", children: %{"63" => %Page{name: "63"}}} =
             PageTree.get_in(page_tree, ["bojack", "horseman"])

    assert %Page{
             name: "bojack",
             children: %{
               "horseman" => %Page{name: "horseman", children: %{"63" => %Page{}}},
               "sibling" => ^sibling
             }
           } = PageTree.get_in(page_tree, ["bojack"])
  end
end
