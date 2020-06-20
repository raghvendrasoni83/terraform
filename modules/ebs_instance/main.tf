provider "aws"{

  region = "ap-south-1"
  profile = "alibi"

}


resource "aws_instance" "first_instance" {

  ami = "ami-0a74bfeb190bd404f"
  instance_type = "t2.micro"
  key_name = "thanos_chacha"
  security_groups = ["launch-wizard-2"]
//  volume_size = "5GiB"

  tags = {
    Name = "perfect"
  }

  ebs_block_device {
    device_name = "/dev/sdd"
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = "true"

  }

  connection {

    type = "ssh"
    user = "ec2-user"
    private_key = file("/Users/raghvendrasoni/Downloads/thanos_chacha.pem")
    host = aws_instance.first_instance.public_ip

  }

  provisioner "remote-exec" {

    inline = [

      "sudo yum install httpd git policycoreutils-python-utils -y",
      "sudo mkfs.ext4 /dev/xvdd",
      "sudo mount /dev/xvdd /var/www/html",
      "sudo chmod 777 /tmp"

    ]

  }

  provisioner "file" {
    source      = "/Users/raghvendrasoni/Desktop/practice/terraform/keys/id_rsa"
    destination = "/tmp/id_rsa"
  }

  provisioner "file" {
    source      = "/Users/raghvendrasoni/Desktop/practice/terraform/keys/config"
    destination = "/tmp/config"
  }

}


resource "null_resource" "key" {

  depends_on = [
    aws_instance.first_instance
  ]

  connection {

    type = "ssh"
    user = "ec2-user"
    private_key = file("/Users/raghvendrasoni/Downloads/thanos_chacha.pem")
    host = aws_instance.first_instance.public_ip

  }
  
  provisioner "remote-exec" {

    inline = [

      "sudo mv /tmp/id_rsa /root/.ssh",
      "sudo mv /tmp/config /root/.ssh",
      "sudo chown -R root:root /root/.ssh",
      "sudo chmod 600 /root/.ssh/id_rsa",
      "sudo chmod 600 /root/.ssh/config"

    ]

  }

}

resource "null_resource" "service" {
  
  depends_on = [
    null_resource.key
  ]

  connection {

    type = "ssh"
    user = "ec2-user"
    private_key = file("/Users/raghvendrasoni/Downloads/thanos_chacha.pem")
    host = aws_instance.first_instance.public_ip

  }

  
  provisioner "remote-exec" {

    inline = [

      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/",
      "sudo git clone git@github.com:raghvendrasoni83/web-server-test-terraform.git /var/www/html",
//      "sudo semanage fcontext -a -t httpd_sys_content_t /vat/www/html/",
      "sudo chmod 644 /var/www/html/*"

    ]

  }

}

resource "null_resource" "selinux"{
  
  depends_on = [

   null_resource.service

  ]

  provisioner "remote-exec" {

    inline = [

      "sudo restorecon -R -v /var/www/html"

    ]
  }

}

resource "null_resource" "firefox" {

  depends_on = [

    null_resource.selinux

  ]


   provisioner "local-exec" {

    command = "open /Applications/Firefox.app -g http://${aws_instance.first_instance.public_ip}/"

  }

}


output "my_instance"{
 value = "${aws_instance.first_instance.id}"
}
