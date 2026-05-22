data "aws_ami" "ami01"{
    region = var.vpc01_region
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = []
    }
}

data "aws_ami" "ami02" {
    region = var.vpc02_region
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = []
    }
}
