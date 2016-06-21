FROM trenpixster/elixir:1.2.0
MAINTAINER Justin Morris <justin.morris@ferocia.com.au>

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT pipelite

ENV ROOT /container/app
RUN mkdir -p $ROOT

RUN apt-get -qq update \
  && apt-get install -y \
    postgresql-client \
    bash \
    inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-prod}
EXPOSE 4000
WORKDIR $ROOT
ADD ./mix.exs ./mix.exs
ADD ./mix.lock ./mix.lock
RUN mix local.hex --force
RUN mix deps.get deps.compile

# Set image id
ARG IMAGE_ID
ENV IMAGE_ID $IMAGE_ID

LABEL project=pipelite
LABEL service=api
LABEL image_id=$IMAGE_ID

ADD ./ $ROOT
RUN mix compile

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD ["phoenix.server"]
