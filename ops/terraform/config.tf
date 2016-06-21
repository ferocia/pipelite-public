resource "aws_s3_bucket" "config" {
  bucket = "ferocia-pipelite-config"
  acl = "private"
  force_destroy = true

  tags = {
    Name = "pipelite"
    Group = "${var.resource_group_tag}"
  }
}

resource "aws_s3_bucket_object" "git_config" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "git/conf/config"
  source = "files/git/conf/config"
}

resource "aws_s3_bucket_object" "git_deploy_hook" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "git/conf/hooks/post-receive"
  source = "files/git/conf/hooks/post-receive"
}

resource "aws_s3_bucket_object" "consul_config" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "consul-server/conf/consul-config.json"
  source = "files/consul-server/conf/consul-config.json"
}

resource "aws_s3_bucket_object" "start_consul_server_script" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "consul-server/bin/start"
  source = "files/consul-server/bin/start"
}

resource "aws_s3_bucket_object" "haproxy_template" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "haproxy/conf/container/consul-template.conf"
  source = "files/haproxy/conf/container/consul-template.conf"
}

resource "aws_s3_bucket_object" "haproxy_dockerfile" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "haproxy/conf/container/Dockerfile"
  source = "files/haproxy/conf/container/Dockerfile"
}

resource "aws_s3_bucket_object" "haproxy_entrypoint" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "haproxy/conf/container/entrypoint.sh"
  source = "files/haproxy/conf/container/entrypoint.sh"
}

resource "aws_s3_bucket_object" "haproxy_config" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "haproxy/conf/container/haproxy.ctmpl"
  source = "files/haproxy/conf/container/haproxy.ctmpl"
}

resource "aws_s3_bucket_object" "start_haproxy_script" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "haproxy/bin/start"
  source = "files/haproxy/bin/start"
}

resource "aws_s3_bucket_object" "start_registrator_script" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "registrator/bin/start"
  source = "files/registrator/bin/start"
}

resource "aws_s3_bucket_object" "ssl_certificate" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "ssl/certificate.pem"
  source = "files/ssl/certificate.pem"
}
