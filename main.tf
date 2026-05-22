provider "aws" {
    region = var.default_region
}

provider "aws" {
    alias = "east"
    region = var.vpc01_region
}

provider "aws" {
    alias = "west"
    region = var.vpc02_region
}

resource "aws_vpc" "vpc01" {
    cidr_block = "10.0.0.0/16"
    provider = aws.east
    region = var.vpc01_region
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    tags = var.tags
    instance_tenancy = "default"
}

resource "aws_vpc" "vpc02" {
    cidr_block = "10.1.0.0/16"
    provider = aws.west
    region = var.vpc02_region
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    tags = var.tags
    instance_tenancy = "default"
}

resource "aws_subnet" "sub01" {
    provider = aws.east
    vpc_id = aws_vpc.vpc01.id
    region = var.vpc01_region
    cidr_block = "10.0.1.0/24"
    tags = var.tags
    availability_zone = var.az01[0]
}

resource "aws_subnet" "sub02" {
    provider = aws.west
    vpc_id = aws_vpc.vpc02.id
    region = var.vpc02_region
    cidr_block = "10.1.1.0/24"
    tags = var.tags
    availability_zone = var.az02[0]
}

resource "aws_instance" "ec201" {
    provider = aws.east
    ami = data.aws_ami.ami01.id
    region = var.vpc01_region
    monitoring = true
    subnet_id = aws_subnet.sub01.id
    instance_type = var.instance_type
    availability_zone = var.az01[0]
    vpc_security_group_ids = [aws_security_group.sg01.id]
}

resource "aws_instance" "ec202" {
    provider = aws.west
    ami = data.aws_ami.ami02.id
    region = var.vpc02_region
    monitoring = true
    subnet_id = aws_subnet.sub02.id
    instance_type = var.instance_type
    availability_zone = var.az02[0]
    vpc_security_group_ids = [aws_security_group.sg02.id]
}

resource "aws_security_group" "sg01" {
    provider = aws.east
    region = var.vpc01_region
    tags = var.tags
    vpc_id = aws_vpc.vpc01.id
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = [aws_vpc.vpc02.cidr_block]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg02" {
    provider = aws.west
    region = var.vpc02_region
    tags = var.tags
    vpc_id = aws_vpc.vpc02.id
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = [aws_vpc.vpc01.cidr_block]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_vpc_peering_connection" "peer_connect" {
    provider = aws.east
    region = var.vpc01_region
    vpc_id = aws_vpc.vpc01.id
    peer_vpc_id = aws_vpc.vpc02.id
    peer_region = var.vpc02_region
    auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
    provider = aws.west
    region = var.vpc02_region
    vpc_peering_connection_id = aws_vpc_peering_connection.peer_connect.id
    auto_accept = true
}

resource "aws_route_table" "route01" {
    provider = aws.east
    region = var.vpc01_region
    tags = var.tags
    vpc_id = aws_vpc.vpc01.id
}

resource "aws_route_table_association" "ass01" {
    provider = aws.east
    region = var.vpc01_region
    route_table_id = aws_route_table.route01.id
    subnet_id = aws_subnet.sub01.id
}

resource "aws_route_table" "route02" {
    provider = aws.west
    region = var.vpc02_region
    tags = var.tags
    vpc_id = aws_vpc.vpc02.id
}

resource "aws_route_table_association" "ass02" {
    provider = aws.west
    region = var.vpc02_region
    route_table_id = aws_route_table.route02.id
    subnet_id = aws_subnet.sub02.id
}

resource "aws_route" "route_to_02" {
    provider = aws.east
    region = var.vpc01_region
    route_table_id = aws_route_table.route01.id
    destination_cidr_block = aws_vpc.vpc02.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer_connect.id
}

resource "aws_route" "route_to_01" {
    provider = aws.west
    region = var.vpc02_region
    route_table_id = aws_route_table.route02.id
    destination_cidr_block = aws_vpc.vpc01.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer_connect.id
}
