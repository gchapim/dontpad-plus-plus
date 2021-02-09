defmodule DontpadPlusPlusWeb.PageTreeLive do
  use DontpadPlusPlusWeb, :live_view
  use Phoenix.HTML

  alias DontpadPlusPlus.{PageTree, PubSub}

  @impl true
  def mount(_params, session, socket) do
    schedule_reload()
    Phoenix.PubSub.subscribe(PubSub, path(session["path"]))

    {:ok, assign(socket, page: session["page"], path: session["path"])}
  end

  defp path(path) do
    Enum.join(path, "-")
  end

  @impl true
  def handle_event("save", %{"page" => %{"content" => content}}, socket) do
    save(socket.assigns.path, content)

    Phoenix.PubSub.broadcast_from(
      PubSub,
      self(),
      path(socket.assigns.path),
      {:content_update, content}
    )

    {:noreply, socket}
  end

  defp save(path, content) do
    PageTree.update_in({:global, PageTree}, path, content)
  end

  @impl true
  def handle_info({:content_update, _content}, socket) do
    reload_content(socket)
  end

  @impl true
  def handle_info("reload", socket) do
    schedule_reload()

    reload_content(socket)
  end

  defp reload_content(socket) do
    page = PageTree.get_in({:global, PageTree}, socket.assigns.path)

    {:noreply, assign(socket, page: page)}
  end

  defp schedule_reload do
    Process.send_after(self(), "reload", reload_time())
  end

  defp reload_time do
    Application.get_env(:dontpad_plus_plus, :textarea_reload_time)
  end
end
