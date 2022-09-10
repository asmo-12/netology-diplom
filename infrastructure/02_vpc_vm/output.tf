# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = yandex_vpc_network.my_vpc.id
#   sensitive   = false
# }
# output "my_subnets_id" {
#   description = "ID of subnets"
#   value = flatten([
#     for my_subnets in yandex_vpc_subnet.subnets : my_subnets.id
#   ])
#   sensitive = false
# }
# output "subnets_names" {
#   description = "names of subnets"
#   value = flatten([
#     for my_subnets in yandex_vpc_subnet.subnets : my_subnets.name
#   ])
#   sensitive = false
# }
# output "subnets_zones" {
#   description = "zones of subnets"
#   value = flatten([
#     for my_subnets in yandex_vpc_subnet.subnets : my_subnets.zone
#   ])
#   sensitive = false
# }
# output "v4_cidr_blocks" {
#   value = flatten([
#     for my_subnets in yandex_vpc_subnet.subnets : my_subnets.v4_cidr_blocks
#   ])
#   sensitive = false
# }
#  output "server_id" {
#   value = flatten([
#     for server in yandex_compute_instance.server : server.id
#   ])
#   sensitive = false
# } 
# output "proxy_external_ip" {
#   value = data.yandex_compute_instance.proxy.network_interface.0.nat_ip_address
# }
# output "proxy_internal_ip" {
#   value = data.yandex_compute_instance.proxy.network_interface.0.ip_address
# }
# output "proxy_id" {
#   value = data.yandex_compute_instance.proxy.id
# }
output "proxy_fqdn" {
  value = data.yandex_compute_instance.proxy.fqdn
}
output "proxy_name" {
  value     = yandex_compute_instance.proxy.name
  sensitive = false
}
data "yandex_compute_instance" "proxy" {
  instance_id = yandex_compute_instance.proxy.id
}