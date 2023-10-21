
## specific the provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region =  "us-east-1"
}

#creating a VPC
resource "aws_vpc" "main" {
    cidr_block = "11.0.0.0/16"

    tags = {
        Name = "D5.1_VPC"
    }
}

# creating security group
resource "aws_security_group" "d5_1_sg" {
    name = "d5_sg"
    description = "tcp protocol for D5" 

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.main.id

    tags = {
        "Name" : "d5.1_sg"
        "Terraform" : "true"
    }
}
  
#creating a Public Subnet
resource "aws_subnet" "pubsubnet_1"{
    vpc_id =  aws_vpc.main.id
    cidr_block = "11.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "D5.1 Public Subnet 1"
    }
}

resource "aws_subnet" "pubsubnet_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "11.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "D5.1 Public Subnet 2"
    }
}

#creating the instances
resource "aws_instance" "pub1" {
  ami = var.ami
  instance_type =  var.instance_type
  vpc_security_group_ids = ["${aws_security_group.d5_1_sg.id}"]
  subnet_id = "${aws_subnet.pubsubnet_1.id}"
  associate_public_ip_address = true
  # refering to the key name I created
  key_name = "d5.1"


  user_data = "${file("deployjenkins.sh")}"
  tags = {
    "Name" : "d5.1_Jenkins_EC2"
  }
}


resource "aws_instance" "pub2" {
  ami = var.ami
  instance_type =  var.instance_type
  vpc_security_group_ids = ["${aws_security_group.d5_1_sg.id}"]
  subnet_id = "${aws_subnet.pubsubnet_2.id}"
  associate_public_ip_address = true
  key_name = "d5.1"

  user_data = "${file("deploypython.sh")}"
  tags = {
    "Name" : "d5.1_instance_1"
  }
}

resource "aws_instance" "pub3" {
  ami = var.ami
  instance_type =  var.instance_type
  vpc_security_group_ids = ["${aws_security_group.d5_1_sg.id}"]
  subnet_id = "${aws_subnet.pubsubnet_2.id}"
  associate_public_ip_address = true
  key_name = "d5.1"

  user_data = "${file("deploypython.sh")}"
  tags = {
    "Name" : "d5.1_instance_2"
  }
}

# creating interent gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "d5_igw"
    }
}

# creating route table
resource "aws_route" "routetable" {
    route_table_id = aws_vpc.main.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


