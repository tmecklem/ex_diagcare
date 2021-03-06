defmodule ExDiagcare.Router do
  use ExDiagcare.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExDiagcare do
    pipe_through :browser # Use the default browser stack

    resources "/cgm_pages", CgmPageController, except: [:edit, :update, :delete]
    resources "/history_pages", HistoryPageController, except: [:edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExDiagcare do
  #   pipe_through :api
  # end
end
