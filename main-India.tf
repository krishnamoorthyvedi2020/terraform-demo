terraform {
  required_version = ">1"
}

#India - Mumbai region
provider "aws" {
     region = "ap-south-1"
     access_key = "XXXXX"
     secret_key = "XXXXX"
}

resource "aws_instance" "mumbai-ec2" {
  count = 3
  ami= "ami-0756a1c858554433e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet.id
  #vpc_security_group_ids = ["sg-0490cb0718a91b5bc"] #hardcoded default security group with inbound and outbound open to all traffic
   vpc_security_group_ids = [aws_security_group.my-security-group.id]
   associate_public_ip_address = "true"
   key_name="terraform-internal-demo"
   tags = {
     "Name" = "terraform-internal-demo-mumbai"
     "Name"= "Terraform- ${count.index}"
   }

    provisioner "remote-exec" {
    inline = [
        "sudo apt update --yes",
        "sudo apt install nginx --yes",
        "sudo ufw allow 'Nginx HTTP'",
        "sudo ufw status"
    ]
    }

    connection {
            type     = "ssh"
            user     = "ubuntu"
            # key pair should be created manually and saved in location where this resource is created
            private_key= file("./terraform-internal-demo.pem")
            host     = self.public_ip
        }

}

output "instance_ip" {
  value = aws_instance.mumbai-ec2[*].public_ip
}

