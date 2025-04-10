defmodule CreepyCrawlieCinemaClub.Upvotes.Upvote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "upvotes" do
    field :username, :string
    belongs_to :movie, CreepyCrawlieCinemaClub.Movies.Movie

    timestamps()
  end

  def changeset(upvote, attrs) do
    upvote
    |> cast(attrs, [:username, :movie_id])
    |> validate_required([:username, :movie_id])
    |> unique_constraint([:movie_id, :username])
  end
end
