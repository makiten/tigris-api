defmodule TigrisWeb.Router do
  use TigrisWeb, :router
  use Coherence.Router
  use PhoenixOauth2Provider.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :public do
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api_auth do
    plug ExOauth2Provider.Plug.VerifyHeader, realm: "Bearer"
    plug ExOauth2Provider.Plug.EnsureAuthenticated
  end

  pipeline :oauth_public do
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :oauth_public
    oauth_routes :public
  end

  scope "/" do
    pipe_through [:browser, :public]
    coherence_routes()
  end

  scope "/" do
    pipe_through [:browser, :protected]
    coherence_routes :protected
    oauth_routes :protected
  end

  scope "/", TigrisWeb do
    pipe_through [:browser, :public] # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TigrisWeb do
  #   pipe_through :api
  # end

  scope "/api/v2", TigrisWeb.API.V2 do
    pipe_through :api_auth
    resources "/accounts", UserController
  end
end