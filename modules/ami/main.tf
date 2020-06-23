provider "aws"{

  region = var.region
  profile = var.profile

}

resource "aws_instance" "ami_bin" {
  ami = var.ami_id
  instance_type = var.instance_type
  security_groups = ["${data.aws_security_group.instance-sg.id}"]
  key_name = var.key

  tags = {
    Name = var.name_tag
    Creator = var.creator_tag
    Env = var.env_tag
    Role = var.role_tag
  }

  connection {
    type = "ssh"
    user = var.user
    private_key = file(var.private_key)
    host = aws_instance.ami_bin.public_ip
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum install git httpd policycoreutils-python-utils -y",
    "sudo chmod 777 /tmp"
    ]
  }

  provisioner "file" {
    source      = var.private_key_path
    destination = "/tmp/id_rsa"
  }

  provisioner "file" {
    source      = var.ssh_config_loc
    destination = "/tmp/config"
  }

}

resource "null_resource" "cmd"{

  depends_on = [
    aws_instance.ami_bin
  ]

  connection {
    type = "ssh"
    user = var.user
    private_key = file(var.private_key)
    host = aws_instance.ami_bin.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/id_rsa /root/.ssh",
      "sudo mv /tmp/config /root/.ssh",
      "sudo chown -R root:root /root/.ssh",
      "sudo chmod 600 /root/.ssh/id_rsa",
      "sudo chmod 600 /root/.ssh/config",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/",
    ]
  }
}

resource "aws_ami_from_instance" "final_image"{

  depends_on = [
    null_resource.cmd
  ]

  name = var.ami_name
  source_instance_id = aws_instance.ami_bin.id
  snapshot_without_reboot = "false"

  tags = {
    creator = var.creator_tag
    purpose = var.purpose_tag
  }
}
