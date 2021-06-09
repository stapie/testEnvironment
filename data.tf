data "aws_ami" "latest_amazon_linux" {
  provider    = aws.region-master
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_ubuntu_linux" {
  provider    = aws.region-master
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}


data "aws_availability_zones" "azs_jen" {
  provider = aws.region-master
  state    = "available"
}
