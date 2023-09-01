# Dockerfile
FROM elixir:1.15-alpine

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

COPY . .

RUN mix do deps.get, compile

CMD ["mix", "phx.server"]
