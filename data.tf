data "aws_vpc" "selected" {
filter {
name = "tag:Name"
values = ["*vpc-ce13*"]
}
}


data "aws_ami" "aws_linux_ami" {
most_recent = true
owners = ["amazon"]
filter {
name = "name"
values = ["al2023-ami-2023*-x86_64"]
}

filter {
name = "virtualization-type"
values = ["hvm"]
}
}


data "aws_subnet" "selected" {
filter {
name = "tag:Name"
values = ["*-ce13-public*1a"]
}
}