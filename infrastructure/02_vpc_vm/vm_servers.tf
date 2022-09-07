resource "yandex_compute_instance" "server" {
  for_each = var.vms
  name     = each.value.name
  zone     = var.region
  # hostname                  = each.value.hostname
  hostname                  = "${each.value.name}.${var.domain}"
  allow_stopping_for_update = true
  platform_id               = var.platform_type

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu-image
      type     = var.disk_type
      size     = each.value.hdd
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnets["a"].id
    nat        = false
    ip_address = each.value.local_ip
    ipv6       = false
    # nat_ip_address = var.static_ip
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa_diplom.pub")}"
    serial-port-enable : "1"
    users = "ubuntu"
  }
}
