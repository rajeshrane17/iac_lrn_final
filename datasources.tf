data "aws_instances" "test_instances" {
   provider = aws.qa
   instance_state_names = ["running"]

    instance_tags = {
    Source = "Terraform",
    ENV    = "QALRN-RDS-POC"
  }

}

data "aws_instance" "example" {
  # iterate over subset of desired instances by ID
  provider = aws.qa
  for_each = toset(data.aws_instances.test_instances.ids)

  instance_id = each.value
}


locals {
  instance_name = { for id, attributes in data.aws_instance.example :  attributes.tags["Name"] => id }
}

