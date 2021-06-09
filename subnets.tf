resource "aws_subnet" "subnet_1_jen" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs_jen.names, 0)
  vpc_id            = aws_vpc.jenkins-vpc.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_2_jen" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs_jen.names, 1)
  vpc_id            = aws_vpc.jenkins-vpc.id
  cidr_block        = "10.0.2.0/24"
}
