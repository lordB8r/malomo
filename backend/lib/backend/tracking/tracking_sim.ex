defmodule Backend.Tracking.TrackingSim do
  @behaviour Backend.Tracking.ClientBehaviour
  @base_url "https://trackingsim.gomalomo.dev/api/trackers"

  def create_tracker(tracking_code, carrier, status) do
    {:ok, resp} =
      Req.new(
        base_url: @base_url,
        json: %{
          carrier: carrier,
          tracking_code: tracking_code,
          status: status
        }
      )
      |> Req.Request.put_header(
        "authorization",
        "Bearer #{api_key()}"
      )
      |> Req.post()

    resp
    |> Map.get(:body)
  end

  def get_status(tracker_id) do
    Req.new(base_url: @base_url <> "/" <> tracker_id)
    |> Req.Request.put_header(
      "authorization",
      "Bearer #{api_key()}"
    )
    |> Req.get!()
    |> Map.get(:body)
  end

  defp api_key() do
    Application.fetch_env!(:backend, :tracking_api_key)
  end
end
