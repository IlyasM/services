defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticate do
    plug(ApiWeb.AuthPlug)
  end

  scope "/api", ApiWeb do
    # Use the default browser stack
    pipe_through(:api)

    # get("/", PageController, :index)

    post("/register", AuthController, :get_code)
    post("/verify", AuthController, :verify_code)

    pipe_through(:authenticate)
    get("/categories", CategoryController, :index)
    post("/business/new", BusinessController, :create)
    post("/user/update", UserController, :update)
  end
end
