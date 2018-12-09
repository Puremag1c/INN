defmodule InnWeb.Router do
  use InnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Ueberauth
    plug Inn.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InnWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/profile", PageController, :profile
  end
  scope "/profile", InnWeb do
    pipe_through :browser

    resources "/", PageController
    
  end
  scope "/auth", InnWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
  # Other scopes may use custom stacks.
  # scope "/api", InnWeb do
  #   pipe_through :api
  # end
end
