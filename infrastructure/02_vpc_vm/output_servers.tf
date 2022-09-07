
output "servers_name" {
  value = flatten([
    for server in yandex_compute_instance.server : server.name
  ])
  sensitive = false
}
output "servers_fqdn" {
  value = flatten([
    for server in yandex_compute_instance.server : server.fqdn
  ])
  sensitive = false
}
