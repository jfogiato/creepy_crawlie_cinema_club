defmodule CreepyCrawlieCinemaClub.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :movie_id, references(:movies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:movie_id])
  end
end
