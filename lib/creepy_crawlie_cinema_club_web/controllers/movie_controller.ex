defmodule CreepyCrawlieCinemaClubWeb.MovieController do
  use CreepyCrawlieCinemaClubWeb, :controller

  alias CreepyCrawlieCinemaClub.Movies
  alias CreepyCrawlieCinemaClub.Movies.Movie
  alias CreepyCrawlieCinemaClub.Comments

  def index(conn, _params) do
    movies = Movies.list_movies()
    current_username = get_session(conn, :username)
    render(conn, :index, movies: movies, current_username: current_username)
  end

  def new(conn, _params) do
    default_username = get_session(conn, :username) || ""
    movie = %Movie{username: default_username}
    changeset = Movies.change_movie(movie)
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"movie" => movie_params}) do
    conn = put_session(conn, :username, movie_params["username"])

    case Movies.create_movie(movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie created successfully.")
        |> redirect(to: ~p"/movies/#{movie}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
  def show(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    comments = Comments.list_comments_for_movie(movie.id)
    comment_changeset = Comments.change_comment(%Comments.Comment{})
    current_username = get_session(conn, :username)
    user_upvoted = Movies.user_upvoted?(movie.id, current_username)

    render(conn, :show,
      movie: movie,
      comments: comments,
      comment_changeset: comment_changeset,
      current_username: current_username,
      user_upvoted: user_upvoted
    )
  end

  def edit(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    conn = authorize_user!(conn, movie)
    changeset = Movies.change_movie(movie)
    render(conn, :edit, movie: movie, changeset: changeset)
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Movies.get_movie!(id)
    conn = authorize_user!(conn, movie)

    case Movies.update_movie(movie, movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: ~p"/movies/#{movie}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, movie: movie, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    conn = authorize_user!(conn, movie)

    if conn.halted do
      conn
    else
      {:ok, _movie} = Movies.delete_movie(movie)
      conn
      |> put_flash(:info, "Movie deleted successfully.")
      |> redirect(to: ~p"/movies")
    end
  end

  def upvote(conn, %{"movie_id" => id}) do
    movie = Movies.get_movie!(id)
    username = get_session(conn, :username)

    case Movies.upvote_movie(movie, username) do
      {:ok, _upvote} ->
        conn
        |> put_flash(:info, "Thanks for your upvote!")
        |> redirect(to: ~p"/movies/#{movie}")
      {:error, %Ecto.Changeset{} = _changeset} ->
        # This error occurs if the unique constraint is violated (i.e., the user already upvoted)
        conn
        |> put_flash(:error, "You've already upvoted this movie.")
        |> redirect(to: ~p"/movies/#{movie}")
    end
  end

  def unvote(conn, %{"movie_id" => id}) do
    movie = Movies.get_movie!(id)
    username = get_session(conn, :username)

    case Movies.remove_upvote(movie, username) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Upvote removed!")
        |> redirect(to: ~p"/movies/#{movie}")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error removing upvote or you haven't upvoted yet.")
        |> redirect(to: ~p"/movies/#{movie}")
    end
  end

  defp authorize_user!(conn, movie) do
    if movie.username == get_session(conn, :username) do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized access - you cannot change a movie that is not yours.")
      |> redirect(to: ~p"/movies")
      |> halt()
    end
  end
end
