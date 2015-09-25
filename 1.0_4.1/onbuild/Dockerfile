FROM marcelocg/phoenix:1.0_4.1-wheezy
MAINTAINER Arthur Burkart <artburkart@gmail.com>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY mix.exs /usr/src/app/
ONBUILD RUN mix deps.get

ONBUILD COPY . /usr/src/app
