FROM buildpack-deps:trusty
MAINTAINER Arthur Burkart <artburkart@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV OTP_VERSION 18.1
ENV ELIXIR_VERSION 1.0.5
ENV PHOENIX_VERSION 1.0.2
ENV NODE_VERSION 4.1.1
ENV NPM_VERSION 2.14.0
ENV PATH $PATH:/elixir/bin

# Install git
RUN apt-get update && apt-get install -y git inotify-tools

# Install Erlang from source
ADD http://erlang.org/download/otp_src_${OTP_VERSION}.tar.gz /usr/src/
RUN cd /usr/src \
    && tar xf otp_src_${OTP_VERSION}.tar.gz \
    && cd otp_src_${OTP_VERSION} \
    && ./configure \
    && make -j8 \
    && make install \
    && rm -rf /usr/src/otp_src_${OTP_VERSION} && rm /usr/src/otp_src_${OTP_VERSION}.tar.gz \
    && rm -rf /var/lib/apt/lists/*

# Install elixir from source
RUN git clone --depth 1 --branch v$ELIXIR_VERSION https://github.com/elixir-lang/elixir.git && cd elixir && make

# Install Phoenix from source with some previous requirements
RUN git clone --depth 1 --branch v$PHOENIX_VERSION https://github.com/phoenixframework/phoenix.git \
 && cd phoenix && mix local.hex --force && mix local.rebar --force \
 && mix do deps.get, compile \
 && mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v$PHOENIX_VERSION/phoenix_new-$PHOENIX_VERSION.ez --force

# Berify gpg and sha256: http://nodejs.org/dist/v0.12.5/SHASUMS256.txt.asc
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

# install Node.js and NPM in order to satisfy brunch.io dependencies
# the snippet below is borrowed from the official nodejs Dockerfile
# https://registry.hub.docker.com/_/node/
ADD http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz /
ADD http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc /
RUN gpg --verify SHASUMS256.txt.asc \
 && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
 && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
 && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
 && npm install -g npm@"$NPM_VERSION" \
 && npm cache clear

WORKDIR /code
