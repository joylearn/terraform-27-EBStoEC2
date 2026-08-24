output "ec2_instance_id" {
  value = module.ec2_instance_27.id
}


output "security_group_id" {
  value = module.security_group_27.id
}

output "security_group_tags" {
  value = module.security_group_27.name
}

output "ebs_volume_id" {
  value = aws_ebs_volume.ebs_volume-27.id
}   

output "ebs_volume_tags" {
  value = aws_ebs_volume.ebs_volume-27.tags["Name"]
}

output "ebs_volume_attachment_id" {
  value = aws_volume_attachment.ebs_volume_attachment-27.id
}

# AWS does NOT support tags on aws_volume_attachment
