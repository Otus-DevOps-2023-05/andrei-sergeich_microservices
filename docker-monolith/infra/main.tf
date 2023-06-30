provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "reddit" {
  count = var.inst_count
  name  = "reddit-${count.index + 1}"
#   name  = "reddit"
  zone  = var.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
}

resource "local_file" "hosts_inventory" {
  content = templatefile("${path.module}/ansible_inventory_ini.tpl",
    {
      reddit_servers = yandex_compute_instance.reddit[*].network_interface.0.nat_ip_address
    }
  )
  filename = "./inventory"
}
