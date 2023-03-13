resource "aws_internet_gateway" "this" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = var.internet_gateway_tags
}

resource "aws_route_table" "my_rt" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}
