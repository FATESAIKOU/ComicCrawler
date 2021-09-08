##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "http" "myip" {
    url = "http://ipv4.icanhazip.com"
}

##################################################################################
# RESOURCES
##################################################################################

# Nerworking
resource "aws_vpc" "vpc" {
    cidr_block = var.network_address_space
    enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet1" {
    cidr_block              = var.subnet1_address_space
    vpc_id                  = aws_vpc.vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "subnet2" {
    cidr_block              = var.subnet2_address_space
    vpc_id                  = aws_vpc.vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = data.aws_availability_zones.available.names[1]
}

resource "aws_db_subnet_group" "comic-db-sng" {
    name = "db-sng"
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

# Routing
resource "aws_route_table" "rtb" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rtb-subnet1" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtb-subnet2" {
    subnet_id      = aws_subnet.subnet2.id
    route_table_id = aws_route_table.rtb.id
}

# Security Group
resource "aws_security_group" "db-sg" {
    name   = "db-sg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = [var.network_address_space, "${chomp(data.http.myip.body)}/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Instances
resource "aws_db_instance" "db" {
    allocated_storage      = 10
    engine                 = "mysql"
    engine_version         = "5.7.34"
    instance_class         = "db.t2.micro"
    name                   = "testdb"
    username               = var.db_username
    password               = var.db_password
    db_subnet_group_name   = aws_db_subnet_group.comic-db-sng.id
    vpc_security_group_ids = [aws_security_group.db-sg.id]
    parameter_group_name   = "default.mysql5.7"
    skip_final_snapshot    = true
    publicly_accessible    = true
}
