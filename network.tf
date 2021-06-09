
resource "aws_vpc" "jenkins-vpc" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "jenkins-vpc"
  }
}


resource "aws_internet_gateway" "igw_jen" {
  provider = aws.region-master
  vpc_id   = aws_vpc.jenkins-vpc.id
}

resource "aws_route_table" "internet_route_jen" {
  provider = aws.region-master
  vpc_id   = aws_vpc.jenkins-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_jen.id
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_main_route_table_association" "set-master-default-rt-assoc_jen" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.jenkins-vpc.id
  route_table_id = aws_route_table.internet_route_jen.id
}
