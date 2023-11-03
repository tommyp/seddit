defmodule SedditWeb.PostLive do
  use SedditWeb, :live_view

  alias Seddit.Posts

  def mount(%{"id" => id}, _session, socket) do
    socket = assign(socket, :post, Posts.get_post_for_render!(id))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-6xl mb-6"><%= @post.title %></h1>
    <h2 class="text-3xl mb-12 text-gray-600">Posted by <%= @post.user.email %></h2>
    <p class="text-prose text-3xl mb-12"><%= @post.content %></p>

    <h2 class="text-3xl mb-6 text-gray-600">Comments</h2>
    <div :for={comment <- @post.comments} class="mb-6 pb-6 border-b-2 border-gray-300">
      <p class="text-prose text-2xl"><%= comment.content %></p>
      <p class="text-gray-600 text-xl">Posted by <%= comment.user.email %></p>
    </div>
    """
  end
end
