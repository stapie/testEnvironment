resource "aws_lb" "jenkins-lb" {
  provider           = aws.region-master
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1_jen.id, aws_subnet.subnet_2_jen.id]
  tags = {
    Name = "Jenkins-LB"
  }
}

resource "aws_lb_target_group" "jenkins-lb-tg" {
  provider    = aws.region-master
  name        = "jenkins-lb-tg"
  port        = 8080
  target_type = "instance"
  vpc_id      = aws_vpc.jenkins-vpc.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 8080
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "jenkins-target-group"
  }
}

resource "aws_lb_listener" "jenkins-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.jenkins-lb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-lb-tg.id
  }
}

resource "aws_lb_target_group_attachment" "jenkins-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.jenkins-lb-tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}

resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow 443 and 80 traffic to Jenkins SG"
  vpc_id      = aws_vpc.jenkins-vpc.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
