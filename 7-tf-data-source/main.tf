terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# data_source allows you to query and retrieve information defined outside of Terraform or defined by another Terraform configuration. Can be used for finding the ID of a VPC, AMI, or security group.

# Example: While creating the EC2 we needed to go and fetch the AMI id from console, instead of doing that we can fetch the AMI id from the code itself.
# There can be many results for some searches thus we need filter to filter through those results.
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Output to view the data_source fetched resultss
output "ami_name" {
  value = data.aws_ami.latest_amazon_linux.image_id
}

# Example 2: Fetch the existing security group and attach it to your ec2
data "aws_security_group" "http-sg" {
  name = "open-port-80-22-from-anywhere"
}

output "sg-name" {
  description = "Security group id"
  value       = data.aws_security_group.http-sg
}

# resource "aws_instance" "dynamic-sg-ec2" {
#   ami             = data.aws_ami.latest_amazon_linux.id
#   instance_type   = "t2.micro"
#   security_groups = [data.aws_security_group.http-sg.id]

#   tags = {
#     Name = "tf-data-source"
#   }
# }

# Example 3: Get All the available AZ in a region.
data "aws_availability_zones" "az-present" {
  state = "available"
}

output "az-available" {
  value = data.aws_availability_zones.az-present
}

# Example 4: Get current user account details
data "aws_caller_identity" "user-details" {

}

output "aws_caller_identity" {
  value = data.aws_caller_identity.user-details
}

# Example 5: Get current region
data "aws_region" "current-region" {
}

output "current-region-name" {
  value = data.aws_region.current-region
}
