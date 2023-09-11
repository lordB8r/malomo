defmodule Backend.Tracking.TrackingSim do
  @behaviour Backend.Tracking.ClientBehaviour
  @base_url "https://trackingsim.gomalomo.dev/api/trackers"

  def create_tracker(tracking_code, carrier, status) do
    Req.new(
      method: :post,
      base_url: @base_url,
      body: %{
        carrier: carrier,
        tracking_code: tracking_code,
        status: status
      }
    )
    |> Req.Request.put_header(
      "authorization",
      "Bearer #{api_key()}"
    )
    |> Req.Request.run!()
    |> Map.get(:body)
  end

  def get_status(tracker_id) do
    Req.get!(
      @base_url <> "/" <> tracker_id,
      header: [
        "authorization",
        "Bearer #{api_key()}"
      ]
    )
    |> Map.get(:body)
  end

  defp api_key() do
    Application.fetch_env!(:backend, :tracking_api_key)
  end
end
