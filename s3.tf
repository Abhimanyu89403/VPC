resource "aws_s3_bucket" "my_bucket" {
    bucket = "abhi-mystatebucket-vpc-backend-state-file"

    tags = {
        owner = "Abhimanyu"
        purpose = "vpc_state_file"
    }
}
resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.my_bucket.id
    policy = jsonencode ([
        {
            Sid = "Terraform_state_share"
            Effect = "Allow"
            Principal = {
                AWS = [
                    "arn:aws:iam::396608811643:user/Manyu89403"
                ]
            }
            Action =[
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListObject"
            ]
            Resource = "arn:aws:s3:::abhi-mystatebucket-vpc-backend-state-file/*"
        }
    ])
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.my_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
    bucket = aws_s3_bucket.my_bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}