defmodule DontpadPlusPlusWeb.Router do
  use DontpadPlusPlusWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DontpadPlusPlusWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DontpadPlusPlusWeb.Plugs.PageForPath
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DontpadPlusPlusWeb do
    pipe_through :browser

    if Mix.env() in [:dev, :test] do
      import Phoenix.LiveDashboard.Router

      live_dashboard "/dashboard", metrics: DontpadPlusPlusWeb.Telemetry
    end

    live "/", PageLive, :index

    live "/*path", PageTreeLive, :index
  end
end
