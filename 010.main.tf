# Configure the AWS Provider

module "us_east-1" {
  source = "./vpc"
  region     = "us-east-1"
  compute_count = 2
}

output "PublicDNS-us-east-1" {
  value = "${module.us_east-1.PublicDNS}"
}

module "us_west-2" {
  source = "./vpc"
  region     = "us-west-2"
  compute_count = 2
}

output "PublicDNS-us-west-2" {
 value = "${module.us_west-2.PublicDNS}"
}

module "eu-central-1" {
  source = "./vpc"
 region     = "eu-central-1"
  compute_count = 2
}

output "PublicDNS-eu-central-1" {
 value = "${module.eu-central-1.PublicDNS}"
}

module "ap-southeast-1" {
  source = "./vpc"
  region     = "ap-southeast-1"
  compute_count = 2
}

output "PublicDNS-ap-southeast-1" {
  value = "${module.ap-southeast-1.PublicDNS}"
}

