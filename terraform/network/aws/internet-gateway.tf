resource "aws_internet_gateway" "this" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "my_rt" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

}

resource "aws_route_table_association" "this" {
  count          = length(aws_subnet.this)
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.my_rt[0].id
}
