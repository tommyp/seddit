defmodule SedditWeb.PostsLiveTest do
  use SedditWeb.ConnCase

  import Phoenix.LiveViewTest
  import Seddit.PostsFixtures

  describe "Posts index" do
    test "renders all posts", %{conn: conn} do
      [post_1, post_2] = [post_fixture(), post_fixture()]

      {:ok, _lv, html} = live(conn, "/")

      assert html =~ "All posts"
      assert html =~ post_1.title
      assert html =~ post_2.title
    end
  end
end
