defmodule CreepyCrawlieCinemaClub.MoviesTest do
  use CreepyCrawlieCinemaClub.DataCase

  alias CreepyCrawlieCinemaClub.Movies

  describe "movies" do
    alias CreepyCrawlieCinemaClub.Movies.Movie

    import CreepyCrawlieCinemaClub.MoviesFixtures

    @invalid_attrs %{title: nil, username: nil, genre: nil, note: nil, upvotes: nil, watched: nil}

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Movies.list_movies() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Movies.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{title: "some title", username: "some username", genre: "some genre", note: "some note", upvotes: 42, watched: true}

      assert {:ok, %Movie{} = movie} = Movies.create_movie(valid_attrs)
      assert movie.title == "some title"
      assert movie.username == "some username"
      assert movie.genre == "some genre"
      assert movie.note == "some note"
      assert movie.upvotes == 42
      assert movie.watched == true
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{title: "some updated title", username: "some updated username", genre: "some updated genre", note: "some updated note", upvotes: 43, watched: false}

      assert {:ok, %Movie{} = movie} = Movies.update_movie(movie, update_attrs)
      assert movie.title == "some updated title"
      assert movie.username == "some updated username"
      assert movie.genre == "some updated genre"
      assert movie.note == "some updated note"
      assert movie.upvotes == 43
      assert movie.watched == false
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_movie(movie, @invalid_attrs)
      assert movie == Movies.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Movies.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Movies.change_movie(movie)
    end
  end
end
