defmodule CreepyCrawlieCinemaClubWeb.CommentController do
  use CreepyCrawlieCinemaClubWeb, :controller

  alias CreepyCrawlieCinemaClub.Comments
  alias CreepyCrawlieCinemaClub.Comments.Comment
  alias CreepyCrawlieCinemaClub.Movies

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, :index, comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params} = params) do
    movie_id = params["movie_id"]

    comment_params =
      comment_params
      |> Map.put_new("username", get_session(conn, :username))
      |> Map.put_new("movie_id", movie_id)

    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/movies/#{comment.movie_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        movie = Movies.get_movie!(movie_id)
        comments = Comments.list_comments_for_movie(movie.id)
        current_username = get_session(conn, :username)

        render(conn, "show.html",
          movie: movie,
          comments: comments,
          comment_changeset: changeset,
          current_username: current_username
        )
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    conn = authorize_comment_user(conn, comment)
    changeset = Comments.change_comment(comment)
    render(conn, :edit, comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)
    conn = authorize_comment_user(conn, comment)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/movies/#{comment.movie_id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    conn = authorize_comment_user(conn, comment)

    {:ok, _comment} = Comments.delete_comment(comment)
    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/movies/#{comment.movie_id}")
  end

  defp authorize_comment_user(conn, comment) do
    current_username = get_session(conn, :username)
    if comment.username == current_username do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized action on comment.")
      |> redirect(to: ~p"/movies/#{comment.movie_id}")
      |> halt()
    end
  end
end
