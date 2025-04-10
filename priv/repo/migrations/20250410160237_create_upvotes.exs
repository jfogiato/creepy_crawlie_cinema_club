defmodule CreepyCrawlieCinemaClub.Repo.Migrations.CreateUpvotes do
  use Ecto.Migration

  def change do
    create table(:upvotes) do
      add :movie_id, references(:movies, on_delete: :delete_all), null: false
      add :username, :string, null: false

      timestamps()
    end

    create unique_index(:upvotes, [:movie_id, :username])
  end
end
