module "variables" {
 source  = "../variables"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = module.variables.vpc_cidr

  tags = {
    Name        = "${module.variables.environment}-vpc"
    Environment = module.variables.environment
  }
}

# Subnets
# Internet Gateway for Public Subnet############################################
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${module.variables.environment}-igw"
    Environment = module.variables.environment
  }
}

# Public subnets############################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = module.variables.public_subnets_cidr
  map_public_ip_on_launch = true
  availability_zone       = module.variables.availability_zone

  tags = {
    Name        = "${module.variables.environment}-public-subnet"
    Environment = "${module.variables.environment}"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = module.variables.public_subnets_cidr2
  map_public_ip_on_launch = true
  availability_zone       = module.variables.availability_zone2

  tags = {
    Name        = "${module.variables.environment}-public-subnet"
    Environment = "${module.variables.environment}"
  }
}


# Private Subnet############################################
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = module.variables.private_subnets_cidr
  availability_zone       = module.variables.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${module.variables.environment}-private-subnet"
    Environment = "${module.variables.environment}"
  }
}

# Routing tables to route traffic for Public Subnet############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${module.variables.environment}-public-route-table"
    Environment = "${module.variables.environment}"
  }
}


 #Route for Internet Gateway############################################
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

# sec groups########################################################################################
resource "aws_security_group" "eng114_david_sg_app_terra"{
	name = "eng114_david_sg_app_terra"
	vpc_id = aws_vpc.vpc.id

	ingress {
		description = "HTTP from all"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "HTTPS from all"
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "SSH from localhost"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"] #["${chomp(data.http.myip.body)}/32"]
	}

    ingress {
        description = "port 3000 for app"
        from_port =  3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
		description = "All traffic out"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

  tags = {
    Name        = "${module.variables.environment}-sg-app"
    Environment = "${module.variables.environment}"
  }

}
########################################################################################
resource "aws_security_group" "eng114_david_sg_db_terra"{
	name = "eng114_david_sg_db_terra"
	description = "27017 for mongoDB"
	vpc_id = aws_vpc.vpc.id


	ingress {
		description = "27017 from app instance"
		from_port = 27017
		to_port = 27017
		protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	}


## remove in productions########################################################################################
	ingress {
		description = "SSH from localhost"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"] #["${chomp(data.http.myip.body)}/32"]
	}

	egress {
		description = "All traffic out"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

  tags = {
    Name        = "${module.variables.environment}-sg-db"
    Environment = "${module.variables.environment}"
  }

}