defmodule CreepyCrawlieCinemaClub.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CreepyCrawlieCinemaClub.Movies` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        genre: "some genre",
        note: "some note",
        title: "some title",
        upvotes: 42,
        username: "some username",
        watched: true
      })
      |> CreepyCrawlieCinemaClub.Movies.create_movie()

    movie
  end
end
