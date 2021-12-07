terraform {
  backend "remote" {
    organization = "comic_crawler"

    workspaces {
      name = "medium-aws-deploy"
    }
  }
}
