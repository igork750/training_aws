provider "aws" {
  region = "us-west-1"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "17vpc"
  cidr   = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24"]

  enable_ipv6        = false
  enable_nat_gateway = false
  single_nat_gateway = true
  public_subnet_tags = {
    Name = "Public-Subnets"
  }
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  vpc_tags = {
    Name = "W17VPC"
  }
}

# Create a database server
resource "aws_db_instance" "default" {
  allocated_storage = 5
  engine         = "mysql"
  engine_version = "8.0.28"
  instance_class = "db.t3.micro"
  username       = "test_user"
  password       = "test_pass"
  skip_final_snapshot  = true
}

# Create a Network Load Balancer
resource "aws_lb" "NLB17" {
  name                       = "NLB17"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = ["subnet-01aae769fa60eef53", "subnet-01bd97b55c29f714f"]
  enable_deletion_protection = false #true if you are not planning on destroying your load balancer
}