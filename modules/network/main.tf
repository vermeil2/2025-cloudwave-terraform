########################################################
# VPC
########################################################

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}



########################################################
# Subnet
########################################################
resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_zone1_cidr
  availability_zone = var.zone1

  tags = {
    "Name"                                 = "${var.env}-pri-${var.zone1}"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_zone2_cidr
  availability_zone = var.zone2

  tags = {
    "Name"                                 = "${var.env}-pri-${var.zone2}"
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.public_zone1_cidr
  availability_zone      = var.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                 = "${var.env}-pub-${var.zone1}"
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.public_zone2_cidr
  availability_zone      = var.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                 = "${var.env}-pub-${var.zone2}"
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

########################################################
# NAT
########################################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

########################################################
# Routes
########################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public"
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}