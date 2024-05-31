

# Create a new EC2 instance
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-04b70fa74e45c3917" 
  instance_type = "t2.micro"     
  key_name      = "PracticeKP" 

  tags = {
    Name = "Jenkins Instance"
  }
}

# Provision the EC2 instance with Jenkins
resource "null_resource" "jenkins_provisioner" {
  depends_on = [aws_instance.jenkins_instance]

  connection {
    host        = aws_instance.jenkins_instance.public_ip
    type        = "ssh"
    user        = "ec2-user" # Change user if using a different AMI
    private_key = file("c:/Users/temmy/Downloads/PracticeKP.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y java-1.8.0-openjdk-devel",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }
}
