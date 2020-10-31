# 必要な VPC, subnet(public, private) を定義
# また，worker ノードからのインターネットアクセスを許可するため
# - VPC にインターネットゲートウェイを付与
# - subnet(public) に付与するルーターにインターネットゲートウェイへのデフォルトルートを作成
# - subnet(public) にNATゲートウェイを作成
# - subnet(private) に付与するルーターにNATゲートウェイへのデフォルトルートを作成

data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cider_block
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default" // AWS上の専用インスタンスにVPC内のリソースを作成するかどうか

  tags = var.cost_allocation_tags
}


# インターネットと通信可能な, インターネットゲートウェイと紐付けられたサブネット(public) を作成
resource "aws_subnet" "public" {
  count = var.subnet_num
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index )
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = var.cost_allocation_tags
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.cost_allocation_tags
}

# route table
resource "aws_route_table" "to_igw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.cost_allocation_tags
}

resource "aws_route_table_association" "public" {
  count = var.subnet_num
  route_table_id = aws_route_table.to_igw.id
  subnet_id = aws_subnet.public[count.index].id
}


# NATゲートウェイと紐付けられた，インターネットへのアウトバウンド通信のみ可能なサブネット(private)を作成
resource "aws_subnet" "private" {
  count = var.subnet_num
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + var.subnet_num)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # eks node group に割り当てるサブネットには特定のタグ を付与する必要がる
  # "kubernetes.io/cluster/${aws_eks_cluster.example.name}" = "shared"
  tags = merge(var.cost_allocation_tags, var.eks_tags_for_node_group)
}

# nat gatewayに付与する固定IPを作成
resource "aws_eip" "nat_gateway" {
  count = var.subnet_num
  vpc = true

  tags = var.cost_allocation_tags
}

# nat gateway
resource "aws_nat_gateway" "private" {
  count = var.subnet_num
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = var.cost_allocation_tags
}

# nat gateway へのデフォルトルートを サブネット(private) に作成
resource "aws_route_table" "to_nat_gateway" {
  count = var.subnet_num
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private[count.index].id
  }

  tags = var.cost_allocation_tags
}

resource "aws_route_table_association" "private" {
  count = var.subnet_num
  route_table_id = aws_route_table.to_nat_gateway[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}