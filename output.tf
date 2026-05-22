output "vpc01_id" {
    value = aws_vpc.vpc01.id
}
output "sub01_id" {
    value = aws_subnet.sub01.id
}
output "ami01_id" {
    value = data.aws_ami.ami01.id
}
output "ec201_id" {
    value = aws_instance.ec201.id
}

output "vpc02_id" {
    value = aws_vpc.vpc02.id
}
output "sub02_id" {
    value = aws_subnet.sub02.id
}
output "ami02_id" {
    value = data.aws_ami.ami02.id
}
output "ec202_id" {
    value = aws_instance.ec202.id
}
