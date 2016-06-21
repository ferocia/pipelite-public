FROM node:4.1.2
MAINTAINER Justin Morris <justin.morris@ferocia.com.au>

ENV ROOT /container/app
RUN mkdir -p $ROOT

# Use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV:-production}
ADD ./package.json /container/package.json
ADD ./npm-shrinkwrap.json /container/npm-shrinkwrap.json
RUN npm install --quiet -g npm@3.3.8
RUN mkdir /container/node_modules && cd /container && npm install --quiet
ENV NODE_PATH /container/node_modules
ENV PATH $NODE_PATH/.bin:$PATH

# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible
EXPOSE 5000
WORKDIR $ROOT
ADD ./ $ROOT

# Set image id
ARG IMAGE_ID
ENV IMAGE_ID $IMAGE_ID

LABEL project=pipelite
LABEL service=ui
LABEL image_id=$IMAGE_ID

# Make a directory to conatain public html and assets.
ENV STATIC_PATH /mnt/containers/ui/static/
RUN mkdir -p $STATIC_PATH
RUN npm run compile
VOLUME $STATIC_PATH

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD ["start"]
