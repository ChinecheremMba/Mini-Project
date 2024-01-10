
resource "aws_instance" "ass-1" {
  count         = 3
  ami           = var.ami  
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [ aws_security_group.ass-security-grp-rule.id ]
  subnet_id = aws_subnet.ass.public-subnet1
  availability_zone = var.availability_zone["a"]
  connection {
    type = "ssh"
    host ="self.public_ip"
    private_key = file("/")
  }
  tags = {
    Name = "ass-1"
    source = "terraform"
  }
}


resource "aws_instance" "ass-2" {
  count         = 3
  ami           = var.ami  
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [ aws_security_group.ass-security-grp-rule.id ]
  subnet_id = aws_subnet.ass.public-subnet2
  availability_zone = var.availability_zone["b"]
  connection {
    type = "ssh"
    host ="self.public_ip"
    private_key = file("/")
  }
  tags = {
    Name = "ass-2"
    source = "terraform"
  }
}


resource "aws_instance" "ass-3" {
  count         = 3
  ami           = var.ami  
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [ aws_security_group.ass-security-grp-rule.id ]
  subnet_id = aws_subnet.ass.public-subnet1
  availability_zone = var.availability_zone["a"]
  connection {
    type = "ssh"
    host ="self.public_ip"
    private_key = file("/")
  }
  tags = {
    Name = "ass-3"
    source = "terraform"
  }
}

resource "local_file" "ip_address" {
    filename = "/root/miniproject/ansible-playbook/host-inventory"
    content = <<EOT
    $(aws_instance.ass-1.public_ip)
    $(aws_instance.ass-1.public_ip)
    $(aws_instance.ass-1.public_ip)
     EOT
}

resource "aws_elb" "my_elb" {
  name               = "my-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances = aws_instance.ec2_instance[*].id
}

resource "aws_route53_zone" "my_domain" {
  name = "chinecheremmba.co"  
}

resource "aws_route53_record" "terraform_test_record" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "terraform-test"
  type    = "A"

  alias {
    name                   = aws_elb.my_elb.dns_name
    zone_id                = aws_elb.my_elb.zone_id
    evaluate_target_health = true
  }
}

