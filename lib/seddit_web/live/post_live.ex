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
    <p class="text-prose text-3xl"><%= @post.content %></p>
    """
  end
end
