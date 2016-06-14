defmodule ElmChallenges.PageController do
  use ElmChallenges.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
