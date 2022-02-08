output "web-ip" {
  value       = aws_instance.WEB_Server.public_ip
  description = "output the public ip of web server"
}
output "mysql-ip" {
  value       = aws_instance.Mysql_Server.private_ip
  description = "output the priavte ip of mysql server"
}