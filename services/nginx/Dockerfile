FROM nginx:1.9.5
MAINTAINER Justin Morris <justin.morris@ferocia.com.au>

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT pipelite

# Install consul-template
RUN \
  apt-get update -y \
  && apt-get install curl -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && curl -L https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz | tar -C /usr/local/bin --strip-components 1 -zxf - \
  && chmod +x /usr/local/bin/consul-template

# Add config and template
RUN mkdir -p /etc/consul-template
ADD consul-template.conf /etc/consul-template/config.conf
ADD sites.ctmpl /etc/consul-template/templates/sites.conf.ctmpl

# Add nginx confs
RUN touch /etc/nginx/sites.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD proxy.conf /etc/nginx/proxy.conf

ADD htpasswd /etc/nginx/.htpasswd

# Set image id
ARG IMAGE_ID
ENV IMAGE_ID $IMAGE_ID

LABEL project=pipelite
LABEL service=nginx
LABEL image_id=$IMAGE_ID

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD []
