defmodule CreepyCrawlieCinemaClubWeb.Router do
  use CreepyCrawlieCinemaClubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CreepyCrawlieCinemaClubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CreepyCrawlieCinemaClubWeb do
    pipe_through :browser

    get "/", PageController, :home


    resources "/movies", MovieController do
      resources "/comments", CommentController, only: [:create, :edit, :update, :delete]
      post "/upvote", MovieController, :upvote, as: :upvote
      delete "/upvote", MovieController, :unvote, as: :unvote
      resources "/comments", CommentController, only: [:create, :index]
    end

    get "/watched", MovieController, :watched
  end

  # Other scopes may use custom stacks.
  # scope "/api", CreepyCrawlieCinemaClubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:creepy_crawlie_cinema_club, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CreepyCrawlieCinemaClubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
