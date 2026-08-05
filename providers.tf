terraform {
  required_providers {
    yandex = {
    source  = "registry.terraform.io/yandex-cloud/yandex"
    version = "~> 0.140"
    }
  }
}

provider "yandex" {
  service_account_key_file = "C:/Users/user/yc-diary-tofu-key.json"
  cloud_id = "b1g1955p4d35hrdmpjuc"
  folder_id = "b1gn3ro62auiijqd7kqj"
  zone = "ru-central1-a"
}