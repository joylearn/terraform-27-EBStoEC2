terraform {
  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "jl/terraform-27-EBStoEC2.tfstate"
    region = "us-east-1"
  }
}
