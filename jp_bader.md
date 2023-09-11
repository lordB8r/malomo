JP Bader (all times in CST)

start date: 9/1/23
- start time: 11:53 
- stop time: 12:25

start date: 9/10/23
- start time: 16:04
- stop time: 17:22
- start time: 20:35
- stop time: 21:03
- start time: 22:30
- stop time: 23:45

## Notes

### Backend (Elixir and Phoenix)

- Shipments table: 
    - tracking number (tracking_code :: String.t)
    - carrier name (carrier_name :: String.t)
    - latest status (latest_status :: String.t)
    
    `mix phx.gen.schema Shipments.Shipments shipment tracking_code:string carrier_name:string status:string tracking_sim_id:string`
    - create tests to validate 
    
- Shipment Events table:
    - shipment_uuid (shipment_id :: String.t)
    - status (string)
    - changed_at (datetime) (updated_at :: datetime)
    
    `mix phx.gen.schema Shipments.ShipmentEvents shipment_event shipment_id:references:shipments description:string`
    - create tests to validate

- TrackingSim Endpoint with Behaviour
    - create_tracker(code, carrier)
    - get_status(id)

- Use Oban for job qeueing
    - Maybe use Hammer to rate limit

- API endpoint 
    - accepts a tracking number and carrier name, 
    - uses the TrackingSim API to create a tracker for the shipment.
        ```json
        {
            "carrier": "usps",
            "status": "pre_transit",
            "tracking_code": "DE1233444098912831"
        }
    - create tests for API
    - create tests for Oban

- Frontend dashboard
    - React components
    - onSubmit
    - onClick

### Missing pieces

1. Did not work on rate limiter issue
2. 

### Notes from Malomo
Tracking code and tracking number are interchangeable.

The shipment_id is just a foreign key to the shipments table, but you can structure the relationships anyway you see fit. 

The tracker id is the id of the tracker you create on TrackingSim (you’ll get it when interacting with the API)