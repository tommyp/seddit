defmodule Seddit.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Seddit.Repo

  alias Seddit.Accounts.User
  alias Seddit.Posts.Comment
  alias Seddit.Posts.Post

  def subscribe(post_id) do
    Phoenix.PubSub.subscribe(Seddit.PubSub, "post:" <> post_id)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Seddit.PubSub, "posts")
  end

  def broadcast({:ok, %Post{} = post}, tag) do
    post = get_post_for_render!(post.id)
    Phoenix.PubSub.broadcast(Seddit.PubSub, "posts", {tag, post})

    {:ok, post}
  end

  def broadcast({:ok, %Comment{} = comment}, tag) do
    comment = get_comment_for_render!(comment.id)
    Phoenix.PubSub.broadcast(Seddit.PubSub, "post:" <> comment.post_id, {tag, comment})

    {:ok, comment}
  end

  def broadcast({:error, _changeset} = error, _tag), do: error

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    from(p in Post,
      order_by: [desc: p.inserted_at],
      preload: [:user]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_for_render!(id) do
    from(p in Post,
      where: p.id == ^id,
      preload: [:user]
    )
    |> Repo.one!()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%User{}, %{field: value})
      {:ok, %Post{}}

      iex> create_post(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(%User{} = user, attrs \\ %{}) do
    %Post{
      user_id: user.id
    }
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Seddit.Posts.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  defp user_preload do
    from(u in User, select: [:email])
  end

  def list_comments_for_post(%Post{} = post) do
    from(c in Comment,
      where: c.post_id == ^post.id,
      order_by: [desc: c.inserted_at],
      preload: [user: ^user_preload()]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  def get_comment_for_render!(id) do
    from(c in Comment,
      where: c.id == ^id,
      preload: [user: ^user_preload()]
    )
    |> Repo.one!()
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(%User{} = user, %Post{} = post, attrs \\ %{}) do
    %Comment{
      user_id: user.id,
      post_id: post.id
    }
    |> Comment.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:comment_created)
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
