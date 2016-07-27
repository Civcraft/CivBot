defmodule Civbot.Bot do
  use Slack

  def handle_connect(slack) do
    IO.puts "Connected as @#{slack.me.name}"
    Process.register(self, :bot)
  end

  def handle_close(reason, _slack) do
    IO.puts "Disconnected because: #{reason}"
  end

  def handle_message(message = %{type: "message"}, slack) do
    if Map.has_key?(message, :text) and String.contains?(message.text, "<@#{slack.me.id}>") do
      send_message("Shh, I'm hiding...", message.channel, slack)
    end
  end

  def handle_message(_,_), do: :ok

  def handle_info({:message, text, channel}, slack) do
    send_message(text, channel, slack)
    {:ok}
  end
  def handle_info(_, _), do: :ok

end
