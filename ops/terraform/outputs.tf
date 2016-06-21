output "pipelite.public_ip" {
  value = "${aws_eip.lb.public_ip}"
}

output "pipelite.git_deploy_remote" {
  value = "ubuntu@${aws_eip.lb.public_ip}:/var/git/pipelite.git"
}
