# Handling remote state management, till now our state file was stored in the local but if 2 or more people are working together then it becomes impossible to work on same terraform file together. So instead of storing our state locally we will store it in s3.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  # The backend keyword in Terraform is used to define how Terraform stores the state of your infrastructure. We need to currently store our state in the s3
  backend "s3" {
    # Name of the bucket in which we need to store the state
    bucket = "hello-demo-user-ff66ba158963827c"
    # Key name
    key = "terraform-state-store"
    # As we specify these backend creds before we specify provider creds, we need to add region too where the bucket is present.
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
