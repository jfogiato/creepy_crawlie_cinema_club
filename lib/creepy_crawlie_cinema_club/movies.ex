defmodule CreepyCrawlieCinemaClub.Movies do
  @moduledoc """
  The Movies context.
  """

  import Ecto.Query, warn: false
  alias CreepyCrawlieCinemaClub.Repo

  alias CreepyCrawlieCinemaClub.Movies.Movie
  alias CreepyCrawlieCinemaClub.Upvotes.Upvote

  @doc """
  Returns the list of movies.

  ## Examples

      iex> list_movies()
      [%Movie{}, ...]

  """
  def list_movies do
    Repo.all(Movie)
  end

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id), do: Repo.get!(Movie, id)

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movie(%Movie{} = movie, attrs) do
    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    Repo.delete(movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.changeset(movie, attrs)
  end

  @doc """
  Upvotes a movie.
  """
  def upvote_movie(%Movie{} = movie, username) do
    %Upvote{}
    |> Upvote.changeset(%{movie_id: movie.id, username: username})
    |> Repo.insert()
  end

  def remove_upvote(%Movie{} = movie, username) do
    query =
      from u in CreepyCrawlieCinemaClub.Upvotes.Upvote,
        where: u.movie_id == ^movie.id and u.username == ^username

    case Repo.one(query) do
      nil -> {:error, :not_found}
      upvote -> Repo.delete(upvote)
    end
  end

  def user_upvoted?(movie_id, username) do
    query =
      from u in CreepyCrawlieCinemaClub.Upvotes.Upvote,
        where: u.movie_id == ^movie_id and u.username == ^username

    Repo.exists?(query)
  end

  @doc """
  Gets the upvote count for a movie.
  """
  def get_upvotes_count(movie_id) do
    from(u in Upvote, where: u.movie_id == ^movie_id)
    |> Repo.aggregate(:count, :id)
  end
end
