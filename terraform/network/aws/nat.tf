resource "aws_nat_gateway" "this" {
  count         = var.create_private_subnet ? 1 : 0
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.private[0].id
}

resource "aws_route_table" "private_route_table" {
  count  = var.create_private_subnet ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.create_private_subnet ? 1 : 0
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private_subnet" {
  count          = var.create_private_subnet ? length(aws_subnet.private) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

resource "aws_eip" "this" {
  vpc = true
}
