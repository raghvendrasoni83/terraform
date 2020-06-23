variable "profile" {
	description = "profile name to get valid credentials of aws account"
}

variable "region" {
	description = "aws region will be used by terraform"
	default		= "ap-south-1"
}

variable "ami_id" {
	description = "ami will be used to launch the instance"
//	condition	= substr(var.ami_id, 0, 4) == "ami-"
//	error_message = "The image_id value must be a valid AMI id, starting with \'ami-\'."
	default		= "ami-0a74bfeb190bd404f"
}

variable "instance_type" {
	description = "define your instance size"
	default		= "t2.micro"
}

variable "sg" {
	description = "security groups attach with the instance"
	type 		= list
	default		= ["${data.data.aws_security_group.instance-sg.id}"]
}

variable "key" {
	description = "private key to login into instance"
	default		= "thanos_chacha"
}

variable "private_key" {
	description = "use key to login into instance, while terraform make connection"
	default 	= "/Users/raghvendrasoni/Downloads/thanos_chacha.pem"
}

variable "user" {
	description = "ssh connection user"
	default		= "ec2-user"
}

variable "private_key_path" {
	description = "git repo private key"
	default 	= "/Users/raghvendrasoni/Desktop/practice/terraform/keys/id_rsa"
}

variable "ssh_config_loc" {
	description = "ssh configuration for github"
	default 	= "/Users/raghvendrasoni/Desktop/practice/terraform/keys/config"
}

variable "ami_name" {
	description = "final ami name"
	default 	= "myami"
}

variable "name_tag" {
	default		= "my-instance"
}

variable "creator_tag" {
	default		= "raghvendra"
}

variable "env_tag" {
	default 	= "perf"
}

variable "role_tag" {
	default 	= "dagami"
}

variable "purpose_tag" {
	default 	= "project"
}

variable "sg_env" {
	description = "get sgs which has env tag"
	default 	= "common"
}

variable "sg_Name" {
	description = "get sgs which has Name tag"
	default 	= "universal"
}
