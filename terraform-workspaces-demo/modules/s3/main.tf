resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-${terraform.workspace}"  # Bucket name includes workspace
  acl    = "private"

  tags = {
    Name      = "${var.name}-${terraform.workspace}"
    Workspace = terraform.workspace
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
