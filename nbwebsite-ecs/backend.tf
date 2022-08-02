terraform {
  backend "s3" {
    bucket          = "terraform.tfstate.dev"
    key             = "nb-website-ecs-tfstate"
    region          = "ca-central-1"
    profile         = "default"
  }
}