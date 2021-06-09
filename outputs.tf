/*output "Deploy-Node-Public-IP" {
  value = aws_instance.deploy.public_ip
}

output "Deploy-Node-Public-DNS" {
  value = aws_instance.deploy.public_dns
}

output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}
*/
output "Jenkins-Node-Public-IP" {
  value = aws_instance.jenkins.public_ip
}

output "Jenkins-Node-Public-DNS" {
  value = aws_instance.jenkins.public_dns
}
