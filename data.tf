data "aws_ami" "ami01"{
    provider = aws.east
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }
}

data "aws_ami" "ami02" {
    provider = aws.west
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }
}
