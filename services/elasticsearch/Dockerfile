FROM elasticsearch:2.2.0
MAINTAINER Justin Morris <justin.morris@ferocia.com.au>

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT pipelite

# Set image id
ARG IMAGE_ID
ENV IMAGE_ID $IMAGE_ID

LABEL project=pipelite
LABEL service=elasticsearch
LABEL image_id=$IMAGE_ID

ENV ES_HEAP_SIZE 128m
ENV MAX_LOCKED_MEMORY 100000
ENV ES_JAVA_OPTS -server

ADD elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
