provider "aws" {
  profile = "pokgak-prod"
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Usage = "kelas-aws/iam"
      Terraform = "true"
    }
  }
}
