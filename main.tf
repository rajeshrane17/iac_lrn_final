resource "aws_ami_from_instance" "aws-ami-instance" {
  for_each                = local.instance_name
  name                    = "${each.key}-26012022"
  provider                = aws.qa
  source_instance_id      = each.value
  snapshot_without_reboot = true

  tags = {
    Source = "Terraform"
    Name   = "${each.key}-26012022"
  }
}
resource "aws_ami_launch_permission" "aws_ami_permission" {
  for_each   = aws_ami_from_instance.aws-ami-instance
  provider   = aws.qa
  image_id   = each.value.id
  account_id = "889340682220"

  depends_on = [aws_ami_from_instance.aws-ami-instance]
}

locals {
  ami_data = { for name,values in aws_ami_launch_permission.aws_ami_permission : name => values.image_id  }
}



resource "aws_instance" "console-apache" {
  count = 2
  ami = lookup(local.ami_data, var.console-apache)
  instance_type = "t2.micro"
  # subnet_id = count.index % 2 == 0 ? var.subnet_ids[0] : var.subnet_ids[1]
  # availability_zone = count.index % 2 == 0 ? var.azs[0] : var.azs[1]
  # vpc_security_group_ids = [var.console-sg]

  tags = {
     "Name" = "${var.console-apache}-PG"
   }
}





