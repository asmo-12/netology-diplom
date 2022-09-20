my_subnets = {
  "a" = {
    cidr    = "10.0.1.0/24"
    yc_zone = "ru-central1-a"
  },
  "b" = {
    cidr    = "10.0.2.0/24"
    yc_zone = "ru-central1-b"
  },
  "c" = {
    cidr    = "10.0.3.0/24"
    yc_zone = "ru-central1-c"
  }
}
vms = {
  "app" = {
    local_ip      = "10.0.1.16"
    cores         = "2"
    memory        = "4"
    core_fraction = "5"
    hdd           = "10"
    name          = "app"
    hostname      = "app.netology.simonof.info"
  }
  "db01" = {
    local_ip      = "10.0.1.17"
    cores         = "2"
    memory        = "2"
    core_fraction = "5"
    hdd           = "10"
    name          = "db01"
    hostname      = "db01.netology.simonof.info"
  }
  "db02" = {
    local_ip      = "10.0.1.18"
    cores         = "2"
    memory        = "2"
    core_fraction = "5"
    hdd           = "10"
    name          = "db02"
    hostname      = "db02.netology.simonof.info"
  }
  "gitlab" = {
    local_ip      = "10.0.1.19"
    cores         = "4"
    memory        = "4"
    core_fraction = "5"
    hdd           = "15"
    name          = "gitlab"
    hostname      = "gitlab.netology.simonof.info"
  }
  # "runner" = {
  #   local_ip      = "10.0.1.20"
  #   cores         = "2"
  #   memory        = "4"
  #   core_fraction = "5"
  #   hdd           = "10"
  #   name          = "runner"
  #   hostname      = "runner.netology.simonof.info"
  # }
  # "monitoring" = {
  #   local_ip      = "10.0.1.21"
  #   cores         = "2"
  #   memory        = "4"
  #   core_fraction = "5"
  #   hdd           = "20"
  #   name          = "monitoring"
  #   hostname      = "monitoring.netology.simonof.info"
  # }
}
service_account_key_file = "key.json"
folder_id                = "b1grdrfc9945t8d1dm4u"
cloud_id                 = "b1gu7agfp9jcvjn9imcj"
region                   = "ru-central1-a"
public_ip                = "51.250.83.227"
proxy_ip                 = "10.0.1.15"
proxy_name               = "proxy"
nat_instance_image       = "fd8q9r5va9p64uhch83k"
ubuntu-image             = "fd8ju9iqf6g5bcq77jns"
platform_type            = "standard-v2"
domain                   = "netology.simonof.info"
disk_type                = "network-ssd"
