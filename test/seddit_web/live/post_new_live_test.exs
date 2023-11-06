defmodule SedditWeb.PostNewLiveTest do
  use SedditWeb.ConnCase

  import Phoenix.LiveViewTest
  import Seddit.AccountsFixtures

  describe "Post new" do
    test "when logged out", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log_in"}}} = live(conn, "/posts/new")
    end

    test "when logged in", %{conn: conn} do
      {:ok, _view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live("/posts/new")

      assert html =~ "New Post"
    end

    test "creating a post", %{conn: conn} do
      {:ok, view, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live("/posts/new")

      view
      |> render_submit("post:create", %{post: %{title: "Test title", content: "Test post"}})

      {path, _} = assert_redirect(view)
      assert path =~ ~r/\/posts\/\w+/

      {:ok, _view, html} = live(conn, path)

      assert html =~ "Test post"
    end
  end
end
