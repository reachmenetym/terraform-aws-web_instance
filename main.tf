resource "aws_instance" "web" {
    count = var.provision_web == "true" ? var.web_instance_count : 0
    ami           = var.ami_id
    instance_type = var.web_instance_type
    vpc_security_group_ids = [ aws_security_group.web_sg.id ]
    root_block_device {
        volume_size = var.web_volume["volume_size"]
        volume_type = var.web_volume["volume_type"] 
        # device_name = var.app_volume["device_name"] 
    }
    user_data = var.userdata
    key_name = var.ssh_key_name

    tags = {
        Name = "WebServer-${count.index+1}"
    }

    
}


resource "aws_security_group" "web_sg" {
  name        = "WebServer_SG"
  description = "Allow Traffic to WebServer"
  vpc_id      = var.vpc_id == "default" ? data.aws_vpc.default.id : var.vpc_id

  tags = {
    Name = "WebServerSG"
  }
}

resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  security_group_id = "${aws_security_group.web_sg.id}"
  description      = "SSH traffic"
}

resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  security_group_id = "${aws_security_group.web_sg.id}"
  description      = "Web traffic"
}

resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  security_group_id = "${aws_security_group.web_sg.id}"
  description      = "Secure Web traffic"
}

resource "aws_security_group_rule" "rule4" {
  type              = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "${aws_security_group.web_sg.id}"
    description      = "Allow All Egress Traffic"
  }



data "aws_vpc" "default" {
  default = true
}