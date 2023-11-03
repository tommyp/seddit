defmodule SedditWeb.PostLiveTest do
  use SedditWeb.ConnCase

  import Phoenix.LiveViewTest
  import Seddit.PostsFixtures

  describe "Post show" do
    test "renders post", %{conn: conn} do
      post = post_fixture()

      comments =
        1..5
        |> Enum.map(fn _ ->
          comment_fixture(%{post: post})
        end)

      {:ok, _lv, html} = live(conn, ~p"/posts/#{post.id}")

      assert html =~ post.title
      assert html =~ post.content

      comments
      |> Enum.each(fn comment ->
        assert html =~ comment.content
      end)
    end
  end
end