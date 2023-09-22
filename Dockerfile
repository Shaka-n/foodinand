FROM elixir:1.14.3-alpine

RUN apk update && apk upgrade && \
  apk add postgresql-client && \
  apk add build-base && \
  rm -rf /var/cache/apk/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN mix do deps.get, deps.compile

CMD ["mix", "phx.server"]