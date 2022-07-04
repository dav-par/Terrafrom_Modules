module "variables" {
 source  = "./variables"
}

module "vpc" {
 source  = "./vpc"
}

module "auto_scale" {
 source  = "./auto_scale"
}

# set aws as the cloud provider irland as the region
provider "aws" {
	region = "eu-west-1"
}


#resource block to configure db instance###########################################################
resource "aws_instance" "db_instance"{
# choose your ami and instance type
    depends_on = [module.vpc]
	ami = module.variables.db_ami
	instance_type = "t2.micro"
    subnet_id = "${module.vpc.private_subnet.id}"
    vpc_security_group_ids = ["${module.vpc.aws_security_group.eng114_david_sg_db_terra.id}"]
    private_ip = "10.5.242.225"
    

# enable a public ip
    associate_public_ip_address = false
   
# name the instance
    tags = {
        Name = "eng114_david_terraform-db"
    }
	
# add key
    key_name = module.variables.key_id
}

#resource block to configure controller instance###########################################################
resource "aws_instance" "controller_instance"{
# choose your ami and instance type
    depends_on = [module.vpc]
	ami = module.variables.controller_ami
	instance_type = "t2.micro"
    subnet_id = "${module.vpc.aws_subnet.public_subnet.id}"
    vpc_security_group_ids = ["${module.vpc.aws_security_group.eng114_david_sg_app_terra.id}"]

# enable a public ip
    associate_public_ip_address = true
   
# name the instance
    tags = {
        Name = "eng114_david_terraform-controller"
    }
	
# add key
    key_name = module.variables.key_id
}

