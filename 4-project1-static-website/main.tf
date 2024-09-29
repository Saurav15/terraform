terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "rand-id-generate" {
  byte_length = 6
}

# Create an s3 bucket
resource "aws_s3_bucket" "static-website-tf" {
  bucket = "static-website-hosting-tf-${random_id.rand-id-generate.hex}"
}

# Update the s3 public access options
resource "aws_s3_bucket_public_access_block" "name" {
  bucket = aws_s3_bucket.static-website-tf.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add policy that makes reding of aws objects possible for everyone on the internet
resource "aws_s3_bucket_policy" "s3-bucket-policy" {
  bucket = aws_s3_bucket.static-website-tf.bucket
  # There are various ways in which we can add the policy to the aws and one of them is JSONENCODE which takes our string and encodes.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.static-website-tf.bucket}/*"
      }
    ]
  })
}

# Upload index.html file to s3
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static-website-tf.bucket
  key    = "index.html"
  source = "./index.html"
  #   This is needed so that s3 can know what type of file this is
  content_type = "text/html"
}

# Upload styles.css to s3.
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.static-website-tf.bucket
  key    = "styles.css"
  source = "./styles.css"
  #   This is needed so that s3 can know what type of file this is
  content_type = "text/css"
}

# Enable the static website hosting in s3
resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.static-website-tf.id

  index_document {
    suffix = aws_s3_object.index_html.key
  }
}


output "endpoint-url" {
  value = aws_s3_bucket_website_configuration.website-config.website_endpoint
}
output "endpoint-domain" {
  value = aws_s3_bucket_website_configuration.website-config.website_domain
}
