terraform {
  #  required_version = ">= 0.13"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.77.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.34.0"
    }
  }
}

provider "tfe" {
  # Configuration options/ May be, later
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
  zone                     = var.region
}