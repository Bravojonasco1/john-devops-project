terraform {
  backend "s3" {
    bucket         = "john-devops-tfstate-385864240463"
    key            = "john-devops-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
