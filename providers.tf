provider "aws" {
  region = "us-east-1"
  profile = "lrnpoc"
}

provider "aws" {
  region = "us-east-1"
  profile = "lrnqa"
  alias = "qa"
}
