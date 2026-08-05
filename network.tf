//
// Create a new VPC Network.
//
resource "yandex_vpc_network" "diary_net" {
  name = "diary-lab-net"
}

resource "yandex_vpc_subnet" "diary_subnet" {
  name           = "diary-lab-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diary_net.id
  v4_cidr_blocks = ["10.0.50.0/24"]
  route_table_id = yandex_vpc_route_table.diary_rt.id
}

resource "yandex_vpc_security_group" "diary_sg" {
  name       = "diary-lab-sg"
  network_id = yandex_vpc_network.diary_net.id

  # 1) ноут → bastion :22
  ingress {
    protocol       = "TCP"
    description    = "SSH from my laptop"
    v4_cidr_blocks = [var.my_ssh_cidr]
    port           = 22
  }

  # 2) внутри subnet :22 (bastion → app/db)
  ingress {
    protocol       = "TCP"
    description    = "SSH inside subnet"
    v4_cidr_blocks = ["10.0.50.0/24"]
    port           = 22
  }

  # 3) app → db :5432
  ingress {
    protocol       = "TCP"
    description    = "PostgreSQL from subnet"
    v4_cidr_blocks = ["10.0.50.0/24"]
    port           = 5432
  }

  # 4) bastion → flask :8000
  ingress {
    protocol       = "TCP"
    description    = "Flask from subnet"
    v4_cidr_blocks = ["10.0.50.0/24"]
    port           = 8000
  }

  # наружу (apt/DNS)
  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "yandex_vpc_gateway" "nat" {
  name = "diary-nat-gw"

  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "diary_rt" {
  name       = "diary-rt"
  network_id = yandex_vpc_network.diary_net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}