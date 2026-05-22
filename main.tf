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
    region = var.vpc01_region
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    tags = var.tags
    instance_tenancy = "default"
}

resource "aws_vpc" "vpc02" {
    cidr_block = "10.1.0.0/16"
    region = var.vpc02_region
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    instance_tenancy = "default"
    tags = var.tags
}

resource "aws_subnet" "sub01" {
    depends_on = [ aws_vpc.vpc01 ]
    vpc_id = aws_vpc.vpc01.id
    region = var.vpc01_region
    cidr_block = "10.0.1.0/24"
    tags = var.tags
    availability_zone = var.az01[0]
}

resource "aws_subnet" "sub02" {
    depends_on = [ aws_vpc.vpc02 ]
    vpc_id = aws_vpc.vpc02.id
    region = var.vpc02_region
    cidr_block = "10.1.1.0/24"
    tags = var.tags
    availability_zone = var.az02[0]
}

resource "aws_instance" "ec201" {
    depends_on = [ aws_subnet.sub01 ]
    ami = data.aws_ami.ami01.id
    region = var.vpc01_region
    monitoring = true
    subnet_id = aws_subnet.sub01.id
    instance_type = var.instance_type
    availability_zone = var.az01[0]
}

resource "aws_instance" "ec202" {
    depends_on = [ aws_subnet.sub02 ]
    ami = data.aws_ami.ami02.id
    region = var.vpc02_region
    monitoring = true
    subnet_id = aws_subnet.sub02.id
    instance_type = var.instance_type
    availability_zone = var.az02[0]
}
