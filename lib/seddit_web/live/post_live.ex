defmodule SedditWeb.PostLive do
  alias Seddit.Posts.Comment
  use SedditWeb, :live_view

  alias Seddit.Posts

  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(
        post: Posts.get_post_for_render!(id),
        form: to_form(Posts.change_comment(%Comment{}))
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section>
      <.link href={~p"/"} class="hover:bg-black hover:text-white p-2 inline-block mb-2">
        &larr; all posts
      </.link>
      <h1 class="text-6xl mb-6"><%= @post.title %></h1>
      <h2 class="text-3xl mb-12 text-gray-600">Posted by <%= @post.user.email %></h2>
      <p class="text-prose text-3xl mb-12"><%= @post.content %></p>

      <div class="w-2/3">
        <h2 class="text-3xl mb-6 text-gray-600">Comments</h2>
        <%= if Map.get(assigns, :current_user) do %>
          <.simple_form for={@form} phx-submit="comment:create">
            <.input type="textarea" field={@form[:content]} required="true" />
            <:actions>
              <.button>
                Post comment
              </.button>
            </:actions>
          </.simple_form>
        <% else %>
          <.link
            class="inline-block mb-4 bg-black text-white p-3"
            href={~p"/users/log_in?return_to=#{~p"/posts/#{@post.id}"}"}
          >
            Sign in to post a comment
          </.link>
        <% end %>
        <div :for={comment <- @post.comments} class="mb-6 pb-6 border-b-2 border-gray-300">
          <p class="text-prose text-2xl mb-2"><%= comment.content %></p>
          <p class="text-gray-600 text-xl">Posted by <%= comment.user.email %></p>
        </div>
      </div>
    </section>
    """
  end

  def handle_event("comment:create", %{"comment" => comment_params}, socket) do
    %{current_user: current_user, post: post} = socket.assigns

    socket =
      case Posts.create_comment(current_user, post, comment_params) do
        {:ok, _comment} ->
          assign(socket, post: Posts.get_post_for_render!(post.id))

        {:error, changeset} ->
          socket
          |> assign(form: to_form(changeset))
          |> put_flash(:error, "An error occurred")
      end

    {:noreply, socket}
  end
end
