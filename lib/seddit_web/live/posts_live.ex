defmodule SedditWeb.PostsLive do
  use SedditWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :posts, Seddit.Posts.list_posts())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="">
      <h1 class="text-4xl mb-12">All posts</h1>
      <ul>
        <li :for={post <- @posts} class="mt-2 pb-3 last:border-0 border-b-2 border-gray-700">
          <h2 class="text-6xl"><%= post.title %></h2>
        </li>
      </ul>
    </section>
    """
  end
end
