resource "aws_subnet" "publicsbt" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public-sbt"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "manual-vpc"
  }
}

resource "aws_subnet" "privatesbt" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private-sbt"
  }
}

resource "aws_internet_gateway" "internetgw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "manual-internet-gw"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_eip" "auto-eip" {

}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.auto-eip.id
  subnet_id     = aws_subnet.privatesbt.id

  tags = {
    Name = "nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internetgw]
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "Private-rt"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.publicsbt.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.privatesbt.id
  route_table_id = aws_route_table.privatert.id
}
#sample checkup