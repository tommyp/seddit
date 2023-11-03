defmodule SedditWeb.PostLiveTest do
  use SedditWeb.ConnCase

  import Phoenix.LiveViewTest
  import Seddit.PostsFixtures

  describe "Post show" do
    test "renders post", %{conn: conn} do
      post = post_fixture()

      {:ok, _lv, html} = live(conn, ~p"/posts/#{post.id}")

      assert html =~ post.title
      assert html =~ post.content
    end
  end
end
