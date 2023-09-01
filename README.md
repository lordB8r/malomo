# Malomo Full Stack Technical Assessment

## Order Tracking API & Dashboard

Welcome to our technical assessment! You're about to tackle a real-world problem, rooted in our business domain, that will allow us to evaluate your technical prowess and problem-solving skills.

### What to Expect

In this assessment, you will embark on an exciting journey to build a simple shipment tracking system, composed of a backend API and a frontend dashboard. You will have an opportunity to demonstrate your proficiency in Elixir, Phoenix, React and TypeScript, as well as your knowledge of databases using PostgreSQL.

The backend segment of the exercise involves interfacing with our Tracking Simulator API (TrackingSim) to emulate shipment events. For the frontend, your task is to construct a dashboard displaying the shipment tracking data retrieved from the API.

This README file outlines specific requirements and expectations for the assessment, including detailed instructions for both backend and frontend development. Furthermore, it provides some helpful tips and hints to guide you through the process.

The primary goal here is not to finish the entire exercise but rather to showcase your technical prowess, problem-solving ability, and coding style. The evaluation will focus on how well you can articulate your thought process through code and commits, and how effectively you can solve the problems at hand.

We appreciate the time and effort you put into this exercise, and we're excited to see your approach to this task. Best of luck!

### Let's Get Started

Ready to dive in? Scroll down and carefully read through each section to familiarize yourself with the project before you begin. Should you encounter any issues or have questions along the way, feel free to reach out to us. We're more than happy to assist you!

Happy coding!

## General Instructions

- We want to see how far you can get within ~3 hours, if you don't finish that's perfectly okay. If you want to put in more time, that's also okay, but not expected.
- Be sure to make small, atomic commits to show your progress and thinking.
  - Before you start working, and after cloning the repository please create a file in the root directory with the following name format `<your first name>_<your last name>.md`. In that file include your name and start date/time. The commit should have the message: `docs: start assessment`.
  - When you're done, add a final commit updating your markdown file from the first commit and include the end date/time and any notes for the reviewers (if you have any). The final commit should have the message: `docs: mark as done`.
- To submit the project, please send [@dkarter](https://github.com/dkarter) and [@anthonator](https://github.com/anthonator) an invitation to a private GitHub repository containing the code and all commits.

## Implementation Instructions

### Backend (Elixir and Phoenix)

- Create a Shipments table that includes fields for tracking number, carrier name, and the latest status.
- Create a Shipment Events table that includes fields for the shipment_id, status, and changed_at
- Create an API endpoint that accepts a tracking number and carrier name, and uses the TrackingSim API to create a tracker for the shipment.
- Store the tracker ID in the Shipments database table.
- Once a shipment tracker is created through your API, check periodically for status updates on that tracker and update to the latest shipment status on your database
  - store a record in the shipments events table with the new status. The changed_at should map to the `updated_at` in the TrackingSim response.
- Create an API endpoint that returns a list of all shipments in the Shipments table with their most up to date status.

### Frontend (React and TypeScript)

- Create a simple dashboard page.
- Implement a form on the dashboard page that allows the user to enter a tracking number and carrier name, and submit the form to the backend API.
- On that page, display a list of all shipments recorded in the system.

### Bonus

- Think through how your app can avoid hitting the rate limit.
  - How many trackers can your system support per minute without losing on important events?
  - Implement this solution or include a write-up in the final commit notes of how you would solve it.

## About TrackingSim — Our Shipment Event Simulator

This is the API your backend will communicate with and was purposely built for this assessment. Here are a few things to know about this API.

- To get started please register an account on TrackingSim website: https://trackingsim.gomalomo.dev/users/register
- Once registered, create an API key. This key will be used by your app to create trackers and poll for changes in their status over time.
- You can create as many trackers as you want in the user interface to experiment and learn more about the system

There are only 2 API endpoints in TrackingSim that you will be interacting with:

### Create a Tracker

This is a `POST` request that uses the following URL:

```
https://trackingsim.gomalomo.dev/api/trackers
```

It accepts a `JSON` payload with the following format:

```json
{
  "carrier": "usps",
  "status": "pre_transit",
  "tracking_code": "DE1233444098912831"
}
```

When a `status` is not provided, it will be defaulted to `unknown`.

Here's an example for getting the latest information about a tracker with id `cbc7d0aa-85b6-417f-a5b2-211c80599864`:

```bash
curl \
  -X POST \
  -H 'authorization: Bearer sk_e2bbc567b52efc61ca4dd7cc24b1fc4f' \
  -H 'content-type: application/json' \
  https://trackingsim.gomalomo.dev/api/trackers \
  -d '{"carrier": "usps", "tracking_code": "DE1233444098912831"}'
```

Example Output:

```json
{
  "id": "7e739777-214d-4a5c-acb9-3391efc6d32f",
  "carrier": "usps",
  "status": "unknown",
  "tracking_code": "DE1233444098912831",
  "inserted_at": "2023-06-07T17:26:31",
  "updated_at": "2023-06-07T17:26:31"
}
```

### Get Tracker Status

This is a `GET` request that uses the following URL format:

```
https://trackingsim.gomalomo.dev/api/trackers/:tracker_id
```

Here's an example for getting the latest information about a tracker with id `cbc7d0aa-85b6-417f-a5b2-211c80599864`:

```bash
curl -v -H 'authorization: Bearer sk_e2bbc567b52efc61ca4dd7cc24b1fc4f' https://trackingsim.gomalomo.dev/api/trackers/cbc7d0aa-85b6-417f-a5b2-211c80599864
```

Example Output:

```json
{
  "id": "cbc7d0aa-85b6-417f-a5b2-211c80599864",
  "carrier": "usps",
  "status": "delivered",
  "tracking_code": "DE1233444098912831",
  "inserted_at": "2023-06-07T16:58:51",
  "updated_at": "2023-06-07T16:59:31"
}
```

### Additional Important Implementation Details

- Trackers normally start with a status of `unknown` and progresses through transitional statuses **every 10 seconds** until reaching a final status.
  - Transitional statuses: `unknown` -> `pre_transit` -> `in_transit` -> `out_for_delivery`
  - Final statuses:
    - `delivered`
    - `available_for_pickup`
    - `return_to_sender`
    - `failure`
    - `cancelled`
    - `error`
- TrackingSim has an API rate limit of **30 requests per minute** (per user) using a [Leaky Bucket Algorithm](https://en.wikipedia.org/wiki/Leaky_bucket) with a leak rate of 1 request every 2 seconds after the initial 30 requests.
  - When the rate limit is reached, the server will return status `429 Too Many Requests` as well as a `retry-after` header containing the number of seconds to wait until another request can be made.
  - This limit only applies to _reading a tracker status_, not _creating a tracker_.
  - After a period of inactivity, more capacity will open at a rate of 1 request per 2 seconds, which will allow for bursts
- TrackingSim provides some predictability for a tracking code final status by adding a special prefix to the tracking code:
  - `DE` -> `delivered`
  - `AV` -> `available_for_pickup`
  - `RE` -> `return_to_sender`
  - `FA` -> `failure`
  - `CA` -> `cancelled`
  - `ER` -> `error`
- For example, a tracking code `RE123456` will go through all transitional statuses until reaching `return_to_sender` and then stopping
- Trackers with no special prefix will have a random final status

## Hints

- The project comes with a boilerplate code to try and save you setup time. There are two folders, one for the `frontend/` and one for `backend/` and each contains a README.md file with setup instructions.
- You can also use the provided docker-compose file for easier setup:

  ```bash
  # initial backend setup and migration
  docker-compose run backend mix setup

  # run all services
  docker-compose up
  ```
