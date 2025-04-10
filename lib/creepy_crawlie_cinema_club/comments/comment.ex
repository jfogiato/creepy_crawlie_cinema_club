defmodule CreepyCrawlieCinemaClub.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :username, :string

    belongs_to :movie, CreepyCrawlieCinemaClub.Movies.Movie

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :username, :movie_id])
    |> validate_required([:body, :username, :movie_id])
  end
end
