resource "yandex_compute_instance" "db-vm" {
  name        = "db"
  hostname    = "db"
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
    ip_address         = "10.0.50.11"
    subnet_id          = yandex_vpc_subnet.diary_subnet.id
    security_group_ids = [yandex_vpc_security_group.diary_sg.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("C:/Users/user/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "app-vm" {
  name        = "app"
  hostname    = "app"
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
    ip_address         = "10.0.50.12"
    subnet_id          = yandex_vpc_subnet.diary_subnet.id
    security_group_ids = [yandex_vpc_security_group.diary_sg.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("C:/Users/user/.ssh/id_ed25519.pub")}"
  }
}