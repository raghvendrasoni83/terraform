terraform {
	required_providers {
	  aws = "~> 2.67"
	}
}

module "my_ami" {
	source 		  	 = "../../../modules/ami/"
	profile			 = "alibi"
	region			 = "ap-south-1"
	ami_id 		  	 = "ami-0a74bfeb190bd404f"
	instance_type 	 	 = "t2.micro"
	sg 			 = ["launch-wizard-2"]
	key 		  	 = "thanos_chacha"
	name_tag	  	 = "instance-tmp"
	creator_tag   		 = "raghvendra"
	env_tag		     	 = "perf"
	role_tag		 = "ami-launch"
	purpose_tag		 = "daga"
	private_key 		 = "/Users/raghvendrasoni/Downloads/thanos_chacha.pem"
	user 			 = "ec2-user"
	private_key_path 	 = "/Users/raghvendrasoni/Desktop/practice/terraform/keys/id_rsa"
	ssh_config_loc   	 = "/Users/raghvendrasoni/Desktop/practice/terraform/keys/config"
	ami_name		 = "http-server"
}
