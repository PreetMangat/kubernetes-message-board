provider "aws" {
  region = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket         = "kubernetes-message-board-state-bucket"
    key            = "terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "kubernetes-message-board-state-lock-table"
  }
}
