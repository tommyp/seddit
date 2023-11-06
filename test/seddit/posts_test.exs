defmodule Seddit.PostsTest do
  use Seddit.DataCase

  alias Seddit.Posts

  import Seddit.AccountsFixtures

  describe "posts" do
    alias Seddit.Posts.Post

    import Seddit.PostsFixtures

    @invalid_attrs %{title: nil, content: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", content: "some content"}

      assert {:ok, %Post{} = post} =
               Posts.create_post(user_fixture(), valid_attrs)

      assert post.title == "some title"
      assert post.content == "some content"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Posts.create_post(user_fixture(), @invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", content: "some updated content"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "comments" do
    alias Seddit.Posts.Comment

    import Seddit.PostsFixtures

    @invalid_attrs %{content: nil}

    @comment_fields_to_compare [
      :content,
      :id,
      :inserted_at,
      :post_id,
      :updated_at,
      :user_id
    ]

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert fields_equal?(Posts.list_comments(), [comment], @comment_fields_to_compare)
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert fields_equal?(Posts.get_comment!(comment.id), comment, @comment_fields_to_compare)
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Comment{} = comment} =
               Posts.create_comment(user_fixture(), post_fixture(), valid_attrs)

      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Posts.create_comment(user_fixture(), post_fixture(), @invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Comment{} = comment} = Posts.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_comment(comment, @invalid_attrs)

      assert fields_equal?(comment, Posts.get_comment!(comment.id), @comment_fields_to_compare)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Posts.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Posts.change_comment(comment)
    end
  end
end
