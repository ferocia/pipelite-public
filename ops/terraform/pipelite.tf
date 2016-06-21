provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.pipelite.id}"
  vpc = false
}

resource "aws_security_group" "pipelite" {
  name = "${var.security_group_name}"

  # Allow HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.office_cidr}"
      "59.167.194.1/32"
    ]
  }

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = [
      "${var.office_cidr}"
      "59.167.194.1/32"
    ]
  }

  ingress {
    from_port = 1936
    to_port = 1936
    protocol = "tcp"
    cidr_blocks = [
      "${var.office_cidr}"
      "59.167.194.1/32"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pipelite"
    Group = "${var.resource_group_tag}"
  }
}

# Main instance template file
resource "template_file" "pipelite" {
  filename = "templates/pipelite_user_data.yml"

  vars {
    aws_region = "${var.aws_region}"
    config_bucket = "${aws_s3_bucket.config.id}"
  }
}

resource "aws_iam_role" "pipelite" {
  name = "pipelite"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "get_config" {
  name = "get_config"
  role = "${aws_iam_role.pipelite.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.config.id}"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.config.id}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_instance" {
  name = "ec2_instance"
  role = "${aws_iam_role.pipelite.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudformation:DescribeStackResource",
        "ec2:DescribeTags"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "pipelite" {
  name = "Pipelite"
  roles = ["${aws_iam_role.pipelite.name}"]
}

resource "aws_instance" "pipelite" {
  ami = "${lookup(var.docker-amis, var.aws_region)}"
  instance_type = "${var.pipelite_instance_type}"
  user_data = "${template_file.pipelite.rendered}"
  security_groups = ["${aws_security_group.pipelite.name}"]
  key_name = "${var.deployer_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.pipelite.id}"

  tags = {
    Name = "pipelite"
    Group = "${var.resource_group_tag}"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
}
