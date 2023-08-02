locals {
  region       = "ap-northeast-1"
  account_name = "Azuma"

  vpc_cider_block            = "10.1.0.0/16"
  public_subnet_cider_block  = "10.1.1.0/24"
  private_subnet_cider_block = "10.1.2.0/24"
  subnet_az                  = "ap-northeast-1a"

  github_repository_names = ["repo:Kitsuya0828/resource-label-checker"]
}