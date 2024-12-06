# Создание VPC и подсети
resource "yandex_vpc_network" "this" {
  name = "private"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.zone
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_address" "addr" {
  name = "vm-adress"
  external_ipv4_address {
    zone_id = var.zone
  }
}

# Создание диска и виртуальной машины
resource "yandex_compute_disk" "boot_disk" {
  name     = "boot-disk"
  zone     = var.zone
  image_id = var.image_id
  size     = 15
}

resource "yandex_compute_instance" "this" {
  name                      = "linux-vm"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = var.zone

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.private.id
    nat             = true
    nat_ip_address  = yandex_vpc_address.addr.external_ipv4_address[0].address
  }

  metadata = {
    user-data = templatefile("cloud-init.yaml.tftpl", {
      ssh_key = var.ssh_key,
      ssh_key_pub = file("id_rsa.pub"),
      mysql_host = yandex_mdb_mysql_cluster.this.host[0].fqdn,
      pipelines_file = filebase64("pipelines.py")
    })
  }

  # connection {
  #   type        = "ssh"
  #   user        = "crawler"
  #   private_key = file("id_rsa")
  #   host        = self.network_interface.0.nat_ip_address
  # }

  # provisioner "file" {
  #   source      = "pipelines.py"
  #   destination = "/home/crawler/pipelines.py"
  # }

}

# Создание Yandex Managed Service for YDB
resource "yandex_ydb_database_serverless" "this" {
  name = "test-ydb-serverless"
}

# Создание сервисного аккаунта 
resource "yandex_iam_service_account" "bucket" {
  name = "bucket-sa"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "this" {
  service_account_id = yandex_iam_service_account.bucket.id
  description        = "static access key for object storage"
}

# Создание бакета 
resource "yandex_storage_bucket" "this" {
  bucket = "terraform-bucket-${random_string.bucket_name.result}"
  access_key = yandex_iam_service_account_static_access_key.this.access_key
  secret_key = yandex_iam_service_account_static_access_key.this.secret_key
  
  depends_on = [ yandex_resourcemanager_folder_iam_member.storage_editor ]
} 

resource "random_string" "bucket_name" {
  length  = 8
  special = false
  upper   = false
} 

resource "yandex_mdb_mysql_cluster" "this" {
  name        = "mycluster"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.this.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 16
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.private.id
  }
  
}

resource "yandex_mdb_mysql_database" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "bookspider"
}

resource "yandex_mdb_mysql_user" "crawler" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "crawler"
  password   = "123456pass"

  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }
}

