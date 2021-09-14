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

data "http" "myip" {
    url = "http://ipv4.icanhazip.com"
}

##################################################################################
# LOCALS
##################################################################################

locals {
    src = abspath("${path.module}/../")
    ssh_cmd = <<-EOT
        autossh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
                -Nf -D8079 -p ${var.proxy_port} ${var.proxy_user}@${var.proxy_host} \
                -i ~/proxy.pem
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

# DB subnet group
resource "aws_db_subnet_group" "db-sng" {
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

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

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
resource "aws_instance" "ec2" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.subnet1.id
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

    provisioner "file" {
        source = var.proxy_pem_path
        destination = "/home/ubuntu/proxy.pem"
    }

    provisioner "remote-exec" {
        inline = [
            # Use bash
            "#!/bin/bash",

            # Wait cloud-init
            <<-EOT
            while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
                echo 'Waiting for cloud-init...';
                sleep 1;
            done
            EOT
            ,

            # Install env
            <<-EOT
            sudo apt-get update -y && \
            sudo apt-get install -y python3 python3-pip \
                                    mysql-client autossh unzip
            EOT
            ,

            # Initialize mysql
            <<-EOT
            echo '[client]' > ~/account.info
            echo 'user=${var.db_username}' >> ~/account.info
            echo 'password=${var.db_password}' >> ~/account.info
            echo 'default-character-set=utf8mb4' >> ~/account.info
            cat ~/db_build.sql | mysql --defaults-extra-file=~/account.info -h ${element(split(":", aws_db_instance.db.endpoint), 0)}
            EOT
            ,

            # Install requirements.txt
            "cd /home/ubuntu/$(basename ${local.src})",
            "pip3 install -r requirements.txt",

            # Start reader
            <<-EOT
            export db_host=${element(split(":", aws_db_instance.db.endpoint), 0)}
            export db_port=3306
            export db_user=${var.db_username}
            export db_pass=${var.db_password}
            nohup python3 src/api.py 2>&1 1>/dev/null &
            EOT
            ,

            # Setup script to launch ssh tunnel
            "chmod 600 ~/proxy.pem",
            "echo -e \"#!/usr/bin/bash\n${local.ssh_cmd}\" > ~/launch_proxy.sh",
            "chmod u+x ~/launch_proxy.sh",

            # Install Chrome, Chromedriver
            "wget 'https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_93.0.4577.63-1_amd64.deb'",
            "sudo apt -y install ./google-chrome-stable_93.0.4577.63-1_amd64.deb",
            "wget 'https://chromedriver.storage.googleapis.com/93.0.4577.15/chromedriver_linux64.zip'",
            "unzip chromedriver_linux64.zip && cp chromedriver /home/ubuntu/.local/bin",

            # Register crawler to crontab
            <<-EOT
            (
                crontab -l 2>/dev/null;
                echo "*/5 * * * * ~/launch_proxy.sh && \
                        export db_host=${element(split(":", aws_db_instance.db.endpoint), 0)} && \
                        export db_port=3306 && \
                        export db_user=${var.db_username} && \
                        export db_pass=${var.db_password} && \
                        python3 ~/$(basename ${local.src})/src/crawler_main.py 1 && \
                        killall -9 chromium-browser chromedriver autossh ssh"
            ) | crontab -
            EOT
        ]
    }
}

resource "aws_db_instance" "db" {
    allocated_storage      = 10
    engine                 = "mysql"
    engine_version         = "8.0.20"
    instance_class         = "db.t2.micro"
    name                   = "comicdb"
    username               = var.db_username
    password               = var.db_password
    db_subnet_group_name   = aws_db_subnet_group.db-sng.id
    vpc_security_group_ids = [aws_security_group.db-sg.id]
    parameter_group_name   = "default.mysql8.0"
    skip_final_snapshot    = true
    publicly_accessible    = true
}
