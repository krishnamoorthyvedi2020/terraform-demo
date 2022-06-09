resource "aws_security_group" "my-security-group" {
  name        = "terraform-demo-security-group"
  description = "terraform-demo-security-group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "All"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "All"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform"
  }
}


#create a vpc
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    "Name" = "Terraform"
  }
}
   
 #create public subnet  
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-south-1a"

    tags = {
    "Name" = "Terraform"
  }

}

#create Internet Gateway and attach to vpc
resource "aws_internet_gateway" "my-IGW" {
   vpc_id = aws_vpc.main.id
   
    tags = {
    "Name" = "Terraform"
  }

}

#route table for public subnet 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-IGW.id
  } 

  depends_on = [aws_internet_gateway.my-IGW]
  
    tags = {
    "Name" = "Terraform"
  }

}

#Route table association with public subnet's
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public-route-table.id
}
