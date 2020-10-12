terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "ryanthompson-fh-sandbox-tfstate"
    key    = "argo-poc"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}
