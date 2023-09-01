# Shipment Tracking Dashboard

This is the frontend of our application. It allows users to view a list of shipments that have been recorded in the system and their current status.

## Installation Instructions

This project uses the [Yarn](https://yarnpkg.com/) package manager.

To get started you can use [asdf](https://asdf-vm.com/) to install all runtime dependencies that are listed in `.tool-versions`. Run this command from the `frontend/` directory:

```bash
asdf install
```

Then use yarn to install all node modules:

```bash
yarn install
```

## Development

To run the project in development mode use:

```bash
yarn dev
```

This will open a server on your localhost at port 5173.

http://localhost:5173/

## Testing

A basic unit test harness is included using [Jest](https://jestjs.io/) and [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/). To run the
tests use:

```bash
yarn test:unit
```
