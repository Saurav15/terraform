#  Specifies a global block for meta-configuration in Terraform.
terraform {
  # Defines the provider requirements for the configuration.
  required_providers {
    #  Identifier for the AWS provider
    aws = {
      #   The source attribute specifies the location from where the provider should be downloaded. For the AWS provider, hashicorp/aws indicates that the provider is maintained by HashiCorp and is available on the Terraform Registry.
      source = "hashicorp/aws"
      #    ~> is called the pessimistic constraint operator, which allows upgrades up to the next major version.
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
# Provider: Defines provider-specific configurations.
provider "aws" {
  region = var.region
}


resource "aws_instance" "myFirstServer" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  #   key_name = "terraform-home-pc"
  #   security_groups = "open-port-80-22-from-anywhere"

  tags = {
    Name = "SampleServer"
  }
}

# terraform plan, terraform apply, terraform destroy
# terraform validate to validate the file.
