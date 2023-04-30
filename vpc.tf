resource "aws-subnet" "public" {
  vpc_id = aws_vpc.main.id 
  cidr_block = var.public_subnet_cidr

  tags = merge(var.tags,{
    Name ="public-subnet"
  })  
}

resource "aws_vpc" "main" {
    cidr_block = var.cidr
    instance_tenancy = "default"

    tags = merge(var.tags,{
        Name = "timings"
    })
  
}

resource "aws-subnet" "private" {
  vpc_id = aws_vpc.main.id 
  cidr_block = var.private_subnet_cidr

  tags = merge(var.tags,{
    Name ="private-subnet"
  })  
}

resource "aws_internet_gateway" "automated-igw" {
    vpc_id = aws_vpc.main.id

    tags = merge(var.tags,{
        Name = "timing-igw"
    })
  
}

resource "aws_route_table" "public_rt" {
   vpc_id = aws_vpc.main.id

   route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.automated-igw.id

   }

   tags = merge(var.tags, {
    Name = "public-route-table"
   })  
}

resource "aws_eip" "auto-eip" {
  
}

resource "aws_nat_gateway" "example" {

    allocation_id = aws_eip.auto-eip.id
    subnet_id = aws_subnet.public.id

    tags = merge(var.tags,{
        Name = "timing-ng"
    })

    depends_on = [ aws_internet_gateway.automated-igw ]
  
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.internet_cidr
        gateway_id = aws_nat_gateway.example.id
    }

    tags = merge(var.tags,{
        Name = "private-route-table"
    })
  
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private-rt.id
  
}