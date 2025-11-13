provider "aws"{
    region = "ap-south-1"
}
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        key = "Name"
        value = "my_vpc"
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        key = "Name"
        value = "my_igw_fe"
    }
}
resource "aws_nat_gateway" "nat_gw" {
    subnet_id = aws_subnet.public_subnet.id
    tags = {
        key = "Name"
        value = "nat_gw_be"
    }
    depends_on = [aws_internet_gateway.igw]
}




resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        key = "Name"
        value = "my_public_subnet"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        key = "Name"
        value = "my_public_route_table"
    }
}
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = "0.0.0.0/0"

}
resource "aws_route_table_association" "public_rta" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}




resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "ap-south-1b"
    cidr_block = "10.0.2.0/24"
    tags = {
        key = "Name"
        value = "my_private_subnet"
    }
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags ={
        key = "Name" 
        value = "my_private_route_table"
    }
}
resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_rt.id
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_rta" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}

