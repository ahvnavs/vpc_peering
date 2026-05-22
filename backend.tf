terraform {
    backend "s3" {
        bucket = "terraform-statefile-host-s3-bucket"
        key = "vpc_peering/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
