defmodule Seddit.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Seddit.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :user, User
    has_many :comments, Seddit.Posts.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
