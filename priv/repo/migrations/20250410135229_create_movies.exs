defmodule CreepyCrawlieCinemaClub.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :username, :string
      add :title, :string
      add :genre, :string
      add :note, :text
      add :upvotes, :integer
      add :watched, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
