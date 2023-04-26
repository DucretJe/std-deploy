data "aws_availability_zones" "all" {}

locals {
  private_subnet_cidr_blocks = [for i in range(length(data.aws_availability_zones.all.names)) :
    cidrsubnet(aws_vpc.this.cidr_block, 9, 2 * i)
  ]
  public_subnet_cidr_blocks = [for i in range(length(data.aws_availability_zones.all.names)) :
    cidrsubnet(aws_vpc.this.cidr_block, 9, 2 * i + 1)
  ]
}

resource "aws_subnet" "private" {
  count = var.create_private_subnet ? length(data.aws_availability_zones.all.names) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = {
    for key, value in var.subnet_tags : key => value
  }
}

resource "aws_subnet" "public" {
  count = var.create_public_subnet ? length(data.aws_availability_zones.all.names) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch

  tags = {
    for key, value in var.subnet_tags : key => value
  }
}
