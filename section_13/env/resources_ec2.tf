##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

	owners = ["099720109477"]
}

##################################################################################
# LOCALS
##################################################################################

locals {
    src = abspath("${path.module}/../")
    export_db_envs = <<-EOT
        export db_host=localhost && \
        export db_port=3306 && \
        export db_user=${var.db_username} && \
        export db_pass=${var.db_password}
    EOT
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

resource "aws_subnet" "subnet" {
    cidr_block              = var.subnet_address_space
    vpc_id                  = aws_vpc.vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = data.aws_availability_zones.available.names[0]
}

# Routing
resource "aws_route_table" "rtb" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rtb-subnet" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.rtb.id
}

# Security Group
resource "aws_security_group" "sg" {
    name   = "comic-reader-backend-sg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Instances
resource "aws_instance" "ec2" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.subnet.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    key_name               = var.key_name

    connection {
        type        = "ssh"
        host        = self.public_ip
        user        = "ubuntu"
        private_key = file(var.private_key_path)
    }

    provisioner "file" {
        source = local.src
        destination = "/home/ubuntu/"
    }

    provisioner "file" {
        source = var.db_sql_path
        destination = "/home/ubuntu/db_build.sql"
    }

    provisioner "remote-exec" {
        inline = [
            # Use bash
            "#!/bin/bash",

            # Wait cloud-init
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",

            # Install env
            "sudo apt-get update -y && sudo apt-get install -y python3 python3-pip mysql-server mysql-client",

            # Update config of mysql
            "sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf",

            # Launch and initialize db
            "sudo service mysql restart",
            "sudo mysql -uroot <<<'CREATE DATABASE comicdb;'",
            "sudo mysql -uroot <<<$(cat /home/ubuntu/db_build.sql)",
            "sudo mysql -uroot <<<\"CREATE USER '${var.db_username}'@'%' IDENTIFIED BY '${var.db_password}';\"",
            "sudo mysql -uroot <<<\"GRANT ALL ON comicdb.* TO '${var.db_username}'@'%'\";",

            # Set env
            "${local.export_db_envs}",

            # Install dependency
            "cd /home/ubuntu/$(basename ${local.src})",
            "pip3 install -r requirements.txt",

            # Start reader service
            "nohup python3 src/api.py 2>&1 1>/dev/null &",
            "sleep 10"
        ]
    }
}
