defmodule Civbot.Forum do
  use GenServer

  @site "https://forum.civcraft.co/"
  @delay Application.get_env(:civbot, :check_forum_delay)

  def start_link do
    GenServer.start_link(__MODULE__,[],[])
  end

  def init(_opts) do
    Process.register(self, :forum)
    init_state = %{
      :last_post_count => nil,
      :last_post_id => nil,
      :last_post_name => nil,
      :last_post_user => nil
    }
    Process.send_after(self, :check, @delay)
    {:ok, init_state}
  end

  def handle_info(:check, state) do
    dat = fetchdata()
    newstate = parsedata(dat, state)
    Process.send_after(self, :check, @delay)
    {:noreply, newstate}
  end

  def fetchdata() do
    resp = HTTPoison.get!(@site<>"latest.json")
    if resp.status_code == 200 do
      topic = resp.body
        |> Poison.Parser.parse!
        |> Map.get("topic_list")
        |> Map.get("topics")
        |> hd()
      %{
      :last_post_count => Map.get(topic,"highest_post_number"),
      :last_post_id => Map.get(topic, "id"),
      :last_post_name => Map.get(topic, "slug"),
      :last_post_user => Map.get(topic, "last_poster_username")
      }
    else
      IO.puts "<FORUM> Unable to retrieve forum data. Response code: #{resp.status_code}."
      %{
        :last_post_count => nil,
        :last_post_id => nil,
        :last_post_name => nil,
        :last_post_user => nil
      }
    end
  end

  def parsedata(%{:last_post_id => nil}, state), do: state
  def parsedata(%{:last_post_id => name, :last_post_count => count}, state = %{:last_post_id => name, :last_post_count => count}), do: state
  def parsedata(data, _state) do
    msg =
      "_New Post by:_ *#{data.last_post_user}*
      #{@site}t/#{data.last_post_name}/#{data.last_post_id}/#{data.last_post_count}
      "
    send :bot, {:message, msg, "#info-dump"}
    data
  end

end
