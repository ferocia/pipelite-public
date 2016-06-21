FROM haproxy:1.5
MAINTAINER Justin Morris <justin.morris@ferocia.com.au>

# Install consul-template
RUN apt-get update -y && apt-get install curl -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -L https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz > /tmp/consul-template.tar.gz
RUN tar -C /usr/local/bin --strip-components 1 -zxf /tmp/consul-template.tar.gz
RUN chmod +x /usr/local/bin/consul-template

# Add config and template
ADD consul-template.conf /etc/consul-template/config.conf
ADD haproxy.ctmpl /etc/consul-template/templates/haproxy.ctmpl

# Copy in self signed development certificate
COPY ./ssl/pipelitedev.pem /etc/ssl/private/certificate.pem

ADD entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
