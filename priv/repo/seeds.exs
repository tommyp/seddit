# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Seddit.Repo.insert!(%Seddit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Seddit.Accounts
alias Seddit.Posts

users =
  1..5
  |> Enum.map(fn _i ->
    {:ok, user} =
      Accounts.register_user(%{
        username: Faker.Internet.user_name(),
        email: Faker.Internet.email(),
        password: "password1234"
      })

    user
  end)

users
|> Enum.shuffle()
|> Enum.each(fn user ->
  {:ok, post} =
    Posts.create_post(user, %{
      title: Faker.Lorem.sentence(),
      content: Faker.Lorem.paragraph(),
      user_id: user.id
    })

  1..5
  |> Enum.map(fn _i ->
    {:ok, comment} =
      Posts.create_comment(user, post, %{
        content: Faker.Lorem.paragraph()
      })
  end)
end)
