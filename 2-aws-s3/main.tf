terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    # Package for generating random numbers
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Many times we need to generate random string so we can assign them as the name. Here as bucket name has to be globally unique, instead of trial and error we can generate a random number
resource "random_id" "rand_id_generate" {
  byte_length = 8
}

# Create new S3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "hello-demo-user-${random_id.rand_id_generate.hex}"
}


# Upload File to recently created s3 bucket
resource "aws_s3_object" "bucket-data" {
  # Name of the bucket which needs to add this file
  bucket = aws_s3_bucket.demo-bucket.bucket
  #   Name of the file in s3.
  key = "firstObjectUpload"
  #   Loaction of file in local env
  source = "./uploadFile.txt"
}


output "rand_id_output" {
  value = random_id.rand_id_generate.hex
}
