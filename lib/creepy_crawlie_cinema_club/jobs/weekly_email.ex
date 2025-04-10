defmodule CreepyCrawlieCinemaClub.Jobs.WeeklyEmail do
  use Oban.Worker, queue: :default, max_attempts: 3

  alias CreepyCrawlieCinemaClub.Mailer
  alias Swoosh.Email
  alias CreepyCrawlieCinemaClub.Movies

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    case Movies.pick_random_movie() do
      nil ->
        IO.puts("No unwatched movies found.")

      movie ->
        recipients = Application.get_env(:creepy_crawlie_cinema_club, :weekly_email_recipients, [])

        for recipient <- recipients do
          new_email =
            Email.new()
            |> Email.to(recipient)
            |> Email.from(System.get_env("GMAIL_USERNAME"))
            |> Email.subject("This Week's Movie Pick is....")
            |> Email.text_body("""
            Hi there,

            This week's movie pick is:

            Title: #{movie.title}
            Genre: #{movie.genre}
            Note: #{movie.note}

            Enjoy!
            """)

          case Mailer.deliver(new_email) do
            {:ok, _response} ->
              IO.puts("Email sent successfully to #{recipient}")
            {:error, reason} ->
              IO.puts("Failed to send email to #{recipient}: #{inspect(reason)}")
          end
        end
    end

    :ok
  end
end
