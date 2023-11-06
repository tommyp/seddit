defmodule SedditWeb.PostsLive do
  use SedditWeb, :live_view
  alias Seddit.Posts.Post

  def mount(_params, _session, socket) do
    socket = assign(socket, :posts, Seddit.Posts.list_posts())

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Seddit.PubSub, "posts")
    end

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
          <.link class=" hover:text-white hover:bg-black pt-6 pb-3 block" href={~p"/posts/#{post.id}"}>
            <h2 class="text-6xl">
              <%= post.title %>
            </h2>
            <h3 class="mb-0">
              Posted <%= Timex.from_now(post.inserted_at) %> by <%= post.user.email %>
            </h3>
          </.link>
        </li>
      </ul>
    </section>
    """
  end

  def handle_info({:post_created, %Post{} = post}, socket) do
    {:noreply, assign(socket, posts: [post | socket.assigns.posts])}
  end
end
