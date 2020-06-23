
data "aws_security_group" "instance-sg" {

  filter {
	name = "tag:env"
	values = [var.sg_env]
  }

  filter {
    name = "tag:Name"
    values = [var.sg_name]
  }

}
