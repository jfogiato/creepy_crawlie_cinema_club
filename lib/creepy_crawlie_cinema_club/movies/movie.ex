defmodule CreepyCrawlieCinemaClub.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :title, :string
    field :username, :string
    field :genre, :string
    field :note, :string
    field :upvotes, :integer, default: 0
    field :watched, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:username, :title, :genre, :note, :upvotes, :watched])
    |> validate_required([:username, :title, :genre, :note, :upvotes, :watched])
  end
end
