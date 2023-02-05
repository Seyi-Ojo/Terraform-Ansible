//SETTING UP THE EC2 INSTANCES
resource "aws_instance" "web-server1" {
  ami               = "ami-06878d265978313ca"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  security_groups   = [aws_security_group.hmw-instances-sg.id]
  associate_public_ip_address   = true
  key_name          = "${var.key_pair_name}"
  subnet_id         = aws_subnet.hmw-public-subnets1.id

  tags = {
    Name = "Instance 1"
  }
}

resource "aws_instance" "web-server2" {
  ami               = "ami-06878d265978313ca"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1b"
  security_groups   = [aws_security_group.hmw-instances-sg.id]
  associate_public_ip_address   = true
  key_name          = "${var.key_pair_name}"
  subnet_id         = aws_subnet.hmw-public-subnets2.id

  tags = {
    Name = "Instance 2"
  }
}

resource "aws_instance" "web-server3" {
  ami               = "ami-06878d265978313ca"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1c"
  security_groups   = [aws_security_group.hmw-instances-sg.id]
  associate_public_ip_address   = true
  key_name          = "${var.key_pair_name}"
  subnet_id         = aws_subnet.hmw-public-subnets3.id

  tags = {
    Name = "Instance 3"
  }
}

// IMPORTING IP ADDRESSES INTO HOST-INVENTORY FILE

output "host_ips" {
  value = "${join("\n", [
    aws_instance.web-server1.public_ip,
    aws_instance.web-server2.public_ip,
    aws_instance.web-server3.public_ip
  ])}"
}

resource "local_file" "inventory" {
    filename = "host-inventory"
    content  = <<EOT
       [all]
       ${aws_instance.web-server1.public_ip}
       ${aws_instance.web-server2.public_ip}
       ${aws_instance.web-server3.public_ip}    
    EOT
}

resource "null_resource" "run_command" {
  provisioner "local-exec" {
    command =  "ansible-playbook -i host-inventory playbook.yaml --private-key=keys/hch-bkp.pem"
  }
}





