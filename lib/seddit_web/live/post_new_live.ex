defmodule SedditWeb.PostNewLive do
  alias Seddit.Posts.Post
  alias Seddit.Posts
  use SedditWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        :form,
        to_form(Posts.change_post(%Post{}))
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="w-2/3">
      <h1 class="text-6xl mb-6">New Post</h1>
      <.simple_form for={@form} phx-submit="post:create">
        <h2 class="text-3xl mb-0">Title</h2>
        <.input type="text" field={@form[:title]} required="true" class="mb-6" />
        <h2 class="text-3xl mb-0">Content</h2>
        <.input type="textarea" field={@form[:content]} required="true" class="mb-0" />
        <:actions>
          <.button>
            Add Post
          </.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end

  def handle_event("post:create", %{"post" => post_params}, socket) do
    case Posts.create_post(socket.assigns.current_user, post_params) do
      {:ok, post} ->
        {:noreply, redirect(socket, to: ~p"/posts/#{post.id}")}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
