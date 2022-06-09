
#Europe - Stockholm - eu-north-1
provider "aws" {
     region = "eu-north-1"
     access_key = "XXXXXX"
     secret_key = "XXXXX"
     alias = "europe"
}

resource "aws_instance" "europe-ec2" {
  provider = aws.europe # respective provider with region
  count = 2
  ami= "ami-01ded35841bc93d7f"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet.id
  #vpc_security_group_ids = ["sg-0490cb0718a91b5bc"] #hardcoded default security group with inbound and outbound open to all traffic
   vpc_security_group_ids = [aws_security_group.my-security-group.id]
   associate_public_ip_address = "true"
   key_name="terraform-internal-demo"
   tags = {
     "Name" = "terraform-internal-demo"
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

output "instance_ip_europe" {
  value = aws_instance.europe-ec2[*].public_ip
}

