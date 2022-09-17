resource "yandex_compute_instance" "proxy" {
  name                      = var.proxy_name
  zone                      = var.region
  hostname                  = var.domain
  allow_stopping_for_update = false
  platform_id               = var.platform_type

  resources {
    cores         = "2"
    memory        = "2"
    core_fraction = "5"
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_instance_image
      type     = var.disk_type
      size     = "10"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnets["a"].id
    nat            = true
    ip_address     = var.proxy_ip
    nat_ip_address = var.public_ip
    ipv6           = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa_diplom.pub")}"
    serial-port-enable : "1"
    users = "ubuntu"
  }
}
