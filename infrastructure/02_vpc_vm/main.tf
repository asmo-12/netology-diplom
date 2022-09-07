resource "yandex_vpc_network" "my_vpc" {
  folder_id = var.folder_id
  name      = "my_vpc"
}

resource "yandex_vpc_subnet" "subnets" {
  for_each       = var.my_subnets
  network_id     = yandex_vpc_network.my_vpc.id
  v4_cidr_blocks = [each.value.cidr]
  zone           = each.value.yc_zone
  name           = "Subnet-${each.value.yc_zone}-${each.value.cidr}"
  route_table_id = yandex_vpc_route_table.nat.id
}


resource "yandex_vpc_route_table" "nat" {
  name       = "route table"
  network_id = yandex_vpc_network.my_vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.proxy_ip
  }
}
