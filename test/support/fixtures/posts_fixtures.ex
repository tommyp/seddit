defmodule Seddit.PostsFixtures do
  alias Seddit.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Seddit.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        content: Faker.Lorem.paragraph(),
        title: Faker.Lorem.sentence()
      })

    {:ok, post} = Seddit.Posts.create_post(AccountsFixtures.user_fixture(), attrs)

    post
  end
end
