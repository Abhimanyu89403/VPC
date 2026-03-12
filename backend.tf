terraform {
  backend "s3" {
    bucket         = "abhi-mystatebucket-vpc-backend-state-file"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile = true
  }
}