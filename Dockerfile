FROM ubuntu:latest

MAINTAINER Marcelo Gonçalves <marcelocg@gmail.com>

# Elixir requires UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install some software requirements
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl wget git make

# download and install Erlang package
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
 && dpkg -i erlang-solutions_1.0_all.deb \
 && apt-get update

# install erlang from package
RUN apt-get install -y erlang erlang-ssl erlang-inets && rm erlang-solutions_1.0_all.deb

# install elixir from source
RUN git clone https://github.com/elixir-lang/elixir.git && cd elixir && git checkout v1.0.4 && make
ENV PATH $PATH:/elixir/bin

# install Phoenix from source with some previous requirements
RUN git clone https://github.com/phoenixframework/phoenix.git \
 && cd phoenix && git checkout v0.11.0 \
 && mix local.hex --force && mix local.rebar --force \
 && mix do deps.get, compile

# install Node.js and NPM in order to satisfy brunch.io dependencies
# the snippet below is borrowed from the official nodejs Dockerfile
# https://registry.hub.docker.com/_/node/

# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.12.2
ENV NPM_VERSION 2.7.3

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
 && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
 && gpg --verify SHASUMS256.txt.asc \
 && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
 && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
 && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
 && npm install -g npm@"$NPM_VERSION" \
 && npm cache clear

WORKDIR /code
