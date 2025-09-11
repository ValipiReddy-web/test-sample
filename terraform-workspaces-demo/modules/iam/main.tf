# Create IAM User
resource "aws_iam_user" "this" {
  name = "${var.user_name}-${terraform.workspace}"  # Workspace-aware name
  tags = {
    Workspace = terraform.workspace
  }
}

# Output the IAM user name
output "user_name" {
  value = aws_iam_user.this.name
}
