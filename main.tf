provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "region-master"
}

resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "jenkins" {
  provider                    = aws.region-master
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1_jen.id


  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' playbook.yaml
EOF
  }

/*  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install \ apt-transport-https \ ca-certificates \ curl \ gnupg \ lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run -p 8080:8080 -p 50000:50000 jenkins
EOF
*/
  tags = {
    Name = "jenkins_master"
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc_jen]
}
