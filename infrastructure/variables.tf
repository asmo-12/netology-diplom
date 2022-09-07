variable "service_account_key_file" { type = string }
variable "folder_id" { type = string }
variable "cloud_id" { type = string }
variable "region" { type = string }
variable "public_ip" { type = string }
variable "nat_instance_image" { type = string }
variable "ubuntu-image" { type = string }
variable "platform_type" { type = string }
variable "disk_type" { type = string }
variable "proxy_ip" { type = string }
variable "my_subnets" {
  type = map(object({
    cidr    = string
    yc_zone = string
  }))
}
variable "domain" { type = string }
variable "vms" {
  type = map(object({
    local_ip      = string
    cores         = string
    memory        = string
    core_fraction = string
    hdd           = string
    name          = string
    hostname      = string
  }))
}
