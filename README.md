# docker-postfix

This is the Docker configuration for the masqt Postfix forwarding server.

## Setup

You'll need a working copy of [Docker](https://www.docker.com/).

1. Copy `env.example` to `.env` and change the values in `.env` to point to the correct database for your masqt backend.
1. Build the docker image: `docker build -t docker-postfix .`
1. Run the image with your environment variables: `docker run --env-file .env --name postfix docker-postfix`
1. (Optional) Get a shell in the image: `docker exec -it postfix "/bin/bash"`
1. (Optional) Check the postfix configuration from the shell: `postconf`

## Contributing
The Dockerfile is supposed to be lightweight: it just installs packages, runs the installation
script, and spins up Postfix. The actual meat of the configuration is in `install.sh` itself.
