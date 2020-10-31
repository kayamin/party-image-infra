service_name = "party-image"
domain_name = "kayamin.cf"
vpc_cider_block = "10.0.0.0/24"
subnet_num = 2
eks_tags_for_node_group = {"kubernetes.io/cluster/party-image-cluster" = "shared"}
k8s_node_port = 30020
cost_allocation_tags = {"service": "party-image"}