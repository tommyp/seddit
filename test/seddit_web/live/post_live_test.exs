defmodule SedditWeb.PostLiveTest do
  use SedditWeb.ConnCase

  import Phoenix.LiveViewTest
  import Seddit.AccountsFixtures
  import Seddit.PostsFixtures

  describe "Post show" do
    test "renders post", %{conn: conn} do
      post = post_fixture()

      comments =
        1..5
        |> Enum.map(fn _ ->
          comment_fixture(%{post: post})
        end)

      {:ok, _view, html} = live(conn, ~p"/posts/#{post.id}")

      assert html =~ post.title
      assert html =~ post.content

      comments
      |> Enum.each(fn comment ->
        assert html =~ comment.content
      end)
    end
  end

  test "posting a comment requires a signed in user", %{conn: conn} do
    post = post_fixture()

    {:ok, _view, html} =
      conn
      |> live(~p"/posts/#{post.id}")

    assert html =~ "Sign in to post a comment"
  end

  test "posting a comment when signed in", %{conn: conn} do
    post = post_fixture()
    post_id = post.id

    {:ok, view, _html} =
      conn
      |> log_in_user(user_fixture())
      |> live(~p"/posts/#{post_id}")

    view
    |> render_submit("comment:create", %{comment: %{content: "Test comment"}})

    :timer.sleep(100)

    assert render(view) =~ "Test comment"
  end
end
