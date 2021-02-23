module "network" {
  source = "../shared/modules/network"
  vpc_cider_block = var.vpc_cider_block
  subnet_num = var.subnet_num
  eks_tags_for_node_group = var.eks_tags_for_node_group
  cost_allocation_tags = var.cost_allocation_tags
}

module "routing" {
  source = "../shared/modules/routing"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  k8s_node_port_collector = var.k8s_node_port_collector
  k8s_node_port_publisher = var.k8s_node_port_publisher
  service_name = var.service_name
  domain_name = var.domain_name
  eks_node_group_auto_scaling_group_name = module.service.eks_node_group_auto_scaling_group_name
  cost_allocation_tags = var.cost_allocation_tags
}

module "content_delivery_network" {
  source = "../shared/modules/content_delivery_network"
  service_name = var.service_name
  cost_allocation_tags = var.cost_allocation_tags
}

module "db" {
  source = "../shared/modules/db"
  service_name = var.service_name
  cost_allocation_tags = var.cost_allocation_tags
}

module "service" {
  source = "../shared/modules/service"
  service_name = var.service_name
  subnet_ids = module.network.private_subnet_ids
  k8s_node_port_collector = var.k8s_node_port_collector
  k8s_node_port_publisher = var.k8s_node_port_publisher
  alb_security_group_id = module.routing.alb_security_group_id
  cost_allocation_tags = var.cost_allocation_tags
}