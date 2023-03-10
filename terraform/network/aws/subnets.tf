data "aws_availability_zones" "all" {}

locals {
  subnet_cidr_blocks = [for i in range(length(data.aws_availability_zones.all.names)) :
    cidrsubnet(aws_vpc.this.cidr_block, 8, i)
  ]
}

resource "aws_subnet" "this" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.all.names[count.index]
}
