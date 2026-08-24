# This main.tf file creates two module-based components and two AWS resources: 
# a EC2 instance and a Security Group are created using module-based components, while 
# an EBS volume, and an EBS volume attachment are created using AWS resources.

module "ec2_instance_27" {
source = "terraform-aws-modules/ec2-instance/aws"

name = "${var.name}-${var.envt}-ec2"

ami = data.aws_ami.aws_linux_ami.id
associate_public_ip_address = true
instance_type = "t3.micro"
key_name = "${var.name}-key-pair"
monitoring = true
subnet_id = data.aws_subnet.selected.id

create_security_group = false
vpc_security_group_ids = [module.security_group_27.id]

tags = {
Terraform = "true"
Environment = var.envt
}
}


# The Security Group is created in the VPC that was found by the VPC data source.
module "security_group_27" {
source = "terraform-aws-modules/security-group/aws"
name = "${var.name}-${var.envt}-sg"
description = "2.7.jl security group"
vpc_id = data.aws_vpc.selected.id

ingress_rules = {

    ssh = {
    ip_protocol = "tcp"
    from_port = 22
    cidr_ipv4 = "0.0.0.0/0"
    description = "SSH from anywhere"
    }

    http = {
    ip_protocol = "tcp"
    from_port = 80
    cidr_ipv4 = "0.0.0.0/0"
    description = "HTTP from anywhere"
    }

# The self-all rule allows all traffic from members of this Security Group. In production evnt,
# exposing SSH to the 0.0.0.0/0 or public internet is not recommended.
    self-all = {
    ip_protocol = "-1"
    referenced_security_group_id = "self"
    description = "All traffic from members of this SG"
    }
}

# The egress rule allows all outbound traffic to anywhere.
egress_rules = {
    all = {
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
    }
}

}

# ###

# The EBS volume is created in the same Availability Zone as the EC2 instance.
# The EBS volume references the EC2 module's Availability Zone
resource "aws_ebs_volume" "ebs_volume-27" {
  availability_zone = module.ec2_instance_27.availability_zone
  size              = 1
  type              = "gp3"
 
  tags = {
    Name        = "${var.name}-${var.envt}-ebs-volume"
    Environment = var.envt
  }
}

# The EBS volume attachment is created to attach the EBS volume to the EC2 instance.
# The attachment references both the EBS volume ID and the EC2 instance ID.
resource "aws_volume_attachment" "ebs_volume_attachment-27" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebs_volume-27.id
  instance_id = module.ec2_instance_27.id
}