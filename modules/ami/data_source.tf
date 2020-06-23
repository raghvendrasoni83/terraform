data "aws_ami" "myami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = tag:creator
    value = aws_ami_from_instance.final_image.
  }

  filter {
    name = tag:purpose
    value = aws_ami_from_instance.final_image.
  }
  
}


data "aws_security_group" "instance-sg" {

  filter {
	name = tag:env
	value = var.sg_env
  }

  filter {
    name = tag:Name
    value = var.sg_Name
  }

}