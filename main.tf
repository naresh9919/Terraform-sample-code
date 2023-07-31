provider "aws" {
  region = var.location
}

resource "aws_instance" "Jenkins-instance" {
  ami           = var.os-name
  instance_type = var.instance-type
  key_name = var.key-pair
  subnet_id = aws_subnet.Demo-web-public-subent-1a.id
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

 tags = {
    Name = "Jenkins-instance"
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt install openjdk-17-jre -y
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  EOF
}

# creating vpc

resource "aws_vpc" "Demo-vpc" {
    cidr_block = var.vpc-cidr
    tags = {
      Name = "Demo-vpc"
    }
  
}

resource "aws_subnet" "Demo-web-public-subent-1a" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet1-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az1
    tags = {
      Name = "Demo-web-public-subent-1a"
    }
  
}

resource "aws_subnet" "Demo-app-public-subent-1a" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet2-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az2
    tags = {
      Name = "Demo-app-public_subent_1a"
    }
  
}

resource "aws_subnet" "Demo-db-private-subent-1a" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet3-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az3
    tags = {
      Name = "Demo-db-public_subent_1a"
    }
  
}

resource "aws_subnet" "Demo-web-public-subent-1b" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet4-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az4
    tags = {
      Name = "Demo-web-public-subent-1b"
    }
  
}

resource "aws_subnet" "Demo-app-private-subent-1b" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet5-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az5
    tags = {
      Name = "Demo-app-private-subent-1b"
    }
  
}

resource "aws_subnet" "Demo-db-private-subent-06" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    cidr_block = var.subnet6-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.subent_az6
    tags = {
      Name = "Demo-db-private-subent-1b"
    }
  
}

//Creating a Internet Gateway

resource "aws_internet_gateway" "Demo-igw" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    tags = {
      Name = "Demo-igw"
    }
}

// Create a route table 

resource "aws_route_table" "Demo-public-rt" {
    vpc_id = "${aws_vpc.Demo-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.Demo-igw.id}"
    }
    tags = {
      Name = "Demo-public-rt"
    }
}

// Associate subnet with routetable 

resource "aws_route_table_association" "Demo-rta-public-subent-1" {
    subnet_id = "${aws_subnet.Demo-web-public-subent-1a.id}"
    route_table_id = "${aws_route_table.Demo-public-rt.id}"
  
}

resource "aws_route_table_association" "Demo-rta-public-subent-2" {
    subnet_id = "${aws_subnet.Demo-web-public-subent-1b.id}"
    route_table_id = "${aws_route_table.Demo-public-rt.id}"
  
}
// create a security group

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  vpc_id      = aws_vpc.Demo-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}
