variable "default_region" {
    description = "default aws region"
    type = string
    default = "ap-south-1"
}

variable "vpc01_region" {
    description = "region for vpc 01"
    type = string
    default = "us-east-1"
}

variable "vpc02_region" {
    description = "region for vpc 02"
    type = string
    default = "us-west-2"
}

variable "tags" {
    description = "default tags"
    type = map(string)
    default = {
        "env" = "local_host"
        "project" = "vpc_peering"
        "cloud" = "aws"
        "region" ="mumbai"
    }
}

variable "instance_type" {
    description = "ec2 instance type"
    type = string
    default = "t3.small"
}

variable "default_az" {
    description = "az in default region"
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "az01" {
    description = "az in 01"
    type = list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "az02" {
    description = "az in 02"
    type = list(string)
    default = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}
