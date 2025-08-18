# Everank

Everank is a simple thing ranking app. Video games, movies, books --
everything.

## Dev setup

Copy `.env.example` to `.env` and edit as necessary.

Then run:

    docker compose up

### Installing gems

Modify the `Gemfile` as needed and run:

    docker compose exec bundle install

You'll need to kill the server and start it again for new gems to be
recognised.
