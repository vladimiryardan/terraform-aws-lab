resource "aws_vpc" "lab_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-subnet"
    }
  )
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-igw"
    }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
