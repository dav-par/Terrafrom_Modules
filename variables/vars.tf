output "environment" {
  value = "eng114-david-terra"
}

output "vpc_cidr" {
  description = "CIDR block for VPC"
  value     = "10.5.0.0/16"
}

output "public_subnets_cidr" {
  value = "10.5.241.0/24"
}

output "public_subnets_cidr2" {
  value = "10.5.240.0/24"
}

output "private_subnets_cidr" {
  value = "10.5.242.0/24"
}

output "region" {
  value = "eu-west-1"
}


output "availability_zone" {
  value = "eu-west-1a"
}

output "availability_zone2" {
  value = "eu-west-1b"
}

output "key_id" {
  value = "eng144_david_terra"
}

output "app_ami" {
  value = "ami-0fcb2ff41055e4a93"
}

output "db_ami" {
  value = "ami-075574b4670425b76"
}

output "controller_ami" {
  value = "ami-0b756558a3243292d"
}
