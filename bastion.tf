data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "bastion-vm" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      size     = 20
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    ip_address         = "10.0.50.10"
    subnet_id          = yandex_vpc_subnet.diary_subnet.id
    security_group_ids = [yandex_vpc_security_group.diary_sg.id]
    nat                = true
    nat_ip_address     = yandex_vpc_address.bastion_pub.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "ubuntu:${file("C:/Users/user/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_address" "bastion_pub" {
  name = "diary-bastion-pub"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}