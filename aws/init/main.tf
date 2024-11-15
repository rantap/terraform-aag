provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket        = "${var.project}-state-bucket"
  force_destroy = true
}

resource "aws_dynamodb_table" "state_lock" {
  name           = "terraform-state-lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}