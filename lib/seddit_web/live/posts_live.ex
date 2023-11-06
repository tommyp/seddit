defmodule SedditWeb.PostsLive do
  use SedditWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :posts, Seddit.Posts.list_posts())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="">
      <header class="mb-12 flex justify-between content-center">
        <h1 class="text-4xl">All posts</h1>
        <.link_button href={~p"/posts/new"}>
          Add post
        </.link_button>
      </header>
      <ul>
        <li :for={post <- @posts} class="last:border-0 border-b-2 border-gray-700">
          <h2 class="">
            <.link
              class="text-6xl hover:text-white hover:bg-black py-6 block"
              href={~p"/posts/#{post.id}"}
            >
              <%= post.title %>
            </.link>
          </h2>
        </li>
      </ul>
    </section>
    """
  end
end
