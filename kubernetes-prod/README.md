# Подходы к развертываниюобновлению production-grade кластераСоздать кластер с использованием kubeadm

## Создание кластера с использованием kubeadm

### Установка кластера

```bash
$ terraform -chdir=terraform/stage/ apply -auto-approve
╷
│ Warning: Provider development overrides are in effect
│ 
│ The following provider development overrides are set in the CLI configuration:
│  - yandex-cloud/yandex in .terraform/plugins/yandex-cloud/yandex/0.97.0
│ 
│ The behavior may therefore not match any released version of the provider and applying changes may cause the state to become incompatible with published releases.
╵
data.yandex_resourcemanager_folder.this: Reading...
data.yandex_resourcemanager_folder.this: Read complete after 2s [id=b1gui0rctn8j2m54dpnu]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # local_file.ansible_inventory will be created
  + resource "local_file" "ansible_inventory" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../../ansible/environments/stage/inventory.json"
      + id                   = (known after apply)
    }

  # null_resource.run_ansible will be created
  + resource "null_resource" "run_ansible" {
      + id       = (known after apply)
      + triggers = {
          + "inventory_file" = "../../ansible/environments/stage/inventory.json"
        }
    }

  # yandex_vpc_network.this will be created
  + resource "yandex_vpc_network" "this" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = "b1gui0rctn8j2m54dpnu"
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network-kubernetes-prod"
      + subnet_ids                = (known after apply)
    }

  # module.kubernetes.data.tls_public_key.this will be read during apply
  # (config refers to values not yet known)
 <= data "tls_public_key" "this" {
      + algorithm                     = (known after apply)
      + id                            = (known after apply)
      + private_key_pem               = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
    }

  # module.kubernetes.data.yandex_compute_image.this will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "yandex_compute_image" "this" {
      + created_at    = (known after apply)
      + description   = (known after apply)
      + family        = "ubuntu-2004-lts"
      + folder_id     = (known after apply)
      + id            = (known after apply)
      + image_id      = (known after apply)
      + labels        = (known after apply)
      + min_disk_size = (known after apply)
      + name          = (known after apply)
      + os_type       = (known after apply)
      + pooled        = (known after apply)
      + product_ids   = (known after apply)
      + size          = (known after apply)
      + status        = (known after apply)
    }

  # module.kubernetes.null_resource.keys-export will be created
  + resource "null_resource" "keys-export" {
      + id = (known after apply)
    }

  # module.kubernetes.tls_private_key.this will be created
  + resource "tls_private_key" "this" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 2048
    }

  # module.kubernetes.yandex_compute_instance.master[0] will be created
  + resource "yandex_compute_instance" "master" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + labels                    = {
          + "tags" = "master"
        }
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                package_update: false
                package_upgrade: false
                users:
                  - name: ubuntu
                    groups: sudo
                    shell: /bin/bash
                    sudo: ['ALL=(ALL) NOPASSWD:ALL']
                    ssh_authorized_keys:
                      - ssh-rsa ... appuser@yc
                  - name: reddit
                    passwd: $6$.../
                    shell: /bin/bash
            EOT
        }
      + name                      = "k8s-master-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 50
          + cores         = 2
          + memory        = 8
        }

      + timeouts {
          + create = "30m"
          + delete = "2h"
        }
    }

  # module.kubernetes.yandex_compute_instance.worker[0] will be created
  + resource "yandex_compute_instance" "worker" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + labels                    = {
          + "tags" = "worker"
        }
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                var.ssh_user:ssh-rsa ... appuser@yc
            EOT
        }
      + name                      = "k8s-worker-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 50
          + cores         = 2
          + memory        = 8
        }

      + timeouts {
          + create = "60m"
          + delete = "2h"
        }
    }

  # module.kubernetes.yandex_compute_instance.worker[1] will be created
  + resource "yandex_compute_instance" "worker" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + labels                    = {
          + "tags" = "worker"
        }
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                var.ssh_user:ssh-rsa ... appuser@yc
            EOT
        }
      + name                      = "k8s-worker-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 50
          + cores         = 2
          + memory        = 8
        }

      + timeouts {
          + create = "60m"
          + delete = "2h"
        }
    }

  # module.kubernetes.yandex_compute_instance.worker[2] will be created
  + resource "yandex_compute_instance" "worker" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + labels                    = {
          + "tags" = "worker"
        }
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                var.ssh_user:ssh-rsa ... appuser@yc
            EOT
        }
      + name                      = "k8s-worker-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 50
          + cores         = 2
          + memory        = 8
        }

      + timeouts {
          + create = "60m"
          + delete = "2h"
        }
    }

  # module.subnet.data.yandex_client_config.client will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "yandex_client_config" "client" {
      + cloud_id  = (known after apply)
      + folder_id = (known after apply)
      + iam_token = (sensitive value)
      + id        = (known after apply)
      + zone      = (known after apply)
    }

  # module.subnet.data.yandex_vpc_subnet.this will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "yandex_vpc_subnet" "this" {
      + created_at     = (known after apply)
      + description    = (known after apply)
      + dhcp_options   = (known after apply)
      + folder_id      = "b1gui0rctn8j2m54dpnu"
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-kubernetes-prod"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
      + v4_cidr_blocks = (known after apply)
      + v6_cidr_blocks = (known after apply)
      + zone           = (known after apply)
    }

  # module.subnet.yandex_vpc_subnet.this will be created
  + resource "yandex_vpc_subnet" "this" {
      + created_at     = (known after apply)
      + folder_id      = "b1gui0rctn8j2m54dpnu"
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-kubernetes-prod"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.99.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 10 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + kubernetes_image_id          = (known after apply)
  + kubernetes_master_instance   = [
      + [
          + (known after apply),
        ],
      + [
          + "k8s-master-0",
        ],
    ]
  + kubernetes_master_ip_address = (known after apply)
  + kubernetes_worker_instance   = [
      + [
          + (known after apply),
          + (known after apply),
          + (known after apply),
        ],
      + [
          + "k8s-worker-0",
          + "k8s-worker-1",
          + "k8s-worker-2",
        ],
    ]
  + kubernetes_worker_ip_address = (known after apply)
```

Результат выполнения terraform

```output
yandex_vpc_network.this: Creating...
yandex_vpc_network.this: Creation complete after 4s [id=enpj41arfitefdarnh4m]
module.subnet.data.yandex_client_config.client: Reading...
module.subnet.yandex_vpc_subnet.this: Creating...
module.subnet.data.yandex_client_config.client: Read complete after 0s [id=2247602959]
module.subnet.yandex_vpc_subnet.this: Creation complete after 1s [id=e9bvde0lmlh3c607mf1p]
module.subnet.data.yandex_vpc_subnet.this: Reading...
module.subnet.data.yandex_vpc_subnet.this: Read complete after 0s [id=e9bvde0lmlh3c607mf1p]
module.kubernetes.data.yandex_compute_image.this: Reading...
module.kubernetes.tls_private_key.this: Creating...
module.kubernetes.tls_private_key.this: Creation complete after 1s [id=01b38ef7c28a5b3c170d0b303379783d3cad8b82]
module.kubernetes.data.tls_public_key.this: Reading...
module.kubernetes.data.tls_public_key.this: Read complete after 0s [id=01b38ef7c28a5b3c170d0b303379783d3cad8b82]
module.kubernetes.null_resource.keys-export: Creating...
module.kubernetes.null_resource.keys-export: Provisioning with 'local-exec'...
module.kubernetes.null_resource.keys-export (local-exec): (output suppressed due to sensitive value in config)
module.kubernetes.null_resource.keys-export: Creation complete after 0s [id=3980254825724594641]
module.kubernetes.data.yandex_compute_image.this: Read complete after 2s [id=fd82veuo7o3pn0sk7jhv]
module.kubernetes.yandex_compute_instance.worker[0]: Creating...
module.kubernetes.yandex_compute_instance.worker[1]: Creating...
module.kubernetes.yandex_compute_instance.master[0]: Creating...
module.kubernetes.yandex_compute_instance.worker[2]: Creating...
module.kubernetes.yandex_compute_instance.worker[0]: Still creating... [10s elapsed]
module.kubernetes.yandex_compute_instance.worker[1]: Still creating... [10s elapsed]
module.kubernetes.yandex_compute_instance.master[0]: Still creating... [10s elapsed]
module.kubernetes.yandex_compute_instance.worker[2]: Still creating... [10s elapsed]
module.kubernetes.yandex_compute_instance.worker[1]: Still creating... [20s elapsed]
module.kubernetes.yandex_compute_instance.worker[0]: Still creating... [20s elapsed]
module.kubernetes.yandex_compute_instance.master[0]: Still creating... [20s elapsed]
module.kubernetes.yandex_compute_instance.worker[2]: Still creating... [20s elapsed]
module.kubernetes.yandex_compute_instance.worker[1]: Still creating... [30s elapsed]
module.kubernetes.yandex_compute_instance.worker[0]: Still creating... [30s elapsed]
module.kubernetes.yandex_compute_instance.master[0]: Still creating... [30s elapsed]
module.kubernetes.yandex_compute_instance.worker[2]: Still creating... [30s elapsed]
module.kubernetes.yandex_compute_instance.worker[1]: Creation complete after 30s [id=fhmt1bh2p955d0f1f72a]
module.kubernetes.yandex_compute_instance.master[0]: Creation complete after 40s [id=fhmp3j4sp3aki3njfd23]
module.kubernetes.yandex_compute_instance.worker[0]: Still creating... [40s elapsed]
module.kubernetes.yandex_compute_instance.worker[2]: Still creating... [40s elapsed]
module.kubernetes.yandex_compute_instance.worker[0]: Creation complete after 42s [id=fhms3ck7p68bont19jk5]
module.kubernetes.yandex_compute_instance.worker[2]: Creation complete after 44s [id=fhm5tub66ct0p545llq7]
local_file.ansible_inventory: Creating...
local_file.ansible_inventory: Creation complete after 0s [id=5f1bd912962638d00c23e84c5a7332d363246e22]
null_resource.run_ansible: Creating...
null_resource.run_ansible: Provisioning with 'local-exec'...
null_resource.run_ansible (local-exec): Executing: ["/bin/sh" "-c" "ansible-playbook -T 300 -i ../../ansible/environments/stage/inventory.json ../../ansible/playbooks/k8s_deploy.yml"]

null_resource.run_ansible (local-exec): PLAY [Install k8s based image] *************************************************

null_resource.run_ansible (local-exec): TASK [docker : Wait for system to become reachable] ****************************
null_resource.run_ansible: Still creating... [10s elapsed]
null_resource.run_ansible: Still creating... [20s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [docker : Gather facts for the first time] ********************************
null_resource.run_ansible: Still creating... [30s elapsed]
null_resource.run_ansible (local-exec): [WARNING]: Platform linux on host k8s-worker-2 is using the discovered Python
null_resource.run_ansible (local-exec): interpreter at /usr/bin/python3.8, but future installation of another Python
null_resource.run_ansible (local-exec): interpreter could change the meaning of that path. See
null_resource.run_ansible (local-exec): https://docs.ansible.com/ansible-
null_resource.run_ansible (local-exec): core/2.17/reference_appendices/interpreter_discovery.html for more information.
null_resource.run_ansible (local-exec): [WARNING]: Platform linux on host k8s-worker-0 is using the discovered Python
null_resource.run_ansible (local-exec): interpreter at /usr/bin/python3.8, but future installation of another Python
null_resource.run_ansible (local-exec): interpreter could change the meaning of that path. See
null_resource.run_ansible (local-exec): https://docs.ansible.com/ansible-
null_resource.run_ansible (local-exec): core/2.17/reference_appendices/interpreter_discovery.html for more information.
null_resource.run_ansible (local-exec): [WARNING]: Platform linux on host k8s-worker-1 is using the discovered Python
null_resource.run_ansible (local-exec): interpreter at /usr/bin/python3.8, but future installation of another Python
null_resource.run_ansible (local-exec): interpreter could change the meaning of that path. See
null_resource.run_ansible (local-exec): https://docs.ansible.com/ansible-
null_resource.run_ansible (local-exec): core/2.17/reference_appendices/interpreter_discovery.html for more information.
null_resource.run_ansible (local-exec): [WARNING]: Platform linux on host k8s-master-0 is using the discovered Python
null_resource.run_ansible (local-exec): interpreter at /usr/bin/python3.8, but future installation of another Python
null_resource.run_ansible (local-exec): interpreter could change the meaning of that path. See
null_resource.run_ansible (local-exec): https://docs.ansible.com/ansible-
null_resource.run_ansible (local-exec): core/2.17/reference_appendices/interpreter_discovery.html for more information.
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [docker : fail] ***********************************************************
null_resource.run_ansible (local-exec): skipping: [k8s-master-0]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-0]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-1]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [docker : Install dependencies] *******************************************
null_resource.run_ansible: Still creating... [40s elapsed]
null_resource.run_ansible: Still creating... [50s elapsed]
null_resource.run_ansible: Still creating... [1m0s elapsed]
null_resource.run_ansible: Still creating... [1m10s elapsed]
null_resource.run_ansible: Still creating... [1m20s elapsed]
null_resource.run_ansible: Still creating... [1m30s elapsed]
null_resource.run_ansible: Still creating... [1m40s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=apt-transport-https)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=apt-transport-https)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=apt-transport-https)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=apt-transport-https)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=ca-certificates)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=ca-certificates)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=ca-certificates)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=ca-certificates)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=curl)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=curl)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=curl)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=curl)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=wget)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=wget)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=wget)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=wget)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=gnupg)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=gnupg)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=gnupg)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=gnupg)
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   net-tools
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net-tools)
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   net-tools
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net-tools)
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   net-tools
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net-tools)
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   net-tools
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net-tools)
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   ifupdown
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   bridge-utils
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=bridge-utils)
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   ifupdown
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   bridge-utils
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=bridge-utils)
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   ifupdown
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   bridge-utils
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=bridge-utils)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=vim)
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   ifupdown
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   bridge-utils
null_resource.run_ansible (local-exec): 0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=bridge-utils)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=vim)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=vim)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=vim)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   libjq1 libonig5
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   jq libjq1 libonig5
null_resource.run_ansible (local-exec): 0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=jq)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   libjq1 libonig5
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   jq libjq1 libonig5
null_resource.run_ansible (local-exec): 0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=jq)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   libjq1 libonig5
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   jq libjq1 libonig5
null_resource.run_ansible (local-exec): 0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=jq)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   libjq1 libonig5
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   jq libjq1 libonig5
null_resource.run_ansible (local-exec): 0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=jq)

null_resource.run_ansible (local-exec): TASK [docker : Add GPG key] ****************************************************
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]

null_resource.run_ansible (local-exec): TASK [docker : Add docker repository to apt] ***********************************
null_resource.run_ansible: Still creating... [1m50s elapsed]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/docker.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb https://download.docker.com/linux/ubuntu focal stable

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/docker.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb https://download.docker.com/linux/ubuntu focal stable

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/docker.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb https://download.docker.com/linux/ubuntu focal stable

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/docker.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb https://download.docker.com/linux/ubuntu focal stable

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [docker : Install docker] *************************************************
null_resource.run_ansible: Still creating... [2m0s elapsed]
null_resource.run_ansible: Still creating... [2m10s elapsed]
null_resource.run_ansible: Still creating... [2m20s elapsed]
null_resource.run_ansible: Still creating... [2m30s elapsed]
null_resource.run_ansible: Still creating... [2m40s elapsed]
null_resource.run_ansible: Still creating... [2m50s elapsed]
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras
null_resource.run_ansible (local-exec):   docker-compose-plugin git git-man libcurl3-gnutls liberror-perl
null_resource.run_ansible (local-exec):   libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz slirp4netns
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   aufs-tools cgroupfs-mount | cgroup-lite git-daemon-run | git-daemon-sysvinit
null_resource.run_ansible (local-exec):   git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
null_resource.run_ansible (local-exec):   diffutils-doc perl-doc libterm-readline-gnu-perl
null_resource.run_ansible (local-exec):   | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce docker-ce-cli
null_resource.run_ansible (local-exec):   docker-ce-rootless-extras docker-compose-plugin git git-man libcurl3-gnutls
null_resource.run_ansible (local-exec):   liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz
null_resource.run_ansible (local-exec):   slirp4netns
null_resource.run_ansible (local-exec): 0 upgraded, 17 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=docker-ce)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras
null_resource.run_ansible (local-exec):   docker-compose-plugin git git-man libcurl3-gnutls liberror-perl
null_resource.run_ansible (local-exec):   libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz slirp4netns
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   aufs-tools cgroupfs-mount | cgroup-lite git-daemon-run | git-daemon-sysvinit
null_resource.run_ansible (local-exec):   git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
null_resource.run_ansible (local-exec):   diffutils-doc perl-doc libterm-readline-gnu-perl
null_resource.run_ansible (local-exec):   | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce docker-ce-cli
null_resource.run_ansible (local-exec):   docker-ce-rootless-extras docker-compose-plugin git git-man libcurl3-gnutls
null_resource.run_ansible (local-exec):   liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz
null_resource.run_ansible (local-exec):   slirp4netns
null_resource.run_ansible (local-exec): 0 upgraded, 17 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=docker-ce)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras
null_resource.run_ansible (local-exec):   docker-compose-plugin git git-man libcurl3-gnutls liberror-perl
null_resource.run_ansible (local-exec):   libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz slirp4netns
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   aufs-tools cgroupfs-mount | cgroup-lite git-daemon-run | git-daemon-sysvinit
null_resource.run_ansible (local-exec):   git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
null_resource.run_ansible (local-exec):   diffutils-doc perl-doc libterm-readline-gnu-perl
null_resource.run_ansible (local-exec):   | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce docker-ce-cli
null_resource.run_ansible (local-exec):   docker-ce-rootless-extras docker-compose-plugin git git-man libcurl3-gnutls
null_resource.run_ansible (local-exec):   liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz
null_resource.run_ansible (local-exec):   slirp4netns
null_resource.run_ansible (local-exec): 0 upgraded, 17 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=docker-ce)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=docker-ce-cli)
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras
null_resource.run_ansible (local-exec):   docker-compose-plugin git git-man libcurl3-gnutls liberror-perl
null_resource.run_ansible (local-exec):   libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz slirp4netns
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   aufs-tools cgroupfs-mount | cgroup-lite git-daemon-run | git-daemon-sysvinit
null_resource.run_ansible (local-exec):   git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
null_resource.run_ansible (local-exec):   diffutils-doc perl-doc libterm-readline-gnu-perl
null_resource.run_ansible (local-exec):   | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   containerd.io docker-buildx-plugin docker-ce docker-ce-cli
null_resource.run_ansible (local-exec):   docker-ce-rootless-extras docker-compose-plugin git git-man libcurl3-gnutls
null_resource.run_ansible (local-exec):   liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30 pigz
null_resource.run_ansible (local-exec):   slirp4netns
null_resource.run_ansible (local-exec): 0 upgraded, 17 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=docker-ce)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=docker-ce-cli)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=docker-ce-cli)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=docker-ce-cli)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=containerd.io)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=containerd.io)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=containerd.io)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=containerd.io)

null_resource.run_ansible (local-exec): TASK [docker : Creating a file with content] ***********************************
null_resource.run_ansible: Still creating... [3m0s elapsed]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after: /etc/docker/daemon.json
null_resource.run_ansible (local-exec): @@ -0,0 +1,3 @@
null_resource.run_ansible (local-exec): +{
null_resource.run_ansible (local-exec): +  "exec-opts": ["native.cgroupdriver=systemd"]
null_resource.run_ansible (local-exec): +}

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after: /etc/docker/daemon.json
null_resource.run_ansible (local-exec): @@ -0,0 +1,3 @@
null_resource.run_ansible (local-exec): +{
null_resource.run_ansible (local-exec): +  "exec-opts": ["native.cgroupdriver=systemd"]
null_resource.run_ansible (local-exec): +}

null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after: /etc/docker/daemon.json
null_resource.run_ansible (local-exec): @@ -0,0 +1,3 @@
null_resource.run_ansible (local-exec): +{
null_resource.run_ansible (local-exec): +  "exec-opts": ["native.cgroupdriver=systemd"]
null_resource.run_ansible (local-exec): +}

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after: /etc/docker/daemon.json
null_resource.run_ansible (local-exec): @@ -0,0 +1,3 @@
null_resource.run_ansible (local-exec): +{
null_resource.run_ansible (local-exec): +  "exec-opts": ["native.cgroupdriver=systemd"]
null_resource.run_ansible (local-exec): +}

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [docker : Check docker is active] *****************************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [docker : Ensure group "docker" exists] ***********************************
null_resource.run_ansible: Still creating... [3m10s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]

null_resource.run_ansible (local-exec): TASK [docker : Adding ubuntu to docker group] **********************************
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]

null_resource.run_ansible (local-exec): TASK [docker : Install docker-compose] *****************************************
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [docker : Change file ownership, group and permissions] *******************
null_resource.run_ansible: Still creating... [3m20s elapsed]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after
null_resource.run_ansible (local-exec): @@ -1,6 +1,6 @@
null_resource.run_ansible (local-exec):  {
null_resource.run_ansible (local-exec): -    "group": 0,
null_resource.run_ansible (local-exec): -    "mode": "0754",
null_resource.run_ansible (local-exec): -    "owner": 0,
null_resource.run_ansible (local-exec): +    "group": 998,
null_resource.run_ansible (local-exec): +    "mode": "0755",
null_resource.run_ansible (local-exec): +    "owner": 1000,
null_resource.run_ansible (local-exec):      "path": "/usr/local/bin/docker-compose"
null_resource.run_ansible (local-exec):  }

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after
null_resource.run_ansible (local-exec): @@ -1,6 +1,6 @@
null_resource.run_ansible (local-exec):  {
null_resource.run_ansible (local-exec): -    "group": 0,
null_resource.run_ansible (local-exec): -    "mode": "0754",
null_resource.run_ansible (local-exec): -    "owner": 0,
null_resource.run_ansible (local-exec): +    "group": 998,
null_resource.run_ansible (local-exec): +    "mode": "0755",
null_resource.run_ansible (local-exec): +    "owner": 1000,
null_resource.run_ansible (local-exec):      "path": "/usr/local/bin/docker-compose"
null_resource.run_ansible (local-exec):  }

null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after
null_resource.run_ansible (local-exec): @@ -1,6 +1,6 @@
null_resource.run_ansible (local-exec):  {
null_resource.run_ansible (local-exec): -    "group": 0,
null_resource.run_ansible (local-exec): -    "mode": "0754",
null_resource.run_ansible (local-exec): -    "owner": 0,
null_resource.run_ansible (local-exec): +    "group": 998,
null_resource.run_ansible (local-exec): +    "mode": "0755",
null_resource.run_ansible (local-exec): +    "owner": 1000,
null_resource.run_ansible (local-exec):      "path": "/usr/local/bin/docker-compose"
null_resource.run_ansible (local-exec):  }

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after
null_resource.run_ansible (local-exec): @@ -1,6 +1,6 @@
null_resource.run_ansible (local-exec):  {
null_resource.run_ansible (local-exec): -    "group": 0,
null_resource.run_ansible (local-exec): -    "mode": "0754",
null_resource.run_ansible (local-exec): -    "owner": 0,
null_resource.run_ansible (local-exec): +    "group": 998,
null_resource.run_ansible (local-exec): +    "mode": "0755",
null_resource.run_ansible (local-exec): +    "owner": 1000,
null_resource.run_ansible (local-exec):      "path": "/usr/local/bin/docker-compose"
null_resource.run_ansible (local-exec):  }

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Remove swapfile from /etc/fstab] ****************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=swap)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=swap)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=swap)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=swap)
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => (item=none)
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => (item=none)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=none)
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => (item=none)

null_resource.run_ansible (local-exec): TASK [kubernetes : Check swap] *************************************************
null_resource.run_ansible: Still creating... [3m30s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Disable swap] ***********************************************
null_resource.run_ansible (local-exec): skipping: [k8s-master-0]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-0]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-1]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Disable swap in fstab (Kubeadm requirement)] ****************
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Create an empty file for the Containerd module] *************
null_resource.run_ansible: Still creating... [3m40s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Configure modules for Containerd] ***************************
null_resource.run_ansible (local-exec): --- before: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1,4 @@
null_resource.run_ansible (local-exec): +# BEGIN ANSIBLE MANAGED BLOCK
null_resource.run_ansible (local-exec): +overlay
null_resource.run_ansible (local-exec): +br_netfilter
null_resource.run_ansible (local-exec): +# END ANSIBLE MANAGED BLOCK

null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): --- before: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1,4 @@
null_resource.run_ansible (local-exec): +# BEGIN ANSIBLE MANAGED BLOCK
null_resource.run_ansible (local-exec): +overlay
null_resource.run_ansible (local-exec): +br_netfilter
null_resource.run_ansible (local-exec): +# END ANSIBLE MANAGED BLOCK

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1,4 @@
null_resource.run_ansible (local-exec): +# BEGIN ANSIBLE MANAGED BLOCK
null_resource.run_ansible (local-exec): +overlay
null_resource.run_ansible (local-exec): +br_netfilter
null_resource.run_ansible (local-exec): +# END ANSIBLE MANAGED BLOCK

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): --- before: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/modules-load.d/containerd.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1,4 @@
null_resource.run_ansible (local-exec): +# BEGIN ANSIBLE MANAGED BLOCK
null_resource.run_ansible (local-exec): +overlay
null_resource.run_ansible (local-exec): +br_netfilter
null_resource.run_ansible (local-exec): +# END ANSIBLE MANAGED BLOCK

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Create an empty file for Kubernetes sysctl params] **********
null_resource.run_ansible: Still creating... [3m50s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : Configure sysctl params for Kubernetes] *********************
null_resource.run_ansible: Still creating... [4m0s elapsed]
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +net.ipv4.ip_forward = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.ipv4.ip_forward = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +net.ipv4.ip_forward = 1

null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.ipv4.ip_forward = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +net.ipv4.ip_forward = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.ipv4.ip_forward = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +net.ipv4.ip_forward = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.ipv4.ip_forward = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1 +1,2 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-iptables = 1

null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.bridge.bridge-nf-call-iptables = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1 +1,2 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-iptables = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.bridge.bridge-nf-call-iptables = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1 +1,2 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-iptables = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.bridge.bridge-nf-call-iptables = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1 +1,2 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-iptables = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.bridge.bridge-nf-call-iptables = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1,2 +1,3 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec):  net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-ip6tables = 1

null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1,2 +1,3 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec):  net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-ip6tables = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.bridge.bridge-nf-call-ip6tables = 1)
null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1,2 +1,3 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec):  net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-ip6tables = 1

null_resource.run_ansible (local-exec): --- before: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): +++ after: /etc/sysctl.d/99-kubernetes-cri.conf (content)
null_resource.run_ansible (local-exec): @@ -1,2 +1,3 @@
null_resource.run_ansible (local-exec):  net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec):  net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): +net.bridge.bridge-nf-call-ip6tables = 1

null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.bridge.bridge-nf-call-ip6tables = 1)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.bridge.bridge-nf-call-ip6tables = 1)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.bridge.bridge-nf-call-ip6tables = 1)

null_resource.run_ansible (local-exec): TASK [kubernetes : Load br_netfilter kernel module] ****************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : Let iptables see bridged traffic.] **************************
null_resource.run_ansible: Still creating... [4m10s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.ipv4.ip_forward)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.ipv4.ip_forward)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.ipv4.ip_forward)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.ipv4.ip_forward)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.bridge.bridge-nf-call-iptables)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.bridge.bridge-nf-call-iptables)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.bridge.bridge-nf-call-iptables)
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.bridge.bridge-nf-call-iptables)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=net.bridge.bridge-nf-call-ip6tables)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=net.bridge.bridge-nf-call-ip6tables)
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=net.bridge.bridge-nf-call-ip6tables)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=net.bridge.bridge-nf-call-ip6tables)

null_resource.run_ansible (local-exec): TASK [kubernetes : Verify system variables are set] ****************************
null_resource.run_ansible: Still creating... [4m20s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : debug] ******************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-ip6tables = 1
null_resource.run_ansible (local-exec): net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-ip6tables = 1
null_resource.run_ansible (local-exec): net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-ip6tables = 1
null_resource.run_ansible (local-exec): net.ipv4.ip_forward = 1
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-iptables = 1
null_resource.run_ansible (local-exec): net.bridge.bridge-nf-call-ip6tables = 1
null_resource.run_ansible (local-exec): net.ipv4.ip_forward = 1

null_resource.run_ansible (local-exec): TASK [kubernetes : Add Kubernetes APT key] *************************************
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : Add Kubernetes' APT repository] *****************************
null_resource.run_ansible: Still creating... [4m30s elapsed]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/kubernetes.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/kubernetes.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/kubernetes.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before: /dev/null
null_resource.run_ansible (local-exec): +++ after: /etc/apt/sources.list.d/kubernetes.list
null_resource.run_ansible (local-exec): @@ -0,0 +1 @@
null_resource.run_ansible (local-exec): +deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : Configure containerd] ***************************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : Configure containerd] ***************************************
null_resource.run_ansible: Still creating... [4m40s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Configuring the systemd cgroup driver for containerd] *******
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Add the systemd cgroup driver for containerd] ***************
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Show the file content] **************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Enable containerd service, and start it] ********************
null_resource.run_ansible: Still creating... [4m50s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Installing kubernetes] **************************************
null_resource.run_ansible: Still creating... [5m0s elapsed]
null_resource.run_ansible: Still creating... [5m10s elapsed]
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubernetes-cni socat
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   nftables
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubeadm kubectl kubelet kubernetes-cni
null_resource.run_ansible (local-exec):   socat
null_resource.run_ansible (local-exec): 0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubernetes-cni socat
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   nftables
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubeadm kubectl kubelet kubernetes-cni
null_resource.run_ansible (local-exec):   socat
null_resource.run_ansible (local-exec): 0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubernetes-cni socat
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   nftables
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubeadm kubectl kubelet kubernetes-cni
null_resource.run_ansible (local-exec):   socat
null_resource.run_ansible (local-exec): 0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): The following additional packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubernetes-cni socat
null_resource.run_ansible (local-exec): Suggested packages:
null_resource.run_ansible (local-exec):   nftables
null_resource.run_ansible (local-exec): The following NEW packages will be installed:
null_resource.run_ansible (local-exec):   conntrack cri-tools ebtables ethtool kubeadm kubectl kubelet kubernetes-cni
null_resource.run_ansible (local-exec):   socat
null_resource.run_ansible (local-exec): 0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [kubernetes : Enable service kubelet] *************************************
null_resource.run_ansible: Still creating... [5m20s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Add runtime args in Kubelet config] *************************
null_resource.run_ansible (local-exec): --- before: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): +++ after: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): @@ -1 +1 @@
null_resource.run_ansible (local-exec): -KUBELET_EXTRA_ARGS=
null_resource.run_ansible (local-exec): +KUBELET_EXTRA_ARGS= --runtime-cgroups=/system.slice/containerd.service --container-runtime-endpoint=unix:///run/containerd/containerd.sock

null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): --- before: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): +++ after: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): @@ -1 +1 @@
null_resource.run_ansible (local-exec): -KUBELET_EXTRA_ARGS=
null_resource.run_ansible (local-exec): +KUBELET_EXTRA_ARGS= --runtime-cgroups=/system.slice/containerd.service --container-runtime-endpoint=unix:///run/containerd/containerd.sock

null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): --- before: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): +++ after: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): @@ -1 +1 @@
null_resource.run_ansible (local-exec): -KUBELET_EXTRA_ARGS=
null_resource.run_ansible (local-exec): +KUBELET_EXTRA_ARGS= --runtime-cgroups=/system.slice/containerd.service --container-runtime-endpoint=unix:///run/containerd/containerd.sock

null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): --- before: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): +++ after: /etc/default/kubelet (content)
null_resource.run_ansible (local-exec): @@ -1 +1 @@
null_resource.run_ansible (local-exec): -KUBELET_EXTRA_ARGS=
null_resource.run_ansible (local-exec): +KUBELET_EXTRA_ARGS= --runtime-cgroups=/system.slice/containerd.service --container-runtime-endpoint=unix:///run/containerd/containerd.sock

null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [kubernetes : Prevent kubernetes from being upgraded] *********************
null_resource.run_ansible: Still creating... [5m30s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=kubelet)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=kubelet)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=kubelet)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=kubelet)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=kubeadm)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=kubeadm)
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=kubeadm)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=kubeadm)
null_resource.run_ansible (local-exec): changed: [k8s-worker-2] => (item=kubectl)
null_resource.run_ansible (local-exec): changed: [k8s-worker-1] => (item=kubectl)
null_resource.run_ansible (local-exec): changed: [k8s-master-0] => (item=kubectl)
null_resource.run_ansible (local-exec): changed: [k8s-worker-0] => (item=kubectl)

null_resource.run_ansible (local-exec): TASK [kubernetes : Reboot all the kubernetes nodes] ****************************
null_resource.run_ansible: Still creating... [5m40s elapsed]
null_resource.run_ansible: Still creating... [5m50s elapsed]
null_resource.run_ansible: Still creating... [6m0s elapsed]
null_resource.run_ansible: Still creating... [6m10s elapsed]
null_resource.run_ansible: Still creating... [6m20s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [kubernetes : pause] ******************************************************
null_resource.run_ansible: Still creating... [6m30s elapsed]
null_resource.run_ansible: Still creating... [6m40s elapsed]
null_resource.run_ansible: Still creating... [6m50s elapsed]
null_resource.run_ansible (local-exec): Pausing for 30 seconds
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): RUNNING HANDLER [docker : Docker Compose Standalone version] *******************
null_resource.run_ansible: Still creating... [7m0s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): RUNNING HANDLER [docker : Reload docker service] *******************************
null_resource.run_ansible: Still creating... [7m10s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): PLAY [Install K8s master base image] *******************************************

null_resource.run_ansible (local-exec): TASK [Create an empty file for Kubeadm configuring] ****************************
null_resource.run_ansible: Still creating... [7m20s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Configuring the container runtime including its cgroup driver] ***********
null_resource.run_ansible: Still creating... [7m30s elapsed]
null_resource.run_ansible (local-exec): --- before: /etc/kubernetes/kubeadm-config.yaml (content)
null_resource.run_ansible (local-exec): +++ after: /etc/kubernetes/kubeadm-config.yaml (content)
null_resource.run_ansible (local-exec): @@ -0,0 +1,23 @@
null_resource.run_ansible (local-exec): +# BEGIN ANSIBLE MANAGED BLOCK
null_resource.run_ansible (local-exec): +kind: ClusterConfiguration
null_resource.run_ansible (local-exec): +apiVersion: kubeadm.k8s.io/v1beta3
null_resource.run_ansible (local-exec): +networking:
null_resource.run_ansible (local-exec): +  podSubnet: "10.244.0.0/16"
null_resource.run_ansible (local-exec): +controlPlaneEndpoint: "178.154.202.246"
null_resource.run_ansible (local-exec): +apiServer:
null_resource.run_ansible (local-exec): +  certSANs:
null_resource.run_ansible (local-exec): +    - "178.154.202.246"
null_resource.run_ansible (local-exec): +---
null_resource.run_ansible (local-exec): +kind: KubeletConfiguration
null_resource.run_ansible (local-exec): +apiVersion: kubelet.config.k8s.io/v1beta1
null_resource.run_ansible (local-exec): +runtimeRequestTimeout: "15m"
null_resource.run_ansible (local-exec): +cgroupDriver: "systemd"
null_resource.run_ansible (local-exec): +systemReserved:
null_resource.run_ansible (local-exec): +  cpu: 100m
null_resource.run_ansible (local-exec): +  memory: 350M
null_resource.run_ansible (local-exec): +kubeReserved:
null_resource.run_ansible (local-exec): +  cpu: 100m
null_resource.run_ansible (local-exec): +  memory: 50M
null_resource.run_ansible (local-exec): +enforceNodeAllocatable:
null_resource.run_ansible (local-exec): +  - pods
null_resource.run_ansible (local-exec): +# END ANSIBLE MANAGED BLOCK

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Initialize the cluster] **************************************************
null_resource.run_ansible: Still creating... [7m40s elapsed]
null_resource.run_ansible: Still creating... [7m50s elapsed]
null_resource.run_ansible: Still creating... [8m0s elapsed]
null_resource.run_ansible: Still creating... [8m10s elapsed]
null_resource.run_ansible: Still creating... [8m20s elapsed]
null_resource.run_ansible: Still creating... [8m30s elapsed]
null_resource.run_ansible: Still creating... [8m40s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Create .kube directory] **************************************************
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after
null_resource.run_ansible (local-exec): @@ -1,6 +1,6 @@
null_resource.run_ansible (local-exec):  {
null_resource.run_ansible (local-exec): -    "group": 0,
null_resource.run_ansible (local-exec): -    "owner": 0,
null_resource.run_ansible (local-exec): +    "group": 1001,
null_resource.run_ansible (local-exec): +    "owner": 1000,
null_resource.run_ansible (local-exec):      "path": "/home/ubuntu/.kube",
null_resource.run_ansible (local-exec): -    "state": "absent"
null_resource.run_ansible (local-exec): +    "state": "directory"
null_resource.run_ansible (local-exec):  }

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Copy admin.conf to user's kube config] ***********************************
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Fetch kube config] *******************************************************
null_resource.run_ansible: Still creating... [8m50s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Get the Calico manifest file] ********************************************
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Modify the file calico.yaml] *********************************************
null_resource.run_ansible: Still creating... [9m0s elapsed]
null_resource.run_ansible (local-exec): --- before: calico.yaml
null_resource.run_ansible (local-exec): +++ after: calico.yaml
null_resource.run_ansible (local-exec): @@ -4596,12 +4596,12 @@
null_resource.run_ansible (local-exec):                    name: calico-config
null_resource.run_ansible (local-exec):                    key: veth_mtu
null_resource.run_ansible (local-exec):              # The default IPv4 pool to create on startup if none exists. Pod IPs will be
null_resource.run_ansible (local-exec):              # chosen from this range. Changing this value after installation will have
null_resource.run_ansible (local-exec):              # no effect. This should fall within `--cluster-cidr`.
null_resource.run_ansible (local-exec): -            # - name: CALICO_IPV4POOL_CIDR
null_resource.run_ansible (local-exec): -            #   value: "192.168.0.0/16"
null_resource.run_ansible (local-exec): +            - name: CALICO_IPV4POOL_CIDR
null_resource.run_ansible (local-exec): +              value: "10.244.0.0/16"
null_resource.run_ansible (local-exec):              # Disable file logging so `kubectl logs` works.
null_resource.run_ansible (local-exec):              - name: CALICO_DISABLE_FILE_LOGGING
null_resource.run_ansible (local-exec):                value: "true"
null_resource.run_ansible (local-exec):              # Set Felix endpoint to host default action to ACCEPT.
null_resource.run_ansible (local-exec):              - name: FELIX_DEFAULTENDPOINTTOHOSTACTION

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => {}

null_resource.run_ansible (local-exec): MSG:



null_resource.run_ansible (local-exec): TASK [Apply Pods plugins] ******************************************************
null_resource.run_ansible: Still creating... [9m10s elapsed]
null_resource.run_ansible: Still creating... [9m20s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=kubectl apply -f calico.yaml)

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item={'changed': False, 'stdout': '', 'stderr': '', 'rc': 0, 'cmd': 'kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml >> pods_setup.log', 'start': '2024-06-18 19:04:02.208655', 'end': '2024-06-18 19:04:09.972618', 'delta': '0:00:07.763963', 'msg': '', 'invocation': {'module_args': {'chdir': '/home/ubuntu', '_raw_params': 'kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml >> pods_setup.log', '_uses_shell': True, 'expand_argument_vars': True, 'stdin_add_newline': True, 'strip_empty_ends': True, 'argv': None, 'executable': None, 'creates': None, 'removes': None, 'stdin': None}}, 'stdout_lines': [], 'stderr_lines': [], 'failed': False, 'item': 'kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml', 'ansible_loop_var': 'item'}) => {}
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item={'changed': False, 'stdout': '', 'stderr': '', 'rc': 0, 'cmd': 'kubectl apply -f calico.yaml >> pods_setup.log', 'start': '2024-06-18 19:04:14.801522', 'end': '2024-06-18 19:04:16.566016', 'delta': '0:00:01.764494', 'msg': '', 'invocation': {'module_args': {'chdir': '/home/ubuntu', '_raw_params': 'kubectl apply -f calico.yaml >> pods_setup.log', '_uses_shell': True, 'expand_argument_vars': True, 'stdin_add_newline': True, 'strip_empty_ends': True, 'argv': None, 'executable': None, 'creates': None, 'removes': None, 'stdin': None}}, 'stdout_lines': [], 'stderr_lines': [], 'failed': False, 'item': 'kubectl apply -f calico.yaml', 'ansible_loop_var': 'item'}) => {}

null_resource.run_ansible (local-exec): TASK [Get token] ***************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): ['kubeadm join 178.154.202.246:6443 --token gcbzdl.inu8pz3c4zl5gki9 --discovery-token-ca-cert-hash sha256:4ecbe2d65473e2da1bbd3763531ddf9e01ad74450eee32ad3e40742350f5ceef ']

null_resource.run_ansible (local-exec): TASK [Set join command] ********************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0 -> k8s-worker-0(158.160.47.203)] => (item=k8s-worker-0)
null_resource.run_ansible (local-exec): ok: [k8s-master-0 -> k8s-worker-1(158.160.121.186)] => (item=k8s-worker-1)
null_resource.run_ansible (local-exec): ok: [k8s-master-0 -> k8s-worker-2(158.160.38.75)] => (item=k8s-worker-2)

null_resource.run_ansible (local-exec): TASK [Download K9s] ************************************************************
null_resource.run_ansible: Still creating... [9m30s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Install K9s] *************************************************************
null_resource.run_ansible: Still creating... [9m40s elapsed]
null_resource.run_ansible: Still creating... [9m50s elapsed]
null_resource.run_ansible: Still creating... [10m0s elapsed]
null_resource.run_ansible: Still creating... [10m10s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): PLAY [Configure K8s workers base image] ****************************************

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): ['The master host IP is 178.154.202.246', 'kubeadm join 178.154.202.246:6443 --token gcbzdl.inu8pz3c4zl5gki9 --discovery-token-ca-cert-hash sha256:4ecbe2d65473e2da1bbd3763531ddf9e01ad74450eee32ad3e40742350f5ceef ']
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): ['The master host IP is 178.154.202.246', 'kubeadm join 178.154.202.246:6443 --token gcbzdl.inu8pz3c4zl5gki9 --discovery-token-ca-cert-hash sha256:4ecbe2d65473e2da1bbd3763531ddf9e01ad74450eee32ad3e40742350f5ceef ']
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): ['The master host IP is 178.154.202.246', 'kubeadm join 178.154.202.246:6443 --token gcbzdl.inu8pz3c4zl5gki9 --discovery-token-ca-cert-hash sha256:4ecbe2d65473e2da1bbd3763531ddf9e01ad74450eee32ad3e40742350f5ceef ']

null_resource.run_ansible (local-exec): TASK [TCP port 6443 on master is reachable from worker] ************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-0]
null_resource.run_ansible (local-exec): ok: [k8s-worker-2]
null_resource.run_ansible (local-exec): ok: [k8s-worker-1]

null_resource.run_ansible (local-exec): TASK [fail] ********************************************************************
null_resource.run_ansible (local-exec): skipping: [k8s-worker-0]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-1]
null_resource.run_ansible (local-exec): skipping: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [Join cluster] ************************************************************
null_resource.run_ansible: Still creating... [10m20s elapsed]
null_resource.run_ansible: Still creating... [10m30s elapsed]
null_resource.run_ansible (local-exec): changed: [k8s-worker-0]
null_resource.run_ansible (local-exec): changed: [k8s-worker-1]
null_resource.run_ansible (local-exec): changed: [k8s-worker-2]

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-worker-0] => {}
null_resource.run_ansible (local-exec): ok: [k8s-worker-1] => {}
null_resource.run_ansible (local-exec): ok: [k8s-worker-2] => {}

null_resource.run_ansible (local-exec): PLAY [Run checks on k8s] *******************************************************

null_resource.run_ansible (local-exec): TASK [Get nodes] ***************************************************************
null_resource.run_ansible: Still creating... [10m40s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): NAME                   STATUS     ROLES           AGE    VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
null_resource.run_ansible (local-exec): fhm5tub66ct0p545llq7   NotReady   <none>          6s     v1.29.6   192.168.99.16   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhmp3j4sp3aki3njfd23   Ready      control-plane   2m7s   v1.29.6   192.168.99.17   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhms3ck7p68bont19jk5   NotReady   <none>          15s    v1.29.6   192.168.99.32   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhmt1bh2p955d0f1f72a   NotReady   <none>          14s    v1.29.6   192.168.99.24   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33


null_resource.run_ansible (local-exec): TASK [Waiting for pods to finish start] ****************************************
null_resource.run_ansible: Still creating... [10m50s elapsed]
null_resource.run_ansible: Still creating... [11m0s elapsed]
null_resource.run_ansible: Still creating... [11m10s elapsed]
null_resource.run_ansible: Still creating... [11m20s elapsed]
null_resource.run_ansible: Still creating... [11m30s elapsed]
null_resource.run_ansible: Still creating... [11m40s elapsed]
null_resource.run_ansible (local-exec): Pausing for 60 seconds
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Get pods] ****************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): NAMESPACE      NAME                                           READY   STATUS    RESTARTS   AGE     IP              NODE                   NOMINATED NODE   READINESS GATESCommands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-flannel   kube-flannel-ds-l6x76                          1/1     Running   0          79s     192.168.99.24   fhmt1bh2p955d0f1f72a   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-flannel   kube-flannel-ds-rc9p6                          1/1     Running   0          72s     192.168.99.16   fhm5tub66ct0p545llq7   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-flannel   kube-flannel-ds-v2vdt                          1/1     Running   0          2m33s   192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-flannel   kube-flannel-ds-w7mm7                          1/1     Running   0          81s     192.168.99.32   fhms3ck7p68bont19jk5   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    calico-kube-controllers-658d97c59c-cxhmp       1/1     Running   0          2m26s   10.244.0.4      fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    calico-node-9brpz                              1/1     Running   0          2m26s   192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    calico-node-dhnr7                              1/1     Running   0          81s     192.168.99.32   fhms3ck7p68bont19jk5   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    calico-node-gmcwt                              1/1     Running   0          79s     192.168.99.24   fhmt1bh2p955d0f1f72a   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    calico-node-trwpq                              1/1     Running   0          72s     192.168.99.16   fhm5tub66ct0p545llq7   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    coredns-76f75df574-9ns5v                       1/1     Running   0          2m53s   10.244.0.3      fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    coredns-76f75df574-qghdc                       1/1     Running   0          2m53s   10.244.0.2      fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    etcd-fhmp3j4sp3aki3njfd23                      1/1     Running   0          3m6s    192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-apiserver-fhmp3j4sp3aki3njfd23            1/1     Running   0          3m11s   192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-controller-manager-fhmp3j4sp3aki3njfd23   1/1     Running   0          3m9s    192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-proxy-cz8k5                               1/1     Running   0          72s     192.168.99.16   fhm5tub66ct0p545llq7   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-proxy-jkxmc                               1/1     Running   0          2m53s   192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-proxy-nkh9m                               1/1     Running   0          81s     192.168.99.32   fhms3ck7p68bont19jk5   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-proxy-rjgd2                               1/1     Running   0          79s     192.168.99.24   fhmt1bh2p955d0f1f72a   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when
null_resource.run_ansible (local-exec): kube-system    kube-scheduler-fhmp3j4sp3aki3njfd23            1/1     Running   0          3m10s   192.168.99.17   fhmp3j4sp3aki3njfd23   <none>           <none>Commands should not change things if nothing needs doing.ansible-lintno-changed-when


null_resource.run_ansible (local-exec): TASK [Check cluster] ***********************************************************
null_resource.run_ansible: Still creating... [11m50s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=kubectl config view)
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=kubectl describe node)

null_resource.run_ansible (local-exec): TASK [debug] *******************************************************************
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item={'changed': False, 'stdout': 'apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority-data: DATA+OMITTED\n    server: https://178.154.202.246:6443\n  name: kubernetes\ncontexts:\n- context:\n    cluster: kubernetes\n    user: kubernetes-admin\n  name: kubernetes-admin@kubernetes\ncurrent-context: kubernetes-admin@kubernetes\nkind: Config\npreferences: {}\nusers:\n- name: kubernetes-admin\n  user:\n    client-certificate-data: DATA+OMITTED\n    client-key-data: DATA+OMITTED', 'stderr': '', 'rc': 0, 'cmd': ['kubectl', 'config', 'view'], 'start': '2024-06-18 19:06:46.442006', 'end': '2024-06-18 19:06:46.495205', 'delta': '0:00:00.053199', 'msg': '', 'invocation': {'module_args': {'_raw_params': 'kubectl config view', '_uses_shell': False, 'expand_argument_vars': True, 'stdin_add_newline': True, 'strip_empty_ends': True, 'argv': None, 'chdir': None, 'executable': None, 'creates': None, 'removes': None, 'stdin': None}}, 'stdout_lines': ['apiVersion: v1', 'clusters:', '- cluster:', '    certificate-authority-data: DATA+OMITTED', '    server: https://178.154.202.246:6443', '  name: kubernetes', 'contexts:', '- context:', '    cluster: kubernetes', '    user: kubernetes-admin', '  name: kubernetes-admin@kubernetes', 'current-context: kubernetes-admin@kubernetes', 'kind: Config', 'preferences: {}', 'users:', '- name: kubernetes-admin', '  user:', '    client-certificate-data: DATA+OMITTED', '    client-key-data: DATA+OMITTED'], 'stderr_lines': [], 'failed': False, 'item': 'kubectl config view', 'ansible_loop_var': 'item'}) => {}

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): apiVersion: v1
null_resource.run_ansible (local-exec): clusters:
null_resource.run_ansible (local-exec): - cluster:
null_resource.run_ansible (local-exec):     certificate-authority-data: DATA+OMITTED
null_resource.run_ansible (local-exec):     server: https://178.154.202.246:6443
null_resource.run_ansible (local-exec):   name: kubernetes
null_resource.run_ansible (local-exec): contexts:
null_resource.run_ansible (local-exec): - context:
null_resource.run_ansible (local-exec):     cluster: kubernetes
null_resource.run_ansible (local-exec):     user: kubernetes-admin
null_resource.run_ansible (local-exec):   name: kubernetes-admin@kubernetes
null_resource.run_ansible (local-exec): current-context: kubernetes-admin@kubernetes
null_resource.run_ansible (local-exec): kind: Config
null_resource.run_ansible (local-exec): preferences: {}
null_resource.run_ansible (local-exec): users:
null_resource.run_ansible (local-exec): - name: kubernetes-admin
null_resource.run_ansible (local-exec):   user:
null_resource.run_ansible (local-exec):     client-certificate-data: DATA+OMITTED
null_resource.run_ansible (local-exec):     client-key-data: DATA+OMITTED
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => ...
null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): Name:               fhm5tub66ct0p545llq7
null_resource.run_ansible (local-exec): Roles:              <none>
null_resource.run_ansible (local-exec): Labels:             beta.kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     beta.kubernetes.io/os=linux
null_resource.run_ansible (local-exec):                     kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     kubernetes.io/hostname=fhm5tub66ct0p545llq7
null_resource.run_ansible (local-exec):                     kubernetes.io/os=linux
null_resource.run_ansible (local-exec): Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"3e:93:73:a4:4b:ee"}
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/backend-type: vxlan
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/kube-subnet-manager: true
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/public-ip: 192.168.99.16
null_resource.run_ansible (local-exec):                     kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/containerd/containerd.sock
null_resource.run_ansible (local-exec):                     node.alpha.kubernetes.io/ttl: 0
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4Address: 192.168.99.16/24
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4IPIPTunnelAddr: 10.244.246.64
null_resource.run_ansible (local-exec):                     volumes.kubernetes.io/controller-managed-attach-detach: true
null_resource.run_ansible (local-exec): CreationTimestamp:  Tue, 18 Jun 2024 19:05:30 +0000
null_resource.run_ansible (local-exec): Taints:             <none>
null_resource.run_ansible (local-exec): Unschedulable:      false
null_resource.run_ansible (local-exec): Lease:
null_resource.run_ansible (local-exec):   HolderIdentity:  fhm5tub66ct0p545llq7
null_resource.run_ansible (local-exec):   AcquireTime:     <unset>
null_resource.run_ansible (local-exec):   RenewTime:       Tue, 18 Jun 2024 19:06:42 +0000
null_resource.run_ansible (local-exec): Conditions:
null_resource.run_ansible (local-exec):   Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
null_resource.run_ansible (local-exec):   ----                 ------  -----------------                 ------------------                ------                       -------
null_resource.run_ansible (local-exec):   NetworkUnavailable   False   Tue, 18 Jun 2024 19:06:15 +0000   Tue, 18 Jun 2024 19:06:15 +0000   FlannelIsUp                  Flannel is running on this node
null_resource.run_ansible (local-exec):   MemoryPressure       False   Tue, 18 Jun 2024 19:06:31 +0000   Tue, 18 Jun 2024 19:05:30 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
null_resource.run_ansible (local-exec):   DiskPressure         False   Tue, 18 Jun 2024 19:06:31 +0000   Tue, 18 Jun 2024 19:05:30 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
null_resource.run_ansible (local-exec):   PIDPressure          False   Tue, 18 Jun 2024 19:06:31 +0000   Tue, 18 Jun 2024 19:05:30 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
null_resource.run_ansible (local-exec):   Ready                True    Tue, 18 Jun 2024 19:06:31 +0000   Tue, 18 Jun 2024 19:05:55 +0000   KubeletReady                 kubelet is posting ready status. AppArmor enabled
null_resource.run_ansible (local-exec): Addresses:
null_resource.run_ansible (local-exec):   InternalIP:  192.168.99.16
null_resource.run_ansible (local-exec):   Hostname:    fhm5tub66ct0p545llq7
null_resource.run_ansible (local-exec): Capacity:
null_resource.run_ansible (local-exec):   cpu:                2
null_resource.run_ansible (local-exec):   ephemeral-storage:  41186748Ki
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             8136608Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): Allocatable:
null_resource.run_ansible (local-exec):   cpu:                1800m
null_resource.run_ansible (local-exec):   ephemeral-storage:  37957706894
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             7643583Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): System Info:
null_resource.run_ansible (local-exec):   Machine ID:                 23000007c6c5ef966333a0c9485ad747
null_resource.run_ansible (local-exec):   System UUID:                23000007-c6c5-ef96-6333-a0c9485ad747
null_resource.run_ansible (local-exec):   Boot ID:                    2f822006-5337-47bf-9181-5eedb18c6b62
null_resource.run_ansible (local-exec):   Kernel Version:             5.4.0-186-generic
null_resource.run_ansible (local-exec):   OS Image:                   Ubuntu 20.04.6 LTS
null_resource.run_ansible (local-exec):   Operating System:           linux
null_resource.run_ansible (local-exec):   Architecture:               amd64
null_resource.run_ansible (local-exec):   Container Runtime Version:  containerd://1.6.33
null_resource.run_ansible (local-exec):   Kubelet Version:            v1.29.6
null_resource.run_ansible (local-exec):   Kube-Proxy Version:         v1.29.6
null_resource.run_ansible (local-exec): PodCIDR:                      10.244.3.0/24
null_resource.run_ansible (local-exec): PodCIDRs:                     10.244.3.0/24
null_resource.run_ansible (local-exec): Non-terminated Pods:          (3 in total)
null_resource.run_ansible (local-exec):   Namespace                   Name                     CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
null_resource.run_ansible (local-exec):   ---------                   ----                     ------------  ----------  ---------------  -------------  ---
null_resource.run_ansible (local-exec):   kube-flannel                kube-flannel-ds-rc9p6    100m (5%)     0 (0%)      50Mi (0%)        0 (0%)         81s
null_resource.run_ansible (local-exec):   kube-system                 calico-node-trwpq        250m (13%)    0 (0%)      0 (0%)           0 (0%)         81s
null_resource.run_ansible (local-exec):   kube-system                 kube-proxy-cz8k5         0 (0%)        0 (0%)      0 (0%)           0 (0%)         81s
null_resource.run_ansible (local-exec): Allocated resources:
null_resource.run_ansible (local-exec):   (Total limits may be over 100 percent, i.e., overcommitted.)
null_resource.run_ansible (local-exec):   Resource           Requests    Limits
null_resource.run_ansible (local-exec):   --------           --------    ------
null_resource.run_ansible (local-exec):   cpu                350m (19%)  0 (0%)
null_resource.run_ansible (local-exec):   memory             50Mi (0%)   0 (0%)
null_resource.run_ansible (local-exec):   ephemeral-storage  0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-1Gi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-2Mi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec): Events:
null_resource.run_ansible (local-exec):   Type    Reason                   Age                From             Message
null_resource.run_ansible (local-exec):   ----    ------                   ----               ----             -------
null_resource.run_ansible (local-exec):   Normal  Starting                 58s                kube-proxy
null_resource.run_ansible (local-exec):   Normal  Starting                 81s                kubelet          Starting kubelet.
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientMemory  81s (x2 over 81s)  kubelet          Node fhm5tub66ct0p545llq7 status is now: NodeHasSufficientMemory
null_resource.run_ansible (local-exec):   Normal  NodeHasNoDiskPressure    81s (x2 over 81s)  kubelet          Node fhm5tub66ct0p545llq7 status is now: NodeHasNoDiskPressure
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientPID     81s (x2 over 81s)  kubelet          Node fhm5tub66ct0p545llq7 status is now: NodeHasSufficientPID
null_resource.run_ansible (local-exec):   Normal  NodeAllocatableEnforced  81s                kubelet          Updated Node Allocatable limit across pods
null_resource.run_ansible (local-exec):   Normal  RegisteredNode           78s                node-controller  Node fhm5tub66ct0p545llq7 event: Registered Node fhm5tub66ct0p545llq7 in Controller
null_resource.run_ansible (local-exec):   Normal  NodeReady                56s                kubelet          Node fhm5tub66ct0p545llq7 status is now: NodeReady


null_resource.run_ansible (local-exec): Name:               fhmp3j4sp3aki3njfd23
null_resource.run_ansible (local-exec): Roles:              control-plane
null_resource.run_ansible (local-exec): Labels:             beta.kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     beta.kubernetes.io/os=linux
null_resource.run_ansible (local-exec):                     kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     kubernetes.io/hostname=fhmp3j4sp3aki3njfd23
null_resource.run_ansible (local-exec):                     kubernetes.io/os=linux
null_resource.run_ansible (local-exec):                     node-role.kubernetes.io/control-plane=
null_resource.run_ansible (local-exec):                     node.kubernetes.io/exclude-from-external-load-balancers=
null_resource.run_ansible (local-exec): Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"02:6d:ae:93:9a:c8"}
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/backend-type: vxlan
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/kube-subnet-manager: true
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/public-ip: 192.168.99.17
null_resource.run_ansible (local-exec):                     kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/containerd/containerd.sock
null_resource.run_ansible (local-exec):                     node.alpha.kubernetes.io/ttl: 0
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4Address: 192.168.99.17/24
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4IPIPTunnelAddr: 10.244.42.64
null_resource.run_ansible (local-exec):                     volumes.kubernetes.io/controller-managed-attach-detach: true
null_resource.run_ansible (local-exec): CreationTimestamp:  Tue, 18 Jun 2024 19:03:29 +0000
null_resource.run_ansible (local-exec): Taints:             node-role.kubernetes.io/control-plane:NoSchedule
null_resource.run_ansible (local-exec): Unschedulable:      false
null_resource.run_ansible (local-exec): Lease:
null_resource.run_ansible (local-exec):   HolderIdentity:  fhmp3j4sp3aki3njfd23
null_resource.run_ansible (local-exec):   AcquireTime:     <unset>
null_resource.run_ansible (local-exec):   RenewTime:       Tue, 18 Jun 2024 19:06:41 +0000
null_resource.run_ansible (local-exec): Conditions:
null_resource.run_ansible (local-exec):   Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
null_resource.run_ansible (local-exec):   ----                 ------  -----------------                 ------------------                ------                       -------
null_resource.run_ansible (local-exec):   NetworkUnavailable   False   Tue, 18 Jun 2024 19:04:59 +0000   Tue, 18 Jun 2024 19:04:59 +0000   CalicoIsUp                   Calico is running on this node
null_resource.run_ansible (local-exec):   MemoryPressure       False   Tue, 18 Jun 2024 19:05:09 +0000   Tue, 18 Jun 2024 19:03:27 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
null_resource.run_ansible (local-exec):   DiskPressure         False   Tue, 18 Jun 2024 19:05:09 +0000   Tue, 18 Jun 2024 19:03:27 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
null_resource.run_ansible (local-exec):   PIDPressure          False   Tue, 18 Jun 2024 19:05:09 +0000   Tue, 18 Jun 2024 19:03:27 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
null_resource.run_ansible (local-exec):   Ready                True    Tue, 18 Jun 2024 19:05:09 +0000   Tue, 18 Jun 2024 19:04:20 +0000   KubeletReady                 kubelet is posting ready status. AppArmor enabled
null_resource.run_ansible (local-exec): Addresses:
null_resource.run_ansible (local-exec):   InternalIP:  192.168.99.17
null_resource.run_ansible (local-exec):   Hostname:    fhmp3j4sp3aki3njfd23
null_resource.run_ansible (local-exec): Capacity:
null_resource.run_ansible (local-exec):   cpu:                2
null_resource.run_ansible (local-exec):   ephemeral-storage:  41186748Ki
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             8136608Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): Allocatable:
null_resource.run_ansible (local-exec):   cpu:                1800m
null_resource.run_ansible (local-exec):   ephemeral-storage:  37957706894
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             7643583Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): System Info:
null_resource.run_ansible (local-exec):   Machine ID:                 23000007c6d91cc9cc8d5490ef37b443
null_resource.run_ansible (local-exec):   System UUID:                23000007-c6d9-1cc9-cc8d-5490ef37b443
null_resource.run_ansible (local-exec):   Boot ID:                    e7ae9caf-abc7-4e28-8c96-faab7cc656c9
null_resource.run_ansible (local-exec):   Kernel Version:             5.4.0-186-generic
null_resource.run_ansible (local-exec):   OS Image:                   Ubuntu 20.04.6 LTS
null_resource.run_ansible (local-exec):   Operating System:           linux
null_resource.run_ansible (local-exec):   Architecture:               amd64
null_resource.run_ansible (local-exec):   Container Runtime Version:  containerd://1.6.33
null_resource.run_ansible (local-exec):   Kubelet Version:            v1.29.6
null_resource.run_ansible (local-exec):   Kube-Proxy Version:         v1.29.6
null_resource.run_ansible (local-exec): PodCIDR:                      10.244.0.0/24
null_resource.run_ansible (local-exec): PodCIDRs:                     10.244.0.0/24
null_resource.run_ansible (local-exec): Non-terminated Pods:          (10 in total)
null_resource.run_ansible (local-exec):   Namespace                   Name                                            CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
null_resource.run_ansible (local-exec):   ---------                   ----                                            ------------  ----------  ---------------  -------------  ---
null_resource.run_ansible (local-exec):   kube-flannel                kube-flannel-ds-v2vdt                           100m (5%)     0 (0%)      50Mi (0%)        0 (0%)         2m42s
null_resource.run_ansible (local-exec):   kube-system                 calico-kube-controllers-658d97c59c-cxhmp        0 (0%)        0 (0%)      0 (0%)           0 (0%)         2m35s
null_resource.run_ansible (local-exec):   kube-system                 calico-node-9brpz                               250m (13%)    0 (0%)      0 (0%)           0 (0%)         2m35s
null_resource.run_ansible (local-exec):   kube-system                 coredns-76f75df574-9ns5v                        100m (5%)     0 (0%)      70Mi (0%)        170Mi (2%)     3m2s
null_resource.run_ansible (local-exec):   kube-system                 coredns-76f75df574-qghdc                        100m (5%)     0 (0%)      70Mi (0%)        170Mi (2%)     3m2s
null_resource.run_ansible (local-exec):   kube-system                 etcd-fhmp3j4sp3aki3njfd23                       100m (5%)     0 (0%)      100Mi (1%)       0 (0%)         3m15s
null_resource.run_ansible (local-exec):   kube-system                 kube-apiserver-fhmp3j4sp3aki3njfd23             250m (13%)    0 (0%)      0 (0%)           0 (0%)         3m20s
null_resource.run_ansible (local-exec):   kube-system                 kube-controller-manager-fhmp3j4sp3aki3njfd23    200m (11%)    0 (0%)      0 (0%)           0 (0%)         3m18s
null_resource.run_ansible (local-exec):   kube-system                 kube-proxy-jkxmc                                0 (0%)        0 (0%)      0 (0%)           0 (0%)         3m2s
null_resource.run_ansible (local-exec):   kube-system                 kube-scheduler-fhmp3j4sp3aki3njfd23             100m (5%)     0 (0%)      0 (0%)           0 (0%)         3m19s
null_resource.run_ansible (local-exec): Allocated resources:
null_resource.run_ansible (local-exec):   (Total limits may be over 100 percent, i.e., overcommitted.)
null_resource.run_ansible (local-exec):   Resource           Requests     Limits
null_resource.run_ansible (local-exec):   --------           --------     ------
null_resource.run_ansible (local-exec):   cpu                1200m (66%)  0 (0%)
null_resource.run_ansible (local-exec):   memory             290Mi (3%)   340Mi (4%)
null_resource.run_ansible (local-exec):   ephemeral-storage  0 (0%)       0 (0%)
null_resource.run_ansible (local-exec):   hugepages-1Gi      0 (0%)       0 (0%)
null_resource.run_ansible (local-exec):   hugepages-2Mi      0 (0%)       0 (0%)
null_resource.run_ansible (local-exec): Events:
null_resource.run_ansible (local-exec):   Type    Reason                   Age                    From             Message
null_resource.run_ansible (local-exec):   ----    ------                   ----                   ----             -------
null_resource.run_ansible (local-exec):   Normal  Starting                 3m                     kube-proxy
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientMemory  3m30s (x8 over 3m30s)  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasSufficientMemory
null_resource.run_ansible (local-exec):   Normal  NodeHasNoDiskPressure    3m30s (x8 over 3m30s)  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasNoDiskPressure
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientPID     3m30s (x7 over 3m30s)  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasSufficientPID
null_resource.run_ansible (local-exec):   Normal  NodeAllocatableEnforced  3m30s                  kubelet          Updated Node Allocatable limit across pods
null_resource.run_ansible (local-exec):   Normal  Starting                 3m15s                  kubelet          Starting kubelet.
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientMemory  3m15s                  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasSufficientMemory
null_resource.run_ansible (local-exec):   Normal  NodeHasNoDiskPressure    3m15s                  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasNoDiskPressure
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientPID     3m15s                  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeHasSufficientPID
null_resource.run_ansible (local-exec):   Normal  NodeAllocatableEnforced  3m15s                  kubelet          Updated Node Allocatable limit across pods
null_resource.run_ansible (local-exec):   Normal  RegisteredNode           3m3s                   node-controller  Node fhmp3j4sp3aki3njfd23 event: Registered Node fhmp3j4sp3aki3njfd23 in Controller
null_resource.run_ansible (local-exec):   Normal  NodeReady                2m31s                  kubelet          Node fhmp3j4sp3aki3njfd23 status is now: NodeReady


null_resource.run_ansible (local-exec): Name:               fhms3ck7p68bont19jk5
null_resource.run_ansible (local-exec): Roles:              <none>
null_resource.run_ansible (local-exec): Labels:             beta.kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     beta.kubernetes.io/os=linux
null_resource.run_ansible (local-exec):                     kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     kubernetes.io/hostname=fhms3ck7p68bont19jk5
null_resource.run_ansible (local-exec):                     kubernetes.io/os=linux
null_resource.run_ansible (local-exec): Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"b6:6a:2c:74:84:62"}
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/backend-type: vxlan
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/kube-subnet-manager: true
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/public-ip: 192.168.99.32
null_resource.run_ansible (local-exec):                     kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/containerd/containerd.sock
null_resource.run_ansible (local-exec):                     node.alpha.kubernetes.io/ttl: 0
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4Address: 192.168.99.32/24
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4IPIPTunnelAddr: 10.244.152.192
null_resource.run_ansible (local-exec):                     volumes.kubernetes.io/controller-managed-attach-detach: true
null_resource.run_ansible (local-exec): CreationTimestamp:  Tue, 18 Jun 2024 19:05:21 +0000
null_resource.run_ansible (local-exec): Taints:             <none>
null_resource.run_ansible (local-exec): Unschedulable:      false
null_resource.run_ansible (local-exec): Lease:
null_resource.run_ansible (local-exec):   HolderIdentity:  fhms3ck7p68bont19jk5
null_resource.run_ansible (local-exec):   AcquireTime:     <unset>
null_resource.run_ansible (local-exec):   RenewTime:       Tue, 18 Jun 2024 19:06:43 +0000
null_resource.run_ansible (local-exec): Conditions:
null_resource.run_ansible (local-exec):   Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
null_resource.run_ansible (local-exec):   ----                 ------  -----------------                 ------------------                ------                       -------
null_resource.run_ansible (local-exec):   NetworkUnavailable   False   Tue, 18 Jun 2024 19:05:59 +0000   Tue, 18 Jun 2024 19:05:59 +0000   CalicoIsUp                   Calico is running on this node
null_resource.run_ansible (local-exec):   MemoryPressure       False   Tue, 18 Jun 2024 19:06:22 +0000   Tue, 18 Jun 2024 19:05:21 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
null_resource.run_ansible (local-exec):   DiskPressure         False   Tue, 18 Jun 2024 19:06:22 +0000   Tue, 18 Jun 2024 19:05:21 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
null_resource.run_ansible (local-exec):   PIDPressure          False   Tue, 18 Jun 2024 19:06:22 +0000   Tue, 18 Jun 2024 19:05:21 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
null_resource.run_ansible (local-exec):   Ready                True    Tue, 18 Jun 2024 19:06:22 +0000   Tue, 18 Jun 2024 19:05:44 +0000   KubeletReady                 kubelet is posting ready status. AppArmor enabled
null_resource.run_ansible (local-exec): Addresses:
null_resource.run_ansible (local-exec):   InternalIP:  192.168.99.32
null_resource.run_ansible (local-exec):   Hostname:    fhms3ck7p68bont19jk5
null_resource.run_ansible (local-exec): Capacity:
null_resource.run_ansible (local-exec):   cpu:                2
null_resource.run_ansible (local-exec):   ephemeral-storage:  41186748Ki
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             8136608Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): Allocatable:
null_resource.run_ansible (local-exec):   cpu:                1800m
null_resource.run_ansible (local-exec):   ephemeral-storage:  37957706894
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             7643583Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): System Info:
null_resource.run_ansible (local-exec):   Machine ID:                 23000007c6dc1b287c990bc5fa14ce85
null_resource.run_ansible (local-exec):   System UUID:                23000007-c6dc-1b28-7c99-0bc5fa14ce85
null_resource.run_ansible (local-exec):   Boot ID:                    8d6c4901-df33-4d66-84ac-9822b450a214
null_resource.run_ansible (local-exec):   Kernel Version:             5.4.0-186-generic
null_resource.run_ansible (local-exec):   OS Image:                   Ubuntu 20.04.6 LTS
null_resource.run_ansible (local-exec):   Operating System:           linux
null_resource.run_ansible (local-exec):   Architecture:               amd64
null_resource.run_ansible (local-exec):   Container Runtime Version:  containerd://1.6.33
null_resource.run_ansible (local-exec):   Kubelet Version:            v1.29.6
null_resource.run_ansible (local-exec):   Kube-Proxy Version:         v1.29.6
null_resource.run_ansible (local-exec): PodCIDR:                      10.244.1.0/24
null_resource.run_ansible (local-exec): PodCIDRs:                     10.244.1.0/24
null_resource.run_ansible (local-exec): Non-terminated Pods:          (3 in total)
null_resource.run_ansible (local-exec):   Namespace                   Name                     CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
null_resource.run_ansible (local-exec):   ---------                   ----                     ------------  ----------  ---------------  -------------  ---
null_resource.run_ansible (local-exec):   kube-flannel                kube-flannel-ds-w7mm7    100m (5%)     0 (0%)      50Mi (0%)        0 (0%)         90s
null_resource.run_ansible (local-exec):   kube-system                 calico-node-dhnr7        250m (13%)    0 (0%)      0 (0%)           0 (0%)         90s
null_resource.run_ansible (local-exec):   kube-system                 kube-proxy-nkh9m         0 (0%)        0 (0%)      0 (0%)           0 (0%)         90s
null_resource.run_ansible (local-exec): Allocated resources:
null_resource.run_ansible (local-exec):   (Total limits may be over 100 percent, i.e., overcommitted.)
null_resource.run_ansible (local-exec):   Resource           Requests    Limits
null_resource.run_ansible (local-exec):   --------           --------    ------
null_resource.run_ansible (local-exec):   cpu                350m (19%)  0 (0%)
null_resource.run_ansible (local-exec):   memory             50Mi (0%)   0 (0%)
null_resource.run_ansible (local-exec):   ephemeral-storage  0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-1Gi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-2Mi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec): Events:
null_resource.run_ansible (local-exec):   Type    Reason                   Age                From             Message
null_resource.run_ansible (local-exec):   ----    ------                   ----               ----             -------
null_resource.run_ansible (local-exec):   Normal  Starting                 67s                kube-proxy
null_resource.run_ansible (local-exec):   Normal  Starting                 90s                kubelet          Starting kubelet.
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientMemory  90s (x2 over 90s)  kubelet          Node fhms3ck7p68bont19jk5 status is now: NodeHasSufficientMemory
null_resource.run_ansible (local-exec):   Normal  NodeHasNoDiskPressure    90s (x2 over 90s)  kubelet          Node fhms3ck7p68bont19jk5 status is now: NodeHasNoDiskPressure
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientPID     90s (x2 over 90s)  kubelet          Node fhms3ck7p68bont19jk5 status is now: NodeHasSufficientPID
null_resource.run_ansible (local-exec):   Normal  NodeAllocatableEnforced  90s                kubelet          Updated Node Allocatable limit across pods
null_resource.run_ansible (local-exec):   Normal  RegisteredNode           88s                node-controller  Node fhms3ck7p68bont19jk5 event: Registered Node fhms3ck7p68bont19jk5 in Controller
null_resource.run_ansible (local-exec):   Normal  NodeReady                67s                kubelet          Node fhms3ck7p68bont19jk5 status is now: NodeReady


null_resource.run_ansible (local-exec): Name:               fhmt1bh2p955d0f1f72a
null_resource.run_ansible (local-exec): Roles:              <none>
null_resource.run_ansible (local-exec): Labels:             beta.kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     beta.kubernetes.io/os=linux
null_resource.run_ansible (local-exec):                     kubernetes.io/arch=amd64
null_resource.run_ansible (local-exec):                     kubernetes.io/hostname=fhmt1bh2p955d0f1f72a
null_resource.run_ansible (local-exec):                     kubernetes.io/os=linux
null_resource.run_ansible (local-exec): Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"3e:34:ec:28:99:de"}
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/backend-type: vxlan
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/kube-subnet-manager: true
null_resource.run_ansible (local-exec):                     flannel.alpha.coreos.com/public-ip: 192.168.99.24
null_resource.run_ansible (local-exec):                     kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/containerd/containerd.sock
null_resource.run_ansible (local-exec):                     node.alpha.kubernetes.io/ttl: 0
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4Address: 192.168.99.24/24
null_resource.run_ansible (local-exec):                     projectcalico.org/IPv4IPIPTunnelAddr: 10.244.115.192
null_resource.run_ansible (local-exec):                     volumes.kubernetes.io/controller-managed-attach-detach: true
null_resource.run_ansible (local-exec): CreationTimestamp:  Tue, 18 Jun 2024 19:05:22 +0000
null_resource.run_ansible (local-exec): Taints:             <none>
null_resource.run_ansible (local-exec): Unschedulable:      false
null_resource.run_ansible (local-exec): Lease:
null_resource.run_ansible (local-exec):   HolderIdentity:  fhmt1bh2p955d0f1f72a
null_resource.run_ansible (local-exec):   AcquireTime:     <unset>
null_resource.run_ansible (local-exec):   RenewTime:       Tue, 18 Jun 2024 19:06:45 +0000
null_resource.run_ansible (local-exec): Conditions:
null_resource.run_ansible (local-exec):   Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
null_resource.run_ansible (local-exec):   ----                 ------  -----------------                 ------------------                ------                       -------
null_resource.run_ansible (local-exec):   NetworkUnavailable   False   Tue, 18 Jun 2024 19:06:07 +0000   Tue, 18 Jun 2024 19:06:07 +0000   FlannelIsUp                  Flannel is running on this node
null_resource.run_ansible (local-exec):   MemoryPressure       False   Tue, 18 Jun 2024 19:06:24 +0000   Tue, 18 Jun 2024 19:05:22 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
null_resource.run_ansible (local-exec):   DiskPressure         False   Tue, 18 Jun 2024 19:06:24 +0000   Tue, 18 Jun 2024 19:05:22 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
null_resource.run_ansible (local-exec):   PIDPressure          False   Tue, 18 Jun 2024 19:06:24 +0000   Tue, 18 Jun 2024 19:05:22 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
null_resource.run_ansible (local-exec):   Ready                True    Tue, 18 Jun 2024 19:06:24 +0000   Tue, 18 Jun 2024 19:05:48 +0000   KubeletReady                 kubelet is posting ready status. AppArmor enabled
null_resource.run_ansible (local-exec): Addresses:
null_resource.run_ansible (local-exec):   InternalIP:  192.168.99.24
null_resource.run_ansible (local-exec):   Hostname:    fhmt1bh2p955d0f1f72a
null_resource.run_ansible (local-exec): Capacity:
null_resource.run_ansible (local-exec):   cpu:                2
null_resource.run_ansible (local-exec):   ephemeral-storage:  41186748Ki
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             8136612Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): Allocatable:
null_resource.run_ansible (local-exec):   cpu:                1800m
null_resource.run_ansible (local-exec):   ephemeral-storage:  37957706894
null_resource.run_ansible (local-exec):   hugepages-1Gi:      0
null_resource.run_ansible (local-exec):   hugepages-2Mi:      0
null_resource.run_ansible (local-exec):   memory:             7643587Ki
null_resource.run_ansible (local-exec):   pods:               110
null_resource.run_ansible (local-exec): System Info:
null_resource.run_ansible (local-exec):   Machine ID:                 23000007c6dd0ae22ca4a5681e179c4a
null_resource.run_ansible (local-exec):   System UUID:                23000007-c6dd-0ae2-2ca4-a5681e179c4a
null_resource.run_ansible (local-exec):   Boot ID:                    db8162d5-3f15-4f97-b3a2-0d8eecfadf1d
null_resource.run_ansible (local-exec):   Kernel Version:             5.4.0-186-generic
null_resource.run_ansible (local-exec):   OS Image:                   Ubuntu 20.04.6 LTS
null_resource.run_ansible (local-exec):   Operating System:           linux
null_resource.run_ansible (local-exec):   Architecture:               amd64
null_resource.run_ansible (local-exec):   Container Runtime Version:  containerd://1.6.33
null_resource.run_ansible (local-exec):   Kubelet Version:            v1.29.6
null_resource.run_ansible (local-exec):   Kube-Proxy Version:         v1.29.6
null_resource.run_ansible (local-exec): PodCIDR:                      10.244.2.0/24
null_resource.run_ansible (local-exec): PodCIDRs:                     10.244.2.0/24
null_resource.run_ansible (local-exec): Non-terminated Pods:          (3 in total)
null_resource.run_ansible (local-exec):   Namespace                   Name                     CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
null_resource.run_ansible (local-exec):   ---------                   ----                     ------------  ----------  ---------------  -------------  ---
null_resource.run_ansible (local-exec):   kube-flannel                kube-flannel-ds-l6x76    100m (5%)     0 (0%)      50Mi (0%)        0 (0%)         88s
null_resource.run_ansible (local-exec):   kube-system                 calico-node-gmcwt        250m (13%)    0 (0%)      0 (0%)           0 (0%)         88s
null_resource.run_ansible (local-exec):   kube-system                 kube-proxy-rjgd2         0 (0%)        0 (0%)      0 (0%)           0 (0%)         88s
null_resource.run_ansible (local-exec): Allocated resources:
null_resource.run_ansible (local-exec):   (Total limits may be over 100 percent, i.e., overcommitted.)
null_resource.run_ansible (local-exec):   Resource           Requests    Limits
null_resource.run_ansible (local-exec):   --------           --------    ------
null_resource.run_ansible (local-exec):   cpu                350m (19%)  0 (0%)
null_resource.run_ansible (local-exec):   memory             50Mi (0%)   0 (0%)
null_resource.run_ansible (local-exec):   ephemeral-storage  0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-1Gi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec):   hugepages-2Mi      0 (0%)      0 (0%)
null_resource.run_ansible (local-exec): Events:
null_resource.run_ansible (local-exec):   Type    Reason                   Age                From             Message
null_resource.run_ansible (local-exec):   ----    ------                   ----               ----             -------
null_resource.run_ansible (local-exec):   Normal  Starting                 79s                kube-proxy
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientMemory  89s (x2 over 89s)  kubelet          Node fhmt1bh2p955d0f1f72a status is now: NodeHasSufficientMemory
null_resource.run_ansible (local-exec):   Normal  NodeHasNoDiskPressure    89s (x2 over 89s)  kubelet          Node fhmt1bh2p955d0f1f72a status is now: NodeHasNoDiskPressure
null_resource.run_ansible (local-exec):   Normal  NodeHasSufficientPID     89s (x2 over 89s)  kubelet          Node fhmt1bh2p955d0f1f72a status is now: NodeHasSufficientPID
null_resource.run_ansible (local-exec):   Normal  RegisteredNode           88s                node-controller  Node fhmt1bh2p955d0f1f72a event: Registered Node fhmt1bh2p955d0f1f72a in Controller
null_resource.run_ansible (local-exec):   Normal  NodeAllocatableEnforced  88s                kubelet          Updated Node Allocatable limit across pods
null_resource.run_ansible (local-exec):   Normal  NodeReady                63s                kubelet          Node fhmt1bh2p955d0f1f72a status is now: NodeReady

null_resource.run_ansible (local-exec): TASK [Check if Python 3.9 interpreter exists] **********************************
null_resource.run_ansible: Still creating... [12m0s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Set ansible_python_interpreter if Python 3.9 exists] *********************
null_resource.run_ansible (local-exec): skipping: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Get Cluster information] *************************************************
null_resource.run_ansible (local-exec): skipping: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Do not invalidate cache before getting information] **********************
null_resource.run_ansible (local-exec): skipping: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [Fetching config of kube] *************************************************
null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): PLAY [Setup some on k8s] *******************************************************

null_resource.run_ansible (local-exec): TASK [Create test pod file] ****************************************************
null_resource.run_ansible: Still creating... [12m10s elapsed]
null_resource.run_ansible (local-exec): --- before
null_resource.run_ansible (local-exec): +++ after: /home/ubuntu/test.yaml
null_resource.run_ansible (local-exec): @@ -0,0 +1,40 @@
null_resource.run_ansible (local-exec): +---
null_resource.run_ansible (local-exec): +apiVersion: apps/v1
null_resource.run_ansible (local-exec): +kind: Deployment
null_resource.run_ansible (local-exec): +metadata:
null_resource.run_ansible (local-exec): +  name: test
null_resource.run_ansible (local-exec): +  labels:
null_resource.run_ansible (local-exec): +    component: homework
null_resource.run_ansible (local-exec): +    app: test
null_resource.run_ansible (local-exec): +  namespace: default
null_resource.run_ansible (local-exec): +spec:
null_resource.run_ansible (local-exec): +  replicas: 1
null_resource.run_ansible (local-exec): +  selector:
null_resource.run_ansible (local-exec): +    matchLabels:
null_resource.run_ansible (local-exec): +      app: test
null_resource.run_ansible (local-exec): +  template:
null_resource.run_ansible (local-exec): +    metadata:
null_resource.run_ansible (local-exec): +      labels:
null_resource.run_ansible (local-exec): +        app: test
null_resource.run_ansible (local-exec): +    spec:
null_resource.run_ansible (local-exec): +      containers:
null_resource.run_ansible (local-exec): +      - name: test
null_resource.run_ansible (local-exec): +        image: alpine:latest
null_resource.run_ansible (local-exec): +        imagePullPolicy: IfNotPresent
null_resource.run_ansible (local-exec): +        command:
null_resource.run_ansible (local-exec): +          - /bin/sh
null_resource.run_ansible (local-exec): +          - "-c"
null_resource.run_ansible (local-exec): +          - "sleep 60m"
null_resource.run_ansible (local-exec): +        lifecycle:
null_resource.run_ansible (local-exec): +          postStart:
null_resource.run_ansible (local-exec): +            exec:
null_resource.run_ansible (local-exec): +              command:
null_resource.run_ansible (local-exec): +                - "sh"
null_resource.run_ansible (local-exec): +                - "-c"
null_resource.run_ansible (local-exec): +                - "apk update"
null_resource.run_ansible (local-exec): +                - "apk add bash curl wget jq kubectl helm inetutils-telnet rsync ansible ansible-lint yamllint golangci-lint gitlint jq yq openssl"
null_resource.run_ansible (local-exec): +        resources:
null_resource.run_ansible (local-exec): +          limits:
null_resource.run_ansible (local-exec): +            memory: "256Mi"
null_resource.run_ansible (local-exec): +            cpu: "1000m"
null_resource.run_ansible (local-exec): +      restartPolicy: Always

null_resource.run_ansible (local-exec): changed: [k8s-master-0]

null_resource.run_ansible (local-exec): TASK [K8s setup] ***************************************************************
null_resource.run_ansible: Still creating... [12m20s elapsed]
null_resource.run_ansible (local-exec): ok: [k8s-master-0] => (item=kubectl apply -f "/home/ubuntu/test.yaml")

null_resource.run_ansible (local-exec): MSG:

null_resource.run_ansible (local-exec): deployment.apps/test created

null_resource.run_ansible (local-exec): PLAY RECAP *********************************************************************
null_resource.run_ansible (local-exec): k8s-master-0               : ok=67   changed=33   unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
null_resource.run_ansible (local-exec): k8s-worker-0               : ok=42   changed=23   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
null_resource.run_ansible (local-exec): k8s-worker-1               : ok=42   changed=23   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
null_resource.run_ansible (local-exec): k8s-worker-2               : ok=42   changed=23   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

null_resource.run_ansible: Creation complete after 12m23s [id=5879954196713983174]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_image_id = "fd82veuo7o3pn0sk7jhv"
kubernetes_master_instance = [
  [
    "fhmp3j4sp3aki3njfd23",
  ],
  [
    "k8s-master-0",
  ],
]
kubernetes_master_ip_address = "178.154.202.246"
kubernetes_worker_instance = [
  [
    "fhms3ck7p68bont19jk5",
    "fhmt1bh2p955d0f1f72a",
    "fhm5tub66ct0p545llq7",
  ],
  [
    "k8s-worker-0",
    "k8s-worker-1",
    "k8s-worker-2",
  ],
]
kubernetes_worker_ip_address = "158.160.47.203"

```

### Обновление kubernetes

```bash
$ ansible-playbook -v -T 300 -i environments/stage/inventory.json playbooks/k8s_upgrade.yml 
Using kubernetes-prod/ansible/ansible.cfg as config file

PLAY [Upgrade K8s] *************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host k8s-master-0 is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [k8s-master-0]

TASK [Add Kubernetes APT key] **************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "before": [
        "234654DA9A296436"
    ],
    "changed": false,
    "fp": "234654DA9A296436",
    "id": "234654DA9A296436",
    "key_id": "234654DA9A296436",
    "short_id": "9A296436"
}

TASK [Add Kubernetes APT repository] *******************************************************************************************************************************************************************************************************
changed: [k8s-master-0] => {
    "changed": true,
    "repo": "deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /",
    "sources_added": [],
    "sources_removed": [],
    "state": "present"
}

TASK [Verify the upgrade plan] *************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": "kubeadm upgrade plan",
    "delta": "0:00:06.439146",
    "end": "2024-06-18 19:08:20.751897",
    "rc": 0,
    "start": "2024-06-18 19:08:14.312751"
}

STDOUT:

[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.29.6
[upgrade/versions] kubeadm version: v1.29.6
[upgrade/versions] Target version: v1.29.6
[upgrade/versions] Latest version in the v1.29 series: v1.29.6


STDERR:

I0618 19:08:19.876716    7521 version.go:256] remote version is much newer: v1.30.2; falling back to: stable-1.29

TASK [Unhold kubernetes packages] **********************************************************************************************************************************************************************************************************
changed: [k8s-master-0] => (item=kubelet) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-master-0] => (item=kubeadm) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-master-0] => (item=kubectl) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubectl"
}

TASK [Waiting the cancel] ******************************************************************************************************************************************************************************************************************
Pausing for 60 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [k8s-master-0] => {
    "changed": false,
    "delta": 60,
    "echo": true,
    "rc": 0,
    "start": "2024-06-18 22:08:01.926656",
    "stop": "2024-06-18 22:09:01.930493",
    "user_input": ""
}

STDOUT:

Paused for 1.0 minutes

TASK [Upgrading kubernetes] ****************************************************************************************************************************************************************************************************************
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
changed: [k8s-master-0] => {
    "cache_update_time": 1718737690,
    "cache_updated": false,
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Need to get 60.5 MB of archives.
After this operation, 5251 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  cri-tools 1.30.0-1.1 [21.3 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubeadm 1.30.2-1.1 [10.4 MB]
Get:3 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubectl 1.30.2-1.1 [10.8 MB]
Get:4 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubelet 1.30.2-1.1 [18.1 MB]
Fetched 60.5 MB in 1s (59.9 MB/s)
(Reading database ... 106016 files and directories currently installed.)
Preparing to unpack .../cri-tools_1.30.0-1.1_amd64.deb ...
Unpacking cri-tools (1.30.0-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubeadm_1.30.2-1.1_amd64.deb ...
Unpacking kubeadm (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubectl_1.30.2-1.1_amd64.deb ...
Unpacking kubectl (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubelet_1.30.2-1.1_amd64.deb ...
Unpacking kubelet (1.30.2-1.1) over (1.29.6-1.1) ...
Setting up kubectl (1.30.2-1.1) ...
Setting up cri-tools (1.30.0-1.1) ...
Setting up kubelet (1.30.2-1.1) ...
Setting up kubeadm (1.30.2-1.1) ...


TASK [Prevent kubernetes from being upgraded] **********************************************************************************************************************************************************************************************
changed: [k8s-master-0] => (item=kubelet) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-master-0] => (item=kubeadm) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-master-0] => (item=kubectl) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubectl"
}

TASK [Get kubeadm version] *****************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": [
        "kubeadm",
        "version",
        "-o",
        "short"
    ],
    "delta": "0:00:00.037352",
    "end": "2024-06-18 19:10:11.296492",
    "rc": 0,
    "start": "2024-06-18 19:10:11.259140"
}

STDOUT:

v1.30.2

TASK [Upgrade] *****************************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": "kubeadm upgrade apply v1.30.2 --yes",
    "delta": "0:02:05.132933",
    "end": "2024-06-18 19:12:19.755345",
    "rc": 0,
    "start": "2024-06-18 19:10:14.622412"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.30.2"
[upgrade/versions] Cluster version: v1.29.6
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.30.2" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Current and new manifests of etcd are equal, skipping upgrade
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests1754525433"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-06-18-19-10-53/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-06-18-19-10-53/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-06-18-19-10-53/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config2562672687/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.30.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.


STDERR:

W0618 19:10:18.798792    9478 checks.go:844] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.9" as the CRI sandbox image.

TASK [Get kubernetes details] **************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmp3j4sp3aki3njfd23",
        "-o",
        "json"
    ],
    "delta": "0:00:00.092447",
    "end": "2024-06-18 19:12:24.341924",
    "failed_when_result": false,
    "rc": 0,
    "start": "2024-06-18 19:12:24.249477"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"02:6d:ae:93:9a:c8\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.17",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.17/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.42.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:03:29Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmp3j4sp3aki3njfd23",
            "kubernetes.io/os": "linux",
            "node-role.kubernetes.io/control-plane": "",
            "node.kubernetes.io/exclude-from-external-load-balancers": ""
        },
        "name": "fhmp3j4sp3aki3njfd23",
        "resourceVersion": "1683",
        "uid": "f41c2d40-52a2-4a89-b39d-33b69addb78b"
    },
    "spec": {
        "podCIDR": "10.244.0.0/24",
        "podCIDRs": [
            "10.244.0.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node-role.kubernetes.io/control-plane"
            }
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.17",
                "type": "InternalIP"
            },
            {
                "address": "fhmp3j4sp3aki3njfd23",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:04:59Z",
                "lastTransitionTime": "2024-06-18T19:04:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:04:20Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "registry.k8s.io/etcd@sha256:44a8e24dcbba3470ee1fee21d5e88d128c936e9b55d4bc51fbef8086f8ed123b",
                    "registry.k8s.io/etcd:3.5.12-0"
                ],
                "sizeBytes": 57236178
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:f4d993b3d73cc0d59558be584b5b40785b4a96874bc76873b69d1dd818485e70",
                    "registry.k8s.io/kube-apiserver:v1.29.6"
                ],
                "sizeBytes": 35232637
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:692fc3f88a60b3afc76492ad347306d34042000f56f230959e9367fd59c48b1e",
                    "registry.k8s.io/kube-controller-manager:v1.29.6"
                ],
                "sizeBytes": 33590639
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:340ab4a1d66a60630a7a298aa0b2576fcd82e51ecdddb751cf61e5d3846fde2d",
                    "registry.k8s.io/kube-apiserver:v1.30.2"
                ],
                "sizeBytes": 32768601
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:4c412bc1fc585ddeba10d34a02e7507ea787ec2c57256d4c18fd230377ab048e",
                    "registry.k8s.io/kube-controller-manager:v1.30.2"
                ],
                "sizeBytes": 31138657
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:0ed75a333704f5d315395c6ec04d7af7405715537069b65d40b43ec1c8e030bc",
                    "registry.k8s.io/kube-scheduler:v1.30.2"
                ],
                "sizeBytes": 19328121
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:b91a4e45debd0d5336d9f533aefdf47d4b39b24071feb459e521709b9e4ec24f",
                    "registry.k8s.io/kube-scheduler:v1.29.6"
                ],
                "sizeBytes": 18674713
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "e7ae9caf-abc7-4e28-8c96-faab7cc656c9",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6d91cc9cc8d5490ef37b443",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6d9-1cc9-cc8d-5490ef37b443"
        }
    }
}

TASK [Cordon node] *************************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "cordon",
        "fhmp3j4sp3aki3njfd23"
    ],
    "delta": "0:00:00.119465",
    "end": "2024-06-18 19:12:28.365567",
    "rc": 0,
    "start": "2024-06-18 19:12:28.246102"
}

STDOUT:

node/fhmp3j4sp3aki3njfd23 cordoned

TASK [Wait for node to cordon] *************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmp3j4sp3aki3njfd23",
        "-o",
        "json"
    ],
    "delta": "0:00:00.072545",
    "end": "2024-06-18 19:12:32.132557",
    "rc": 0,
    "start": "2024-06-18 19:12:32.060012"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"02:6d:ae:93:9a:c8\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.17",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.17/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.42.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:03:29Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmp3j4sp3aki3njfd23",
            "kubernetes.io/os": "linux",
            "node-role.kubernetes.io/control-plane": "",
            "node.kubernetes.io/exclude-from-external-load-balancers": ""
        },
        "name": "fhmp3j4sp3aki3njfd23",
        "resourceVersion": "1768",
        "uid": "f41c2d40-52a2-4a89-b39d-33b69addb78b"
    },
    "spec": {
        "podCIDR": "10.244.0.0/24",
        "podCIDRs": [
            "10.244.0.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node-role.kubernetes.io/control-plane"
            },
            {
                "effect": "NoSchedule",
                "key": "node.kubernetes.io/unschedulable",
                "timeAdded": "2024-06-18T19:12:28Z"
            }
        ],
        "unschedulable": true
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.17",
                "type": "InternalIP"
            },
            {
                "address": "fhmp3j4sp3aki3njfd23",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:04:59Z",
                "lastTransitionTime": "2024-06-18T19:04:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:11:39Z",
                "lastTransitionTime": "2024-06-18T19:04:20Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "registry.k8s.io/etcd@sha256:44a8e24dcbba3470ee1fee21d5e88d128c936e9b55d4bc51fbef8086f8ed123b",
                    "registry.k8s.io/etcd:3.5.12-0"
                ],
                "sizeBytes": 57236178
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:f4d993b3d73cc0d59558be584b5b40785b4a96874bc76873b69d1dd818485e70",
                    "registry.k8s.io/kube-apiserver:v1.29.6"
                ],
                "sizeBytes": 35232637
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:692fc3f88a60b3afc76492ad347306d34042000f56f230959e9367fd59c48b1e",
                    "registry.k8s.io/kube-controller-manager:v1.29.6"
                ],
                "sizeBytes": 33590639
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:340ab4a1d66a60630a7a298aa0b2576fcd82e51ecdddb751cf61e5d3846fde2d",
                    "registry.k8s.io/kube-apiserver:v1.30.2"
                ],
                "sizeBytes": 32768601
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:4c412bc1fc585ddeba10d34a02e7507ea787ec2c57256d4c18fd230377ab048e",
                    "registry.k8s.io/kube-controller-manager:v1.30.2"
                ],
                "sizeBytes": 31138657
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:0ed75a333704f5d315395c6ec04d7af7405715537069b65d40b43ec1c8e030bc",
                    "registry.k8s.io/kube-scheduler:v1.30.2"
                ],
                "sizeBytes": 19328121
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:b91a4e45debd0d5336d9f533aefdf47d4b39b24071feb459e521709b9e4ec24f",
                    "registry.k8s.io/kube-scheduler:v1.29.6"
                ],
                "sizeBytes": 18674713
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "e7ae9caf-abc7-4e28-8c96-faab7cc656c9",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6d91cc9cc8d5490ef37b443",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6d9-1cc9-cc8d-5490ef37b443"
        }
    }
}

TASK [Drain node] **************************************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "drain",
        "--force",
        "--ignore-daemonsets",
        "--grace-period",
        "300",
        "--timeout",
        "360s",
        "--delete-emptydir-data",
        "fhmp3j4sp3aki3njfd23"
    ],
    "delta": "0:00:06.210574",
    "end": "2024-06-18 19:12:41.428767",
    "rc": 0,
    "start": "2024-06-18 19:12:35.218193"
}

STDOUT:

node/fhmp3j4sp3aki3njfd23 already cordoned
evicting pod kube-system/coredns-76f75df574-qghdc
evicting pod kube-system/calico-kube-controllers-658d97c59c-cxhmp
evicting pod kube-system/coredns-76f75df574-9ns5v
pod/calico-kube-controllers-658d97c59c-cxhmp evicted
pod/coredns-76f75df574-9ns5v evicted
pod/coredns-76f75df574-qghdc evicted
node/fhmp3j4sp3aki3njfd23 drained


STDERR:

Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-v2vdt, kube-system/calico-node-9brpz, kube-system/kube-proxy-jkxmc

TASK [Update all packages] *****************************************************************************************************************************************************************************************************************
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
changed: [k8s-master-0] => {
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (43.4 MB/s)
(Reading database ... 106016 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...



MSG:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (43.4 MB/s)
(Reading database ... 106016 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...


TASK [Check if reboot is required] *********************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "changed": false,
    "stat": {
        "exists": false
    }
}

TASK [Reboot the server] *******************************************************************************************************************************************************************************************************************
skipping: [k8s-master-0] => {
    "changed": false,
    "false_condition": "reboot_required.stat.exists",
    "skip_reason": "Conditional result was False"
}

TASK [Restart kubelet service] *************************************************************************************************************************************************************************************************************
changed: [k8s-master-0] => {
    "attempts": 1,
    "changed": true,
    "enabled": true,
    "name": "kubelet",
    "state": "started",
    "status": {
        "ActiveEnterTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "ActiveEnterTimestampMonotonic": "161291371",
        "ActiveExitTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "ActiveExitTimestampMonotonic": "161227615",
        "ActiveState": "active",
        "After": "systemd-journald.socket basic.target system.slice network-online.target sysinit.target",
        "AllowIsolate": "no",
        "AllowedCPUs": "",
        "AllowedMemoryNodes": "",
        "AmbientCapabilities": "",
        "AssertResult": "yes",
        "AssertTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "AssertTimestampMonotonic": "161289551",
        "Before": "multi-user.target shutdown.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "[not set]",
        "CPUAccounting": "no",
        "CPUAffinity": "",
        "CPUAffinityFromNUMA": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUQuotaPeriodUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "[not set]",
        "CPUUsageNSec": "[not set]",
        "CPUWeight": "[not set]",
        "CacheDirectoryMode": "0755",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "cap_chown cap_dac_override cap_dac_read_search cap_fowner cap_fsetid cap_kill cap_setgid cap_setuid cap_setpcap cap_linux_immutable cap_net_bind_service cap_net_broadcast cap_net_admin cap_net_raw cap_ipc_lock cap_ipc_owner cap_sys_module cap_sys_rawio cap_sys_chroot cap_sys_ptrace cap_sys_pacct cap_sys_admin cap_sys_boot cap_sys_nice cap_sys_resource cap_sys_time cap_sys_tty_config cap_mknod cap_lease cap_audit_write cap_audit_control cap_setfcap cap_mac_override cap_mac_admin cap_syslog cap_wake_alarm cap_block_suspend cap_audit_read",
        "CleanResult": "success",
        "CollectMode": "inactive",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "ConditionTimestampMonotonic": "161289550",
        "ConfigurationDirectoryMode": "0755",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/kubelet.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "DefaultMemoryLow": "0",
        "DefaultMemoryMin": "0",
        "Delegate": "no",
        "Description": "kubelet: The Kubernetes Node Agent",
        "DevicePolicy": "auto",
        "Documentation": "https://kubernetes.io/docs/",
        "DropInPaths": "/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf",
        "DynamicUser": "no",
        "EffectiveCPUs": "",
        "EffectiveMemoryNodes": "",
        "Environment": "[unprintable] KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml",
        "EnvironmentFiles": "/etc/default/kubelet (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "1908",
        "ExecMainStartTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "ExecMainStartTimestampMonotonic": "161291008",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStartEx": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; flags= ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FinalKillSignal": "9",
        "FragmentPath": "/lib/systemd/system/kubelet.service",
        "GID": "[not set]",
        "GuessMainPID": "yes",
        "IOAccounting": "no",
        "IOReadBytes": "18446744073709551615",
        "IOReadOperations": "18446744073709551615",
        "IOSchedulingClass": "0",
        "IOSchedulingPriority": "0",
        "IOWeight": "[not set]",
        "IOWriteBytes": "18446744073709551615",
        "IOWriteOperations": "18446744073709551615",
        "IPAccounting": "no",
        "IPEgressBytes": "[no data]",
        "IPEgressPackets": "[no data]",
        "IPIngressBytes": "[no data]",
        "IPIngressPackets": "[no data]",
        "Id": "kubelet.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "InactiveEnterTimestampMonotonic": "161288610",
        "InactiveExitTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "InactiveExitTimestampMonotonic": "161291371",
        "InvocationID": "7e70d527b5284e158e4be0ad957e46b5",
        "JobRunningTimeoutUSec": "infinity",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KeyringMode": "private",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "infinity",
        "LimitASSoft": "infinity",
        "LimitCORE": "infinity",
        "LimitCORESoft": "0",
        "LimitCPU": "infinity",
        "LimitCPUSoft": "infinity",
        "LimitDATA": "infinity",
        "LimitDATASoft": "infinity",
        "LimitFSIZE": "infinity",
        "LimitFSIZESoft": "infinity",
        "LimitLOCKS": "infinity",
        "LimitLOCKSSoft": "infinity",
        "LimitMEMLOCK": "65536",
        "LimitMEMLOCKSoft": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "524288",
        "LimitNOFILESoft": "1024",
        "LimitNPROC": "31539",
        "LimitNPROCSoft": "31539",
        "LimitRSS": "infinity",
        "LimitRSSSoft": "infinity",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "infinity",
        "LimitRTTIMESoft": "infinity",
        "LimitSIGPENDING": "31539",
        "LimitSIGPENDINGSoft": "31539",
        "LimitSTACK": "infinity",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "LockPersonality": "no",
        "LogLevelMax": "-1",
        "LogRateLimitBurst": "0",
        "LogRateLimitIntervalUSec": "0",
        "LogsDirectoryMode": "0755",
        "MainPID": "1908",
        "MemoryAccounting": "yes",
        "MemoryCurrent": "42213376",
        "MemoryDenyWriteExecute": "no",
        "MemoryHigh": "infinity",
        "MemoryLimit": "infinity",
        "MemoryLow": "0",
        "MemoryMax": "infinity",
        "MemoryMin": "0",
        "MemorySwapMax": "infinity",
        "MountAPIVFS": "no",
        "MountFlags": "",
        "NFileDescriptorStore": "0",
        "NRestarts": "0",
        "NUMAMask": "",
        "NUMAPolicy": "n/a",
        "Names": "kubelet.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMPolicy": "stop",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "Perpetual": "no",
        "PrivateDevices": "no",
        "PrivateMounts": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "PrivateUsers": "no",
        "ProtectControlGroups": "no",
        "ProtectHome": "no",
        "ProtectHostname": "no",
        "ProtectKernelLogs": "no",
        "ProtectKernelModules": "no",
        "ProtectKernelTunables": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "ReloadResult": "success",
        "RemainAfterExit": "no",
        "RemoveIPC": "no",
        "Requires": "system.slice sysinit.target",
        "Restart": "always",
        "RestartKillSignal": "15",
        "RestartUSec": "10s",
        "RestrictNamespaces": "no",
        "RestrictRealtime": "no",
        "RestrictSUIDSGID": "no",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeDirectoryPreserve": "no",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardInputData": "",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitIntervalUSec": "0",
        "StartupBlockIOWeight": "[not set]",
        "StartupCPUShares": "[not set]",
        "StartupCPUWeight": "[not set]",
        "StartupIOWeight": "[not set]",
        "StateChangeTimestamp": "Tue 2024-06-18 19:03:36 UTC",
        "StateChangeTimestampMonotonic": "161291371",
        "StateDirectoryMode": "0755",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SuccessAction": "none",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "yes",
        "TasksCurrent": "12",
        "TasksMax": "9461",
        "TimeoutAbortUSec": "1min 30s",
        "TimeoutCleanUSec": "infinity",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UID": "[not set]",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "Wants": "network-online.target",
        "WatchdogSignal": "6",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "0"
    }
}

TASK [Uncordon node] ***********************************************************************************************************************************************************************************************************************
FAILED - RETRYING: [k8s-master-0]: Uncordon node (3 retries left).
ok: [k8s-master-0] => {
    "attempts": 2,
    "changed": false,
    "cmd": [
        "kubectl",
        "uncordon",
        "fhmp3j4sp3aki3njfd23"
    ],
    "delta": "0:00:00.104942",
    "end": "2024-06-18 19:13:19.650970",
    "rc": 0,
    "start": "2024-06-18 19:13:19.546028"
}

STDOUT:

node/fhmp3j4sp3aki3njfd23 uncordoned

TASK [Wait for node to uncordon] ***********************************************************************************************************************************************************************************************************
ok: [k8s-master-0] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmp3j4sp3aki3njfd23",
        "-o",
        "json"
    ],
    "delta": "0:00:00.115057",
    "end": "2024-06-18 19:13:23.672031",
    "rc": 0,
    "start": "2024-06-18 19:13:23.556974"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"02:6d:ae:93:9a:c8\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.17",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.17/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.42.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:03:29Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmp3j4sp3aki3njfd23",
            "kubernetes.io/os": "linux",
            "node-role.kubernetes.io/control-plane": "",
            "node.kubernetes.io/exclude-from-external-load-balancers": ""
        },
        "name": "fhmp3j4sp3aki3njfd23",
        "resourceVersion": "2074",
        "uid": "f41c2d40-52a2-4a89-b39d-33b69addb78b"
    },
    "spec": {
        "podCIDR": "10.244.0.0/24",
        "podCIDRs": [
            "10.244.0.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node-role.kubernetes.io/control-plane"
            },
            {
                "effect": "NoSchedule",
                "key": "node.kubernetes.io/unschedulable",
                "timeAdded": "2024-06-18T19:12:28Z"
            }
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.17",
                "type": "InternalIP"
            },
            {
                "address": "fhmp3j4sp3aki3njfd23",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:04:59Z",
                "lastTransitionTime": "2024-06-18T19:04:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:13:02Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:13:02Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:13:02Z",
                "lastTransitionTime": "2024-06-18T19:03:27Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:13:02Z",
                "lastTransitionTime": "2024-06-18T19:13:02Z",
                "message": "kubelet is posting ready status",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "registry.k8s.io/etcd@sha256:44a8e24dcbba3470ee1fee21d5e88d128c936e9b55d4bc51fbef8086f8ed123b",
                    "registry.k8s.io/etcd:3.5.12-0"
                ],
                "sizeBytes": 57236178
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:f4d993b3d73cc0d59558be584b5b40785b4a96874bc76873b69d1dd818485e70",
                    "registry.k8s.io/kube-apiserver:v1.29.6"
                ],
                "sizeBytes": 35232637
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:692fc3f88a60b3afc76492ad347306d34042000f56f230959e9367fd59c48b1e",
                    "registry.k8s.io/kube-controller-manager:v1.29.6"
                ],
                "sizeBytes": 33590639
            },
            {
                "names": [
                    "registry.k8s.io/kube-apiserver@sha256:340ab4a1d66a60630a7a298aa0b2576fcd82e51ecdddb751cf61e5d3846fde2d",
                    "registry.k8s.io/kube-apiserver:v1.30.2"
                ],
                "sizeBytes": 32768601
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-controller-manager@sha256:4c412bc1fc585ddeba10d34a02e7507ea787ec2c57256d4c18fd230377ab048e",
                    "registry.k8s.io/kube-controller-manager:v1.30.2"
                ],
                "sizeBytes": 31138657
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:0ed75a333704f5d315395c6ec04d7af7405715537069b65d40b43ec1c8e030bc",
                    "registry.k8s.io/kube-scheduler:v1.30.2"
                ],
                "sizeBytes": 19328121
            },
            {
                "names": [
                    "registry.k8s.io/kube-scheduler@sha256:b91a4e45debd0d5336d9f533aefdf47d4b39b24071feb459e521709b9e4ec24f",
                    "registry.k8s.io/kube-scheduler:v1.29.6"
                ],
                "sizeBytes": 18674713
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "e7ae9caf-abc7-4e28-8c96-faab7cc656c9",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.30.2",
            "kubeletVersion": "v1.30.2",
            "machineID": "23000007c6d91cc9cc8d5490ef37b443",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6d9-1cc9-cc8d-5490ef37b443"
        }
    }
}

PLAY [Upgrade K8s] *************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host k8s-worker-0 is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [k8s-worker-0]

TASK [Add Kubernetes APT key] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0] => {
    "before": [
        "234654DA9A296436"
    ],
    "changed": false,
    "fp": "234654DA9A296436",
    "id": "234654DA9A296436",
    "key_id": "234654DA9A296436",
    "short_id": "9A296436"
}

TASK [Add Kubernetes APT repository] *******************************************************************************************************************************************************************************************************
changed: [k8s-worker-0] => {
    "changed": true,
    "repo": "deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /",
    "sources_added": [],
    "sources_removed": [],
    "state": "present"
}

TASK [Verify the upgrade plan] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade plan",
    "delta": "0:00:07.027486",
    "end": "2024-06-18 19:14:02.209185",
    "rc": 0,
    "start": "2024-06-18 19:13:55.181699"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/versions] Target version: v1.30.2
[upgrade/versions] Latest version in the v1.30 series: v1.30.2

TASK [Unhold kubernetes packages] **********************************************************************************************************************************************************************************************************
changed: [k8s-worker-0] => (item=kubelet) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-0] => (item=kubeadm) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-0] => (item=kubectl) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubectl"
}

TASK [Waiting the cancel] ******************************************************************************************************************************************************************************************************************
Pausing for 60 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [k8s-worker-0] => {
    "changed": false,
    "delta": 60,
    "echo": true,
    "rc": 0,
    "start": "2024-06-18 22:13:40.573945",
    "stop": "2024-06-18 22:14:40.577796",
    "user_input": ""
}

STDOUT:

Paused for 1.0 minutes

TASK [Upgrading kubernetes] ****************************************************************************************************************************************************************************************************************
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
changed: [k8s-worker-0] => {
    "cache_update_time": 1718738030,
    "cache_updated": false,
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Need to get 60.5 MB of archives.
After this operation, 5251 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  cri-tools 1.30.0-1.1 [21.3 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubeadm 1.30.2-1.1 [10.4 MB]
Get:3 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubectl 1.30.2-1.1 [10.8 MB]
Get:4 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubelet 1.30.2-1.1 [18.1 MB]
Fetched 60.5 MB in 1s (57.1 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../cri-tools_1.30.0-1.1_amd64.deb ...
Unpacking cri-tools (1.30.0-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubeadm_1.30.2-1.1_amd64.deb ...
Unpacking kubeadm (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubectl_1.30.2-1.1_amd64.deb ...
Unpacking kubectl (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubelet_1.30.2-1.1_amd64.deb ...
Unpacking kubelet (1.30.2-1.1) over (1.29.6-1.1) ...
Setting up kubectl (1.30.2-1.1) ...
Setting up cri-tools (1.30.0-1.1) ...
Setting up kubelet (1.30.2-1.1) ...
Setting up kubeadm (1.30.2-1.1) ...


TASK [Prevent kubernetes from being upgraded] **********************************************************************************************************************************************************************************************
changed: [k8s-worker-0] => (item=kubelet) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-0] => (item=kubeadm) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-0] => (item=kubectl) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubectl"
}

TASK [Get kubeadm version] *****************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0] => {
    "changed": false,
    "cmd": [
        "kubeadm",
        "version",
        "-o",
        "short"
    ],
    "delta": "0:00:00.033226",
    "end": "2024-06-18 19:15:54.313298",
    "rc": 0,
    "start": "2024-06-18 19:15:54.280072"
}

STDOUT:

v1.30.2

TASK [Upgrade] *****************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade apply v1.30.2 --yes",
    "delta": "0:00:10.449878",
    "end": "2024-06-18 19:16:12.541157",
    "rc": 0,
    "start": "2024-06-18 19:16:02.091279"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.30.2"
[upgrade/versions] Cluster version: v1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.30.2" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Current and new manifests of etcd are equal, skipping upgrade
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests2937220498"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Current and new manifests of kube-apiserver are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Current and new manifests of kube-controller-manager are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Current and new manifests of kube-scheduler are equal, skipping upgrade
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config488342253/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.30.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.


STDERR:

W0618 19:16:07.296038   16452 checks.go:844] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.9" as the CRI sandbox image.

TASK [Get kubernetes details] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhms3ck7p68bont19jk5",
        "-o",
        "json"
    ],
    "delta": "0:00:00.091170",
    "end": "2024-06-18 19:16:16.116581",
    "failed_when_result": false,
    "rc": 0,
    "start": "2024-06-18 19:16:16.025411"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"b6:6a:2c:74:84:62\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.32",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.32/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.152.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:21Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhms3ck7p68bont19jk5",
            "kubernetes.io/os": "linux"
        },
        "name": "fhms3ck7p68bont19jk5",
        "resourceVersion": "2214",
        "uid": "c530edba-413c-478d-ae1d-6ef6926e655d"
    },
    "spec": {
        "podCIDR": "10.244.1.0/24",
        "podCIDRs": [
            "10.244.1.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.32",
                "type": "InternalIP"
            },
            {
                "address": "fhms3ck7p68bont19jk5",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:05:59Z",
                "lastTransitionTime": "2024-06-18T19:05:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:44Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "8d6c4901-df33-4d66-84ac-9822b450a214",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6dc1b287c990bc5fa14ce85",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dc-1b28-7c99-0bc5fa14ce85"
        }
    }
}

TASK [Cordon node] *************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "cordon",
        "fhms3ck7p68bont19jk5"
    ],
    "delta": "0:00:00.096973",
    "end": "2024-06-18 19:16:20.197545",
    "rc": 0,
    "start": "2024-06-18 19:16:20.100572"
}

STDOUT:

node/fhms3ck7p68bont19jk5 cordoned

TASK [Wait for node to cordon] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhms3ck7p68bont19jk5",
        "-o",
        "json"
    ],
    "delta": "0:00:00.078039",
    "end": "2024-06-18 19:16:24.191866",
    "rc": 0,
    "start": "2024-06-18 19:16:24.113827"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"b6:6a:2c:74:84:62\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.32",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.32/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.152.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:21Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhms3ck7p68bont19jk5",
            "kubernetes.io/os": "linux"
        },
        "name": "fhms3ck7p68bont19jk5",
        "resourceVersion": "2434",
        "uid": "c530edba-413c-478d-ae1d-6ef6926e655d"
    },
    "spec": {
        "podCIDR": "10.244.1.0/24",
        "podCIDRs": [
            "10.244.1.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node.kubernetes.io/unschedulable",
                "timeAdded": "2024-06-18T19:16:20Z"
            }
        ],
        "unschedulable": true
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.32",
                "type": "InternalIP"
            },
            {
                "address": "fhms3ck7p68bont19jk5",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:05:59Z",
                "lastTransitionTime": "2024-06-18T19:05:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:14:21Z",
                "lastTransitionTime": "2024-06-18T19:05:44Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "8d6c4901-df33-4d66-84ac-9822b450a214",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6dc1b287c990bc5fa14ce85",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dc-1b28-7c99-0bc5fa14ce85"
        }
    }
}

TASK [Drain node] **************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "drain",
        "--force",
        "--ignore-daemonsets",
        "--grace-period",
        "300",
        "--timeout",
        "360s",
        "--delete-emptydir-data",
        "fhms3ck7p68bont19jk5"
    ],
    "delta": "0:00:06.148928",
    "end": "2024-06-18 19:16:33.652153",
    "rc": 0,
    "start": "2024-06-18 19:16:27.503225"
}

STDOUT:

node/fhms3ck7p68bont19jk5 already cordoned
evicting pod kube-system/coredns-76f75df574-prtsl
pod/coredns-76f75df574-prtsl evicted
node/fhms3ck7p68bont19jk5 drained


STDERR:

Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-w7mm7, kube-system/calico-node-dhnr7, kube-system/kube-proxy-7qzqm

TASK [Update all packages] *****************************************************************************************************************************************************************************************************************
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
changed: [k8s-worker-0] => {
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (34.8 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...



MSG:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (34.8 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...


TASK [Check if reboot is required] *********************************************************************************************************************************************************************************************************
ok: [k8s-worker-0] => {
    "changed": false,
    "stat": {
        "exists": false
    }
}

TASK [Reboot the server] *******************************************************************************************************************************************************************************************************************
skipping: [k8s-worker-0] => {
    "changed": false,
    "false_condition": "reboot_required.stat.exists",
    "skip_reason": "Conditional result was False"
}

TASK [Restart kubelet service] *************************************************************************************************************************************************************************************************************
changed: [k8s-worker-0] => {
    "attempts": 1,
    "changed": true,
    "enabled": true,
    "name": "kubelet",
    "state": "started",
    "status": {
        "ActiveEnterTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "ActiveEnterTimestampMonotonic": "275372693",
        "ActiveExitTimestamp": "Tue 2024-06-18 19:05:16 UTC",
        "ActiveExitTimestampMonotonic": "271804136",
        "ActiveState": "active",
        "After": "systemd-journald.socket system.slice sysinit.target network-online.target basic.target",
        "AllowIsolate": "no",
        "AllowedCPUs": "",
        "AllowedMemoryNodes": "",
        "AmbientCapabilities": "",
        "AssertResult": "yes",
        "AssertTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "AssertTimestampMonotonic": "275371063",
        "Before": "multi-user.target shutdown.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "[not set]",
        "CPUAccounting": "no",
        "CPUAffinity": "",
        "CPUAffinityFromNUMA": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUQuotaPeriodUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "[not set]",
        "CPUUsageNSec": "[not set]",
        "CPUWeight": "[not set]",
        "CacheDirectoryMode": "0755",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "cap_chown cap_dac_override cap_dac_read_search cap_fowner cap_fsetid cap_kill cap_setgid cap_setuid cap_setpcap cap_linux_immutable cap_net_bind_service cap_net_broadcast cap_net_admin cap_net_raw cap_ipc_lock cap_ipc_owner cap_sys_module cap_sys_rawio cap_sys_chroot cap_sys_ptrace cap_sys_pacct cap_sys_admin cap_sys_boot cap_sys_nice cap_sys_resource cap_sys_time cap_sys_tty_config cap_mknod cap_lease cap_audit_write cap_audit_control cap_setfcap cap_mac_override cap_mac_admin cap_syslog cap_wake_alarm cap_block_suspend cap_audit_read",
        "CleanResult": "success",
        "CollectMode": "inactive",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "ConditionTimestampMonotonic": "275371063",
        "ConfigurationDirectoryMode": "0755",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/kubelet.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "DefaultMemoryLow": "0",
        "DefaultMemoryMin": "0",
        "Delegate": "no",
        "Description": "kubelet: The Kubernetes Node Agent",
        "DevicePolicy": "auto",
        "Documentation": "https://kubernetes.io/docs/",
        "DropInPaths": "/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf",
        "DynamicUser": "no",
        "EffectiveCPUs": "",
        "EffectiveMemoryNodes": "",
        "Environment": "[unprintable] KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml",
        "EnvironmentFiles": "/etc/default/kubelet (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "1623",
        "ExecMainStartTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "ExecMainStartTimestampMonotonic": "275372342",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStartEx": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; flags= ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FinalKillSignal": "9",
        "FragmentPath": "/lib/systemd/system/kubelet.service",
        "GID": "[not set]",
        "GuessMainPID": "yes",
        "IOAccounting": "no",
        "IOReadBytes": "18446744073709551615",
        "IOReadOperations": "18446744073709551615",
        "IOSchedulingClass": "0",
        "IOSchedulingPriority": "0",
        "IOWeight": "[not set]",
        "IOWriteBytes": "18446744073709551615",
        "IOWriteOperations": "18446744073709551615",
        "IPAccounting": "no",
        "IPEgressBytes": "[no data]",
        "IPEgressPackets": "[no data]",
        "IPIngressBytes": "[no data]",
        "IPIngressPackets": "[no data]",
        "Id": "kubelet.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestamp": "Tue 2024-06-18 19:05:19 UTC",
        "InactiveEnterTimestampMonotonic": "275163984",
        "InactiveExitTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "InactiveExitTimestampMonotonic": "275372693",
        "InvocationID": "28fd603a7aa34d72a8914dfc976af46e",
        "JobRunningTimeoutUSec": "infinity",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KeyringMode": "private",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "infinity",
        "LimitASSoft": "infinity",
        "LimitCORE": "infinity",
        "LimitCORESoft": "0",
        "LimitCPU": "infinity",
        "LimitCPUSoft": "infinity",
        "LimitDATA": "infinity",
        "LimitDATASoft": "infinity",
        "LimitFSIZE": "infinity",
        "LimitFSIZESoft": "infinity",
        "LimitLOCKS": "infinity",
        "LimitLOCKSSoft": "infinity",
        "LimitMEMLOCK": "65536",
        "LimitMEMLOCKSoft": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "524288",
        "LimitNOFILESoft": "1024",
        "LimitNPROC": "31539",
        "LimitNPROCSoft": "31539",
        "LimitRSS": "infinity",
        "LimitRSSSoft": "infinity",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "infinity",
        "LimitRTTIMESoft": "infinity",
        "LimitSIGPENDING": "31539",
        "LimitSIGPENDINGSoft": "31539",
        "LimitSTACK": "infinity",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "LockPersonality": "no",
        "LogLevelMax": "-1",
        "LogRateLimitBurst": "0",
        "LogRateLimitIntervalUSec": "0",
        "LogsDirectoryMode": "0755",
        "MainPID": "1623",
        "MemoryAccounting": "yes",
        "MemoryCurrent": "45174784",
        "MemoryDenyWriteExecute": "no",
        "MemoryHigh": "infinity",
        "MemoryLimit": "infinity",
        "MemoryLow": "0",
        "MemoryMax": "infinity",
        "MemoryMin": "0",
        "MemorySwapMax": "infinity",
        "MountAPIVFS": "no",
        "MountFlags": "",
        "NFileDescriptorStore": "0",
        "NRestarts": "25",
        "NUMAMask": "",
        "NUMAPolicy": "n/a",
        "Names": "kubelet.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMPolicy": "stop",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "Perpetual": "no",
        "PrivateDevices": "no",
        "PrivateMounts": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "PrivateUsers": "no",
        "ProtectControlGroups": "no",
        "ProtectHome": "no",
        "ProtectHostname": "no",
        "ProtectKernelLogs": "no",
        "ProtectKernelModules": "no",
        "ProtectKernelTunables": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "ReloadResult": "success",
        "RemainAfterExit": "no",
        "RemoveIPC": "no",
        "Requires": "system.slice sysinit.target",
        "Restart": "always",
        "RestartKillSignal": "15",
        "RestartUSec": "10s",
        "RestrictNamespaces": "no",
        "RestrictRealtime": "no",
        "RestrictSUIDSGID": "no",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeDirectoryPreserve": "no",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardInputData": "",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitIntervalUSec": "0",
        "StartupBlockIOWeight": "[not set]",
        "StartupCPUShares": "[not set]",
        "StartupCPUWeight": "[not set]",
        "StartupIOWeight": "[not set]",
        "StateChangeTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "StateChangeTimestampMonotonic": "275372693",
        "StateDirectoryMode": "0755",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SuccessAction": "none",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "yes",
        "TasksCurrent": "11",
        "TasksMax": "9461",
        "TimeoutAbortUSec": "1min 30s",
        "TimeoutCleanUSec": "infinity",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UID": "[not set]",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "Wants": "network-online.target",
        "WatchdogSignal": "6",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "0"
    }
}

TASK [Uncordon node] ***********************************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "uncordon",
        "fhms3ck7p68bont19jk5"
    ],
    "delta": "0:00:00.095566",
    "end": "2024-06-18 19:16:57.966205",
    "rc": 0,
    "start": "2024-06-18 19:16:57.870639"
}

STDOUT:

node/fhms3ck7p68bont19jk5 uncordoned

TASK [Wait for node to uncordon] ***********************************************************************************************************************************************************************************************************
ok: [k8s-worker-0 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhms3ck7p68bont19jk5",
        "-o",
        "json"
    ],
    "delta": "0:00:00.074424",
    "end": "2024-06-18 19:17:01.623188",
    "rc": 0,
    "start": "2024-06-18 19:17:01.548764"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"b6:6a:2c:74:84:62\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.32",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.32/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.152.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:21Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhms3ck7p68bont19jk5",
            "kubernetes.io/os": "linux"
        },
        "name": "fhms3ck7p68bont19jk5",
        "resourceVersion": "2549",
        "uid": "c530edba-413c-478d-ae1d-6ef6926e655d"
    },
    "spec": {
        "podCIDR": "10.244.1.0/24",
        "podCIDRs": [
            "10.244.1.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.32",
                "type": "InternalIP"
            },
            {
                "address": "fhms3ck7p68bont19jk5",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:05:59Z",
                "lastTransitionTime": "2024-06-18T19:05:59Z",
                "message": "Calico is running on this node",
                "reason": "CalicoIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:16:53Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:16:53Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:16:53Z",
                "lastTransitionTime": "2024-06-18T19:05:21Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:16:53Z",
                "lastTransitionTime": "2024-06-18T19:05:44Z",
                "message": "kubelet is posting ready status",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "8d6c4901-df33-4d66-84ac-9822b450a214",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.30.2",
            "kubeletVersion": "v1.30.2",
            "machineID": "23000007c6dc1b287c990bc5fa14ce85",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dc-1b28-7c99-0bc5fa14ce85"
        }
    }
}

PLAY [Upgrade K8s] *************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host k8s-worker-1 is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [k8s-worker-1]

TASK [Add Kubernetes APT key] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1] => {
    "before": [
        "234654DA9A296436"
    ],
    "changed": false,
    "fp": "234654DA9A296436",
    "id": "234654DA9A296436",
    "key_id": "234654DA9A296436",
    "short_id": "9A296436"
}

TASK [Add Kubernetes APT repository] *******************************************************************************************************************************************************************************************************
changed: [k8s-worker-1] => {
    "changed": true,
    "repo": "deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /",
    "sources_added": [],
    "sources_removed": [],
    "state": "present"
}

TASK [Verify the upgrade plan] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade plan",
    "delta": "0:00:06.028965",
    "end": "2024-06-18 19:17:37.720589",
    "rc": 0,
    "start": "2024-06-18 19:17:31.691624"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/versions] Target version: v1.30.2
[upgrade/versions] Latest version in the v1.30 series: v1.30.2

TASK [Unhold kubernetes packages] **********************************************************************************************************************************************************************************************************
changed: [k8s-worker-1] => (item=kubelet) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-1] => (item=kubeadm) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-1] => (item=kubectl) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubectl"
}

TASK [Waiting the cancel] ******************************************************************************************************************************************************************************************************************
Pausing for 60 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [k8s-worker-1] => {
    "changed": false,
    "delta": 60,
    "echo": true,
    "rc": 0,
    "start": "2024-06-18 22:17:16.704940",
    "stop": "2024-06-18 22:18:16.708884",
    "user_input": ""
}

STDOUT:

Paused for 1.0 minutes

TASK [Upgrading kubernetes] ****************************************************************************************************************************************************************************************************************
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
changed: [k8s-worker-1] => {
    "cache_update_time": 1718738247,
    "cache_updated": false,
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Need to get 60.5 MB of archives.
After this operation, 5251 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  cri-tools 1.30.0-1.1 [21.3 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubeadm 1.30.2-1.1 [10.4 MB]
Get:3 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubectl 1.30.2-1.1 [10.8 MB]
Get:4 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubelet 1.30.2-1.1 [18.1 MB]
Fetched 60.5 MB in 1s (59.1 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../cri-tools_1.30.0-1.1_amd64.deb ...
Unpacking cri-tools (1.30.0-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubeadm_1.30.2-1.1_amd64.deb ...
Unpacking kubeadm (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubectl_1.30.2-1.1_amd64.deb ...
Unpacking kubectl (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubelet_1.30.2-1.1_amd64.deb ...
Unpacking kubelet (1.30.2-1.1) over (1.29.6-1.1) ...
Setting up kubectl (1.30.2-1.1) ...
Setting up cri-tools (1.30.0-1.1) ...
Setting up kubelet (1.30.2-1.1) ...
Setting up kubeadm (1.30.2-1.1) ...


TASK [Prevent kubernetes from being upgraded] **********************************************************************************************************************************************************************************************
changed: [k8s-worker-1] => (item=kubelet) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-1] => (item=kubeadm) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-1] => (item=kubectl) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubectl"
}

TASK [Get kubeadm version] *****************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1] => {
    "changed": false,
    "cmd": [
        "kubeadm",
        "version",
        "-o",
        "short"
    ],
    "delta": "0:00:00.033800",
    "end": "2024-06-18 19:19:28.447091",
    "rc": 0,
    "start": "2024-06-18 19:19:28.413291"
}

STDOUT:

v1.30.2

TASK [Upgrade] *****************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade apply v1.30.2 --yes",
    "delta": "0:00:09.360117",
    "end": "2024-06-18 19:19:45.028522",
    "rc": 0,
    "start": "2024-06-18 19:19:35.668405"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.30.2"
[upgrade/versions] Cluster version: v1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.30.2" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Current and new manifests of etcd are equal, skipping upgrade
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests1877352288"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Current and new manifests of kube-apiserver are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Current and new manifests of kube-controller-manager are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Current and new manifests of kube-scheduler are equal, skipping upgrade
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config3096412410/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.30.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.


STDERR:

W0618 19:19:39.800770   18848 checks.go:844] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.9" as the CRI sandbox image.

TASK [Get kubernetes details] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmt1bh2p955d0f1f72a",
        "-o",
        "json"
    ],
    "delta": "0:00:00.085015",
    "end": "2024-06-18 19:19:48.897834",
    "failed_when_result": false,
    "rc": 0,
    "start": "2024-06-18 19:19:48.812819"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:34:ec:28:99:de\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.24",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.24/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.115.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:22Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmt1bh2p955d0f1f72a",
            "kubernetes.io/os": "linux"
        },
        "name": "fhmt1bh2p955d0f1f72a",
        "resourceVersion": "2696",
        "uid": "f31d5e2f-ebf2-4b9a-8e81-7a417a668ec4"
    },
    "spec": {
        "podCIDR": "10.244.2.0/24",
        "podCIDRs": [
            "10.244.2.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.24",
                "type": "InternalIP"
            },
            {
                "address": "fhmt1bh2p955d0f1f72a",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643587Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136612Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:07Z",
                "lastTransitionTime": "2024-06-18T19:06:07Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:48Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "docker.io/library/alpine@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd",
                    "docker.io/library/alpine:latest"
                ],
                "sizeBytes": 3625947
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "db8162d5-3f15-4f97-b3a2-0d8eecfadf1d",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6dd0ae22ca4a5681e179c4a",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dd-0ae2-2ca4-a5681e179c4a"
        }
    }
}

TASK [Cordon node] *************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "cordon",
        "fhmt1bh2p955d0f1f72a"
    ],
    "delta": "0:00:00.129749",
    "end": "2024-06-18 19:19:53.099436",
    "rc": 0,
    "start": "2024-06-18 19:19:52.969687"
}

STDOUT:

node/fhmt1bh2p955d0f1f72a cordoned

TASK [Wait for node to cordon] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmt1bh2p955d0f1f72a",
        "-o",
        "json"
    ],
    "delta": "0:00:00.063965",
    "end": "2024-06-18 19:19:57.009181",
    "rc": 0,
    "start": "2024-06-18 19:19:56.945216"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:34:ec:28:99:de\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.24",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.24/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.115.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:22Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmt1bh2p955d0f1f72a",
            "kubernetes.io/os": "linux"
        },
        "name": "fhmt1bh2p955d0f1f72a",
        "resourceVersion": "2893",
        "uid": "f31d5e2f-ebf2-4b9a-8e81-7a417a668ec4"
    },
    "spec": {
        "podCIDR": "10.244.2.0/24",
        "podCIDRs": [
            "10.244.2.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node.kubernetes.io/unschedulable",
                "timeAdded": "2024-06-18T19:19:53Z"
            }
        ],
        "unschedulable": true
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.24",
                "type": "InternalIP"
            },
            {
                "address": "fhmt1bh2p955d0f1f72a",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643587Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136612Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:07Z",
                "lastTransitionTime": "2024-06-18T19:06:07Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:18:09Z",
                "lastTransitionTime": "2024-06-18T19:05:48Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "docker.io/library/alpine@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd",
                    "docker.io/library/alpine:latest"
                ],
                "sizeBytes": 3625947
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "db8162d5-3f15-4f97-b3a2-0d8eecfadf1d",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6dd0ae22ca4a5681e179c4a",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dd-0ae2-2ca4-a5681e179c4a"
        }
    }
}

TASK [Drain node] **************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "drain",
        "--force",
        "--ignore-daemonsets",
        "--grace-period",
        "300",
        "--timeout",
        "360s",
        "--delete-emptydir-data",
        "fhmt1bh2p955d0f1f72a"
    ],
    "delta": "0:05:02.187805",
    "end": "2024-06-18 19:25:02.578049",
    "rc": 0,
    "start": "2024-06-18 19:20:00.390244"
}

STDOUT:

node/fhmt1bh2p955d0f1f72a already cordoned
evicting pod default/test-566dbfbbc4-8sm8x
pod/test-566dbfbbc4-8sm8x evicted
node/fhmt1bh2p955d0f1f72a drained


STDERR:

Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-l6x76, kube-system/calico-node-gmcwt, kube-system/kube-proxy-c75jg

TASK [Update all packages] *****************************************************************************************************************************************************************************************************************
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
changed: [k8s-worker-1] => {
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (38.9 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...



MSG:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  kubernetes-cni
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 32.9 MB of archives.
After this operation, 2385 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Fetched 32.9 MB in 1s (38.9 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up kubernetes-cni (1.4.0-1.1) ...


TASK [Check if reboot is required] *********************************************************************************************************************************************************************************************************
ok: [k8s-worker-1] => {
    "changed": false,
    "stat": {
        "exists": false
    }
}

TASK [Reboot the server] *******************************************************************************************************************************************************************************************************************
skipping: [k8s-worker-1] => {
    "changed": false,
    "false_condition": "reboot_required.stat.exists",
    "skip_reason": "Conditional result was False"
}

TASK [Restart kubelet service] *************************************************************************************************************************************************************************************************************
changed: [k8s-worker-1] => {
    "attempts": 1,
    "changed": true,
    "enabled": true,
    "name": "kubelet",
    "state": "started",
    "status": {
        "ActiveEnterTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "ActiveEnterTimestampMonotonic": "276526822",
        "ActiveExitTimestamp": "Tue 2024-06-18 19:05:20 UTC",
        "ActiveExitTimestampMonotonic": "274859644",
        "ActiveState": "active",
        "After": "systemd-journald.socket sysinit.target system.slice network-online.target basic.target",
        "AllowIsolate": "no",
        "AllowedCPUs": "",
        "AllowedMemoryNodes": "",
        "AmbientCapabilities": "",
        "AssertResult": "yes",
        "AssertTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "AssertTimestampMonotonic": "276525362",
        "Before": "shutdown.target multi-user.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "[not set]",
        "CPUAccounting": "no",
        "CPUAffinity": "",
        "CPUAffinityFromNUMA": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUQuotaPeriodUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "[not set]",
        "CPUUsageNSec": "[not set]",
        "CPUWeight": "[not set]",
        "CacheDirectoryMode": "0755",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "cap_chown cap_dac_override cap_dac_read_search cap_fowner cap_fsetid cap_kill cap_setgid cap_setuid cap_setpcap cap_linux_immutable cap_net_bind_service cap_net_broadcast cap_net_admin cap_net_raw cap_ipc_lock cap_ipc_owner cap_sys_module cap_sys_rawio cap_sys_chroot cap_sys_ptrace cap_sys_pacct cap_sys_admin cap_sys_boot cap_sys_nice cap_sys_resource cap_sys_time cap_sys_tty_config cap_mknod cap_lease cap_audit_write cap_audit_control cap_setfcap cap_mac_override cap_mac_admin cap_syslog cap_wake_alarm cap_block_suspend cap_audit_read",
        "CleanResult": "success",
        "CollectMode": "inactive",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "ConditionTimestampMonotonic": "276525361",
        "ConfigurationDirectoryMode": "0755",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/kubelet.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "DefaultMemoryLow": "0",
        "DefaultMemoryMin": "0",
        "Delegate": "no",
        "Description": "kubelet: The Kubernetes Node Agent",
        "DevicePolicy": "auto",
        "Documentation": "https://kubernetes.io/docs/",
        "DropInPaths": "/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf",
        "DynamicUser": "no",
        "EffectiveCPUs": "",
        "EffectiveMemoryNodes": "",
        "Environment": "[unprintable] KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml",
        "EnvironmentFiles": "/etc/default/kubelet (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "1613",
        "ExecMainStartTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "ExecMainStartTimestampMonotonic": "276526440",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStartEx": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; flags= ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FinalKillSignal": "9",
        "FragmentPath": "/lib/systemd/system/kubelet.service",
        "GID": "[not set]",
        "GuessMainPID": "yes",
        "IOAccounting": "no",
        "IOReadBytes": "18446744073709551615",
        "IOReadOperations": "18446744073709551615",
        "IOSchedulingClass": "0",
        "IOSchedulingPriority": "0",
        "IOWeight": "[not set]",
        "IOWriteBytes": "18446744073709551615",
        "IOWriteOperations": "18446744073709551615",
        "IPAccounting": "no",
        "IPEgressBytes": "[no data]",
        "IPEgressPackets": "[no data]",
        "IPIngressBytes": "[no data]",
        "IPIngressPackets": "[no data]",
        "Id": "kubelet.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "InactiveEnterTimestampMonotonic": "276312298",
        "InactiveExitTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "InactiveExitTimestampMonotonic": "276526822",
        "InvocationID": "5dacdf8c422f4a0487da8b6b32b4e0d0",
        "JobRunningTimeoutUSec": "infinity",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KeyringMode": "private",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "infinity",
        "LimitASSoft": "infinity",
        "LimitCORE": "infinity",
        "LimitCORESoft": "0",
        "LimitCPU": "infinity",
        "LimitCPUSoft": "infinity",
        "LimitDATA": "infinity",
        "LimitDATASoft": "infinity",
        "LimitFSIZE": "infinity",
        "LimitFSIZESoft": "infinity",
        "LimitLOCKS": "infinity",
        "LimitLOCKSSoft": "infinity",
        "LimitMEMLOCK": "65536",
        "LimitMEMLOCKSoft": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "524288",
        "LimitNOFILESoft": "1024",
        "LimitNPROC": "31539",
        "LimitNPROCSoft": "31539",
        "LimitRSS": "infinity",
        "LimitRSSSoft": "infinity",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "infinity",
        "LimitRTTIMESoft": "infinity",
        "LimitSIGPENDING": "31539",
        "LimitSIGPENDINGSoft": "31539",
        "LimitSTACK": "infinity",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "LockPersonality": "no",
        "LogLevelMax": "-1",
        "LogRateLimitBurst": "0",
        "LogRateLimitIntervalUSec": "0",
        "LogsDirectoryMode": "0755",
        "MainPID": "1613",
        "MemoryAccounting": "yes",
        "MemoryCurrent": "46088192",
        "MemoryDenyWriteExecute": "no",
        "MemoryHigh": "infinity",
        "MemoryLimit": "infinity",
        "MemoryLow": "0",
        "MemoryMax": "infinity",
        "MemoryMin": "0",
        "MemorySwapMax": "infinity",
        "MountAPIVFS": "no",
        "MountFlags": "",
        "NFileDescriptorStore": "0",
        "NRestarts": "25",
        "NUMAMask": "",
        "NUMAPolicy": "n/a",
        "Names": "kubelet.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMPolicy": "stop",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "Perpetual": "no",
        "PrivateDevices": "no",
        "PrivateMounts": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "PrivateUsers": "no",
        "ProtectControlGroups": "no",
        "ProtectHome": "no",
        "ProtectHostname": "no",
        "ProtectKernelLogs": "no",
        "ProtectKernelModules": "no",
        "ProtectKernelTunables": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "ReloadResult": "success",
        "RemainAfterExit": "no",
        "RemoveIPC": "no",
        "Requires": "sysinit.target system.slice",
        "Restart": "always",
        "RestartKillSignal": "15",
        "RestartUSec": "10s",
        "RestrictNamespaces": "no",
        "RestrictRealtime": "no",
        "RestrictSUIDSGID": "no",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeDirectoryPreserve": "no",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardInputData": "",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitIntervalUSec": "0",
        "StartupBlockIOWeight": "[not set]",
        "StartupCPUShares": "[not set]",
        "StartupCPUWeight": "[not set]",
        "StartupIOWeight": "[not set]",
        "StateChangeTimestamp": "Tue 2024-06-18 19:05:21 UTC",
        "StateChangeTimestampMonotonic": "276526822",
        "StateDirectoryMode": "0755",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SuccessAction": "none",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "yes",
        "TasksCurrent": "11",
        "TasksMax": "9461",
        "TimeoutAbortUSec": "1min 30s",
        "TimeoutCleanUSec": "infinity",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UID": "[not set]",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "Wants": "network-online.target",
        "WatchdogSignal": "6",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "0"
    }
}

TASK [Uncordon node] ***********************************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "uncordon",
        "fhmt1bh2p955d0f1f72a"
    ],
    "delta": "0:00:00.096714",
    "end": "2024-06-18 19:25:29.953693",
    "rc": 0,
    "start": "2024-06-18 19:25:29.856979"
}

STDOUT:

node/fhmt1bh2p955d0f1f72a uncordoned

TASK [Wait for node to uncordon] ***********************************************************************************************************************************************************************************************************
ok: [k8s-worker-1 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhmt1bh2p955d0f1f72a",
        "-o",
        "json"
    ],
    "delta": "0:00:00.064098",
    "end": "2024-06-18 19:25:33.192966",
    "rc": 0,
    "start": "2024-06-18 19:25:33.128868"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:34:ec:28:99:de\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.24",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.24/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.115.192",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:22Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhmt1bh2p955d0f1f72a",
            "kubernetes.io/os": "linux"
        },
        "name": "fhmt1bh2p955d0f1f72a",
        "resourceVersion": "3476",
        "uid": "f31d5e2f-ebf2-4b9a-8e81-7a417a668ec4"
    },
    "spec": {
        "podCIDR": "10.244.2.0/24",
        "podCIDRs": [
            "10.244.2.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.24",
                "type": "InternalIP"
            },
            {
                "address": "fhmt1bh2p955d0f1f72a",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643587Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136612Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:07Z",
                "lastTransitionTime": "2024-06-18T19:06:07Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:25:26Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:25:26Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:25:26Z",
                "lastTransitionTime": "2024-06-18T19:05:22Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:25:26Z",
                "lastTransitionTime": "2024-06-18T19:05:48Z",
                "message": "kubelet is posting ready status",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "docker.io/library/alpine@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd",
                    "docker.io/library/alpine:latest"
                ],
                "sizeBytes": 3625947
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "db8162d5-3f15-4f97-b3a2-0d8eecfadf1d",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.30.2",
            "kubeletVersion": "v1.30.2",
            "machineID": "23000007c6dd0ae22ca4a5681e179c4a",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6dd-0ae2-2ca4-a5681e179c4a"
        }
    }
}

PLAY [Upgrade K8s] *************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host k8s-worker-2 is using the discovered Python interpreter at /usr/bin/python3.8, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [k8s-worker-2]

TASK [Add Kubernetes APT key] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2] => {
    "before": [
        "234654DA9A296436"
    ],
    "changed": false,
    "fp": "234654DA9A296436",
    "id": "234654DA9A296436",
    "key_id": "234654DA9A296436",
    "short_id": "9A296436"
}

TASK [Add Kubernetes APT repository] *******************************************************************************************************************************************************************************************************
changed: [k8s-worker-2] => {
    "changed": true,
    "repo": "deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /",
    "sources_added": [],
    "sources_removed": [],
    "state": "present"
}

TASK [Verify the upgrade plan] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade plan",
    "delta": "0:00:07.167487",
    "end": "2024-06-18 19:26:23.423598",
    "rc": 0,
    "start": "2024-06-18 19:26:16.256111"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/versions] Target version: v1.30.2
[upgrade/versions] Latest version in the v1.30 series: v1.30.2

TASK [Unhold kubernetes packages] **********************************************************************************************************************************************************************************************************
changed: [k8s-worker-2] => (item=kubelet) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-2] => (item=kubeadm) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-2] => (item=kubectl) => {
    "after": "install",
    "ansible_loop_var": "item",
    "before": "hold",
    "changed": true,
    "item": "kubectl"
}

TASK [Waiting the cancel] ******************************************************************************************************************************************************************************************************************
Pausing for 60 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [k8s-worker-2] => {
    "changed": false,
    "delta": 60,
    "echo": true,
    "rc": 0,
    "start": "2024-06-18 22:26:02.799073",
    "stop": "2024-06-18 22:27:02.800944",
    "user_input": ""
}

STDOUT:

Paused for 1.0 minutes

TASK [Upgrading kubernetes] ****************************************************************************************************************************************************************************************************************
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 3 not upgraded.
changed: [k8s-worker-2] => {
    "cache_update_time": 1718738771,
    "cache_updated": false,
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  cri-tools
The following packages will be upgraded:
  cri-tools kubeadm kubectl kubelet
4 upgraded, 0 newly installed, 0 to remove and 3 not upgraded.
Need to get 60.5 MB of archives.
After this operation, 5251 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  cri-tools 1.30.0-1.1 [21.3 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubeadm 1.30.2-1.1 [10.4 MB]
Get:3 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubectl 1.30.2-1.1 [10.8 MB]
Get:4 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubelet 1.30.2-1.1 [18.1 MB]
Fetched 60.5 MB in 1s (44.7 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../cri-tools_1.30.0-1.1_amd64.deb ...
Unpacking cri-tools (1.30.0-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubeadm_1.30.2-1.1_amd64.deb ...
Unpacking kubeadm (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubectl_1.30.2-1.1_amd64.deb ...
Unpacking kubectl (1.30.2-1.1) over (1.29.6-1.1) ...
Preparing to unpack .../kubelet_1.30.2-1.1_amd64.deb ...
Unpacking kubelet (1.30.2-1.1) over (1.29.6-1.1) ...
Setting up kubectl (1.30.2-1.1) ...
Setting up cri-tools (1.30.0-1.1) ...
Setting up kubelet (1.30.2-1.1) ...
Setting up kubeadm (1.30.2-1.1) ...


TASK [Prevent kubernetes from being upgraded] **********************************************************************************************************************************************************************************************
changed: [k8s-worker-2] => (item=kubelet) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubelet"
}
changed: [k8s-worker-2] => (item=kubeadm) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubeadm"
}
changed: [k8s-worker-2] => (item=kubectl) => {
    "after": "hold",
    "ansible_loop_var": "item",
    "before": "install",
    "changed": true,
    "item": "kubectl"
}

TASK [Get kubeadm version] *****************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2] => {
    "changed": false,
    "cmd": [
        "kubeadm",
        "version",
        "-o",
        "short"
    ],
    "delta": "0:00:00.036756",
    "end": "2024-06-18 19:28:18.624749",
    "rc": 0,
    "start": "2024-06-18 19:28:18.587993"
}

STDOUT:

v1.30.2

TASK [Upgrade] *****************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": "kubeadm upgrade apply v1.30.2 --yes",
    "delta": "0:00:09.455758",
    "end": "2024-06-18 19:28:35.389298",
    "rc": 0,
    "start": "2024-06-18 19:28:25.933540"
}

STDOUT:

[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.30.2"
[upgrade/versions] Cluster version: v1.30.2
[upgrade/versions] kubeadm version: v1.30.2
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.30.2" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Current and new manifests of etcd are equal, skipping upgrade
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests4284912516"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Current and new manifests of kube-apiserver are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Current and new manifests of kube-controller-manager are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Current and new manifests of kube-scheduler are equal, skipping upgrade
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config391151638/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.30.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.


STDERR:

W0618 19:28:30.217255   23975 checks.go:844] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.9" as the CRI sandbox image.

TASK [Get kubernetes details] **************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhm5tub66ct0p545llq7",
        "-o",
        "json"
    ],
    "delta": "0:00:00.069348",
    "end": "2024-06-18 19:28:38.620089",
    "failed_when_result": false,
    "rc": 0,
    "start": "2024-06-18 19:28:38.550741"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:93:73:a4:4b:ee\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.16",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.16/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.246.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:30Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhm5tub66ct0p545llq7",
            "kubernetes.io/os": "linux"
        },
        "name": "fhm5tub66ct0p545llq7",
        "resourceVersion": "3811",
        "uid": "8dd5c878-0b97-486f-a5f2-82d98984e404"
    },
    "spec": {
        "podCIDR": "10.244.3.0/24",
        "podCIDRs": [
            "10.244.3.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.16",
                "type": "InternalIP"
            },
            {
                "address": "fhm5tub66ct0p545llq7",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:15Z",
                "lastTransitionTime": "2024-06-18T19:06:15Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:55Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "2f822006-5337-47bf-9181-5eedb18c6b62",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6c5ef966333a0c9485ad747",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6c5-ef96-6333-a0c9485ad747"
        }
    }
}

TASK [Cordon node] *************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "cordon",
        "fhm5tub66ct0p545llq7"
    ],
    "delta": "0:00:00.107554",
    "end": "2024-06-18 19:28:42.295775",
    "rc": 0,
    "start": "2024-06-18 19:28:42.188221"
}

STDOUT:

node/fhm5tub66ct0p545llq7 cordoned

TASK [Wait for node to cordon] *************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhm5tub66ct0p545llq7",
        "-o",
        "json"
    ],
    "delta": "0:00:00.075693",
    "end": "2024-06-18 19:28:46.308468",
    "rc": 0,
    "start": "2024-06-18 19:28:46.232775"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:93:73:a4:4b:ee\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.16",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.16/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.246.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:30Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhm5tub66ct0p545llq7",
            "kubernetes.io/os": "linux"
        },
        "name": "fhm5tub66ct0p545llq7",
        "resourceVersion": "3851",
        "uid": "8dd5c878-0b97-486f-a5f2-82d98984e404"
    },
    "spec": {
        "podCIDR": "10.244.3.0/24",
        "podCIDRs": [
            "10.244.3.0/24"
        ],
        "taints": [
            {
                "effect": "NoSchedule",
                "key": "node.kubernetes.io/unschedulable",
                "timeAdded": "2024-06-18T19:28:42Z"
            }
        ],
        "unschedulable": true
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.16",
                "type": "InternalIP"
            },
            {
                "address": "fhm5tub66ct0p545llq7",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:15Z",
                "lastTransitionTime": "2024-06-18T19:06:15Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:28:27Z",
                "lastTransitionTime": "2024-06-18T19:05:55Z",
                "message": "kubelet is posting ready status. AppArmor enabled",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "2f822006-5337-47bf-9181-5eedb18c6b62",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.29.6",
            "kubeletVersion": "v1.29.6",
            "machineID": "23000007c6c5ef966333a0c9485ad747",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6c5-ef96-6333-a0c9485ad747"
        }
    }
}

TASK [Drain node] **************************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "changed": false,
    "cmd": [
        "kubectl",
        "drain",
        "--force",
        "--ignore-daemonsets",
        "--grace-period",
        "300",
        "--timeout",
        "360s",
        "--delete-emptydir-data",
        "fhm5tub66ct0p545llq7"
    ],
    "delta": "0:00:06.186582",
    "end": "2024-06-18 19:28:55.978077",
    "rc": 0,
    "start": "2024-06-18 19:28:49.791495"
}

STDOUT:

node/fhm5tub66ct0p545llq7 already cordoned
evicting pod kube-system/coredns-76f75df574-sn94z
evicting pod kube-system/calico-kube-controllers-658d97c59c-nxlht
pod/calico-kube-controllers-658d97c59c-nxlht evicted
pod/coredns-76f75df574-sn94z evicted
node/fhm5tub66ct0p545llq7 drained


STDERR:

Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-rc9p6, kube-system/calico-node-trwpq, kube-system/kube-proxy-xlr9l

TASK [Update all packages] *****************************************************************************************************************************************************************************************************************
Calculating upgrade...
The following packages will be upgraded:
  git git-man kubernetes-cni
3 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
changed: [k8s-worker-2] => {
    "changed": true
}

STDOUT:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  git git-man kubernetes-cni
3 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 38.4 MB of archives.
After this operation, 2397 kB of additional disk space will be used.
Get:1 http://security.ubuntu.com/ubuntu focal-security/main amd64 git-man all 1:2.25.1-1ubuntu3.13 [887 kB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Get:3 http://security.ubuntu.com/ubuntu focal-security/main amd64 git amd64 1:2.25.1-1ubuntu3.13 [4612 kB]
Fetched 38.4 MB in 1s (26.9 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../git-man_1%3a2.25.1-1ubuntu3.13_all.deb ...
Unpacking git-man (1:2.25.1-1ubuntu3.13) over (1:2.25.1-1ubuntu3.12) ...
Preparing to unpack .../git_1%3a2.25.1-1ubuntu3.13_amd64.deb ...
Unpacking git (1:2.25.1-1ubuntu3.13) over (1:2.25.1-1ubuntu3.12) ...
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up git-man (1:2.25.1-1ubuntu3.13) ...
Setting up kubernetes-cni (1.4.0-1.1) ...
Setting up git (1:2.25.1-1ubuntu3.13) ...
Processing triggers for man-db (2.9.1-1) ...



MSG:

Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following packages will be upgraded:
  git git-man kubernetes-cni
3 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 38.4 MB of archives.
After this operation, 2397 kB of additional disk space will be used.
Get:1 http://security.ubuntu.com/ubuntu focal-security/main amd64 git-man all 1:2.25.1-1ubuntu3.13 [887 kB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.30/deb  kubernetes-cni 1.4.0-1.1 [32.9 MB]
Get:3 http://security.ubuntu.com/ubuntu focal-security/main amd64 git amd64 1:2.25.1-1ubuntu3.13 [4612 kB]
Fetched 38.4 MB in 1s (26.9 MB/s)
(Reading database ... 106013 files and directories currently installed.)
Preparing to unpack .../git-man_1%3a2.25.1-1ubuntu3.13_all.deb ...
Unpacking git-man (1:2.25.1-1ubuntu3.13) over (1:2.25.1-1ubuntu3.12) ...
Preparing to unpack .../git_1%3a2.25.1-1ubuntu3.13_amd64.deb ...
Unpacking git (1:2.25.1-1ubuntu3.13) over (1:2.25.1-1ubuntu3.12) ...
Preparing to unpack .../kubernetes-cni_1.4.0-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.4.0-1.1) over (1.3.0-1.1) ...
Setting up git-man (1:2.25.1-1ubuntu3.13) ...
Setting up kubernetes-cni (1.4.0-1.1) ...
Setting up git (1:2.25.1-1ubuntu3.13) ...
Processing triggers for man-db (2.9.1-1) ...


TASK [Check if reboot is required] *********************************************************************************************************************************************************************************************************
ok: [k8s-worker-2] => {
    "changed": false,
    "stat": {
        "exists": false
    }
}

TASK [Reboot the server] *******************************************************************************************************************************************************************************************************************
skipping: [k8s-worker-2] => {
    "changed": false,
    "false_condition": "reboot_required.stat.exists",
    "skip_reason": "Conditional result was False"
}

TASK [Restart kubelet service] *************************************************************************************************************************************************************************************************************
changed: [k8s-worker-2] => {
    "attempts": 1,
    "changed": true,
    "enabled": true,
    "name": "kubelet",
    "state": "started",
    "status": {
        "ActiveEnterTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "ActiveEnterTimestampMonotonic": "272423153",
        "ActiveExitTimestamp": "Tue 2024-06-18 19:05:26 UTC",
        "ActiveExitTimestampMonotonic": "270565006",
        "ActiveState": "active",
        "After": "systemd-journald.socket system.slice sysinit.target network-online.target basic.target",
        "AllowIsolate": "no",
        "AllowedCPUs": "",
        "AllowedMemoryNodes": "",
        "AmbientCapabilities": "",
        "AssertResult": "yes",
        "AssertTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "AssertTimestampMonotonic": "272421446",
        "Before": "shutdown.target multi-user.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "[not set]",
        "CPUAccounting": "no",
        "CPUAffinity": "",
        "CPUAffinityFromNUMA": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUQuotaPeriodUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "[not set]",
        "CPUUsageNSec": "[not set]",
        "CPUWeight": "[not set]",
        "CacheDirectoryMode": "0755",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "cap_chown cap_dac_override cap_dac_read_search cap_fowner cap_fsetid cap_kill cap_setgid cap_setuid cap_setpcap cap_linux_immutable cap_net_bind_service cap_net_broadcast cap_net_admin cap_net_raw cap_ipc_lock cap_ipc_owner cap_sys_module cap_sys_rawio cap_sys_chroot cap_sys_ptrace cap_sys_pacct cap_sys_admin cap_sys_boot cap_sys_nice cap_sys_resource cap_sys_time cap_sys_tty_config cap_mknod cap_lease cap_audit_write cap_audit_control cap_setfcap cap_mac_override cap_mac_admin cap_syslog cap_wake_alarm cap_block_suspend cap_audit_read",
        "CleanResult": "success",
        "CollectMode": "inactive",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "ConditionTimestampMonotonic": "272421446",
        "ConfigurationDirectoryMode": "0755",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/kubelet.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "DefaultMemoryLow": "0",
        "DefaultMemoryMin": "0",
        "Delegate": "no",
        "Description": "kubelet: The Kubernetes Node Agent",
        "DevicePolicy": "auto",
        "Documentation": "https://kubernetes.io/docs/",
        "DropInPaths": "/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf",
        "DynamicUser": "no",
        "EffectiveCPUs": "",
        "EffectiveMemoryNodes": "",
        "Environment": "[unprintable] KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml",
        "EnvironmentFiles": "/etc/default/kubelet (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "1637",
        "ExecMainStartTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "ExecMainStartTimestampMonotonic": "272422764",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStartEx": "{ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS ; flags= ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FinalKillSignal": "9",
        "FragmentPath": "/lib/systemd/system/kubelet.service",
        "GID": "[not set]",
        "GuessMainPID": "yes",
        "IOAccounting": "no",
        "IOReadBytes": "18446744073709551615",
        "IOReadOperations": "18446744073709551615",
        "IOSchedulingClass": "0",
        "IOSchedulingPriority": "0",
        "IOWeight": "[not set]",
        "IOWriteBytes": "18446744073709551615",
        "IOWriteOperations": "18446744073709551615",
        "IPAccounting": "no",
        "IPEgressBytes": "[no data]",
        "IPEgressPackets": "[no data]",
        "IPIngressBytes": "[no data]",
        "IPIngressPackets": "[no data]",
        "Id": "kubelet.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "InactiveEnterTimestampMonotonic": "272182612",
        "InactiveExitTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "InactiveExitTimestampMonotonic": "272423153",
        "InvocationID": "1891a03e267446078fa9f7011481a595",
        "JobRunningTimeoutUSec": "infinity",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KeyringMode": "private",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "infinity",
        "LimitASSoft": "infinity",
        "LimitCORE": "infinity",
        "LimitCORESoft": "0",
        "LimitCPU": "infinity",
        "LimitCPUSoft": "infinity",
        "LimitDATA": "infinity",
        "LimitDATASoft": "infinity",
        "LimitFSIZE": "infinity",
        "LimitFSIZESoft": "infinity",
        "LimitLOCKS": "infinity",
        "LimitLOCKSSoft": "infinity",
        "LimitMEMLOCK": "65536",
        "LimitMEMLOCKSoft": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "524288",
        "LimitNOFILESoft": "1024",
        "LimitNPROC": "31539",
        "LimitNPROCSoft": "31539",
        "LimitRSS": "infinity",
        "LimitRSSSoft": "infinity",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "infinity",
        "LimitRTTIMESoft": "infinity",
        "LimitSIGPENDING": "31539",
        "LimitSIGPENDINGSoft": "31539",
        "LimitSTACK": "infinity",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "LockPersonality": "no",
        "LogLevelMax": "-1",
        "LogRateLimitBurst": "0",
        "LogRateLimitIntervalUSec": "0",
        "LogsDirectoryMode": "0755",
        "MainPID": "1637",
        "MemoryAccounting": "yes",
        "MemoryCurrent": "47484928",
        "MemoryDenyWriteExecute": "no",
        "MemoryHigh": "infinity",
        "MemoryLimit": "infinity",
        "MemoryLow": "0",
        "MemoryMax": "infinity",
        "MemoryMin": "0",
        "MemorySwapMax": "infinity",
        "MountAPIVFS": "no",
        "MountFlags": "",
        "NFileDescriptorStore": "0",
        "NRestarts": "24",
        "NUMAMask": "",
        "NUMAPolicy": "n/a",
        "Names": "kubelet.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMPolicy": "stop",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "Perpetual": "no",
        "PrivateDevices": "no",
        "PrivateMounts": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "PrivateUsers": "no",
        "ProtectControlGroups": "no",
        "ProtectHome": "no",
        "ProtectHostname": "no",
        "ProtectKernelLogs": "no",
        "ProtectKernelModules": "no",
        "ProtectKernelTunables": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "ReloadResult": "success",
        "RemainAfterExit": "no",
        "RemoveIPC": "no",
        "Requires": "sysinit.target system.slice",
        "Restart": "always",
        "RestartKillSignal": "15",
        "RestartUSec": "10s",
        "RestrictNamespaces": "no",
        "RestrictRealtime": "no",
        "RestrictSUIDSGID": "no",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeDirectoryPreserve": "no",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardInputData": "",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitIntervalUSec": "0",
        "StartupBlockIOWeight": "[not set]",
        "StartupCPUShares": "[not set]",
        "StartupCPUWeight": "[not set]",
        "StartupIOWeight": "[not set]",
        "StateChangeTimestamp": "Tue 2024-06-18 19:05:28 UTC",
        "StateChangeTimestampMonotonic": "272423153",
        "StateDirectoryMode": "0755",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SuccessAction": "none",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "yes",
        "TasksCurrent": "11",
        "TasksMax": "9461",
        "TimeoutAbortUSec": "1min 30s",
        "TimeoutCleanUSec": "infinity",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UID": "[not set]",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "Wants": "network-online.target",
        "WatchdogSignal": "6",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "0"
    }
}

TASK [Uncordon node] ***********************************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "uncordon",
        "fhm5tub66ct0p545llq7"
    ],
    "delta": "0:00:00.127265",
    "end": "2024-06-18 19:29:28.321936",
    "rc": 0,
    "start": "2024-06-18 19:29:28.194671"
}

STDOUT:

node/fhm5tub66ct0p545llq7 uncordoned

TASK [Wait for node to uncordon] ***********************************************************************************************************************************************************************************************************
ok: [k8s-worker-2 -> k8s-master-0(178.154.202.246)] => {
    "attempts": 1,
    "changed": false,
    "cmd": [
        "kubectl",
        "get",
        "node",
        "fhm5tub66ct0p545llq7",
        "-o",
        "json"
    ],
    "delta": "0:00:00.068921",
    "end": "2024-06-18 19:29:32.432437",
    "rc": 0,
    "start": "2024-06-18 19:29:32.363516"
}

STDOUT:

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "annotations": {
            "flannel.alpha.coreos.com/backend-data": "{\"VNI\":1,\"VtepMAC\":\"3e:93:73:a4:4b:ee\"}",
            "flannel.alpha.coreos.com/backend-type": "vxlan",
            "flannel.alpha.coreos.com/kube-subnet-manager": "true",
            "flannel.alpha.coreos.com/public-ip": "192.168.99.16",
            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///var/run/containerd/containerd.sock",
            "node.alpha.kubernetes.io/ttl": "0",
            "projectcalico.org/IPv4Address": "192.168.99.16/24",
            "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.246.64",
            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
        },
        "creationTimestamp": "2024-06-18T19:05:30Z",
        "labels": {
            "beta.kubernetes.io/arch": "amd64",
            "beta.kubernetes.io/os": "linux",
            "kubernetes.io/arch": "amd64",
            "kubernetes.io/hostname": "fhm5tub66ct0p545llq7",
            "kubernetes.io/os": "linux"
        },
        "name": "fhm5tub66ct0p545llq7",
        "resourceVersion": "4015",
        "uid": "8dd5c878-0b97-486f-a5f2-82d98984e404"
    },
    "spec": {
        "podCIDR": "10.244.3.0/24",
        "podCIDRs": [
            "10.244.3.0/24"
        ]
    },
    "status": {
        "addresses": [
            {
                "address": "192.168.99.16",
                "type": "InternalIP"
            },
            {
                "address": "fhm5tub66ct0p545llq7",
                "type": "Hostname"
            }
        ],
        "allocatable": {
            "cpu": "1800m",
            "ephemeral-storage": "37957706894",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "7643583Ki",
            "pods": "110"
        },
        "capacity": {
            "cpu": "2",
            "ephemeral-storage": "41186748Ki",
            "hugepages-1Gi": "0",
            "hugepages-2Mi": "0",
            "memory": "8136608Ki",
            "pods": "110"
        },
        "conditions": [
            {
                "lastHeartbeatTime": "2024-06-18T19:06:15Z",
                "lastTransitionTime": "2024-06-18T19:06:15Z",
                "message": "Flannel is running on this node",
                "reason": "FlannelIsUp",
                "status": "False",
                "type": "NetworkUnavailable"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:29:24Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient memory available",
                "reason": "KubeletHasSufficientMemory",
                "status": "False",
                "type": "MemoryPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:29:24Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has no disk pressure",
                "reason": "KubeletHasNoDiskPressure",
                "status": "False",
                "type": "DiskPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:29:24Z",
                "lastTransitionTime": "2024-06-18T19:05:30Z",
                "message": "kubelet has sufficient PID available",
                "reason": "KubeletHasSufficientPID",
                "status": "False",
                "type": "PIDPressure"
            },
            {
                "lastHeartbeatTime": "2024-06-18T19:29:24Z",
                "lastTransitionTime": "2024-06-18T19:05:55Z",
                "message": "kubelet is posting ready status",
                "reason": "KubeletReady",
                "status": "True",
                "type": "Ready"
            }
        ],
        "daemonEndpoints": {
            "kubeletEndpoint": {
                "Port": 10250
            }
        },
        "images": [
            {
                "names": [
                    "docker.io/calico/cni@sha256:a38d53cb8688944eafede2f0eadc478b1b403cefeff7953da57fe9cd2d65e977",
                    "docker.io/calico/cni:v3.25.0"
                ],
                "sizeBytes": 87984941
            },
            {
                "names": [
                    "docker.io/calico/node@sha256:a85123d1882832af6c45b5e289c6bb99820646cb7d4f6006f98095168808b1e6",
                    "docker.io/calico/node:v3.25.0"
                ],
                "sizeBytes": 87185935
            },
            {
                "names": [
                    "docker.io/flannel/flannel@sha256:17415d91743e53fc4b852676a30a08915f131a2b6848d891ba5786eacd447076",
                    "docker.io/flannel/flannel:v0.25.4"
                ],
                "sizeBytes": 31429474
            },
            {
                "names": [
                    "docker.io/calico/kube-controllers@sha256:c45af3a9692d87a527451cf544557138fedf86f92b6e39bf2003e2fdb848dce3",
                    "docker.io/calico/kube-controllers:v3.25.0"
                ],
                "sizeBytes": 31271800
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:8a44c6e094af3dea3de57fa967e201608a358a3bd8b4e3f31ab905bbe4108aec",
                    "registry.k8s.io/kube-proxy:v1.30.2"
                ],
                "sizeBytes": 29034457
            },
            {
                "names": [
                    "registry.k8s.io/kube-proxy@sha256:88bacb3e1d6c0c37c6da95c6d6b8e30531d0b4d0ab540cc290b0af51fbfebd90",
                    "registry.k8s.io/kube-proxy:v1.29.6"
                ],
                "sizeBytes": 28408353
            },
            {
                "names": [
                    "registry.k8s.io/coredns/coredns@sha256:1eeb4c7316bacb1d4c8ead65571cd92dd21e27359f0d4917f1a5822a73b75db1",
                    "registry.k8s.io/coredns/coredns:v1.11.1"
                ],
                "sizeBytes": 18182961
            },
            {
                "names": [
                    "docker.io/flannel/flannel-cni-plugin@sha256:e88c0d84fa89679eb6cb6a28bc257d652ced8d1b2e44d54a592f0a2cd85dba53",
                    "docker.io/flannel/flannel-cni-plugin:v1.4.1-flannel1"
                ],
                "sizeBytes": 4710551
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:7031c1b283388d2c2e09b57badb803c05ebed362dc88d84b480cc47f72a21097",
                    "registry.k8s.io/pause:3.9"
                ],
                "sizeBytes": 321520
            },
            {
                "names": [
                    "registry.k8s.io/pause@sha256:3d380ca8864549e74af4b29c10f9cb0956236dfb01c40ca076fb6c37253234db",
                    "registry.k8s.io/pause:3.6"
                ],
                "sizeBytes": 301773
            }
        ],
        "nodeInfo": {
            "architecture": "amd64",
            "bootID": "2f822006-5337-47bf-9181-5eedb18c6b62",
            "containerRuntimeVersion": "containerd://1.6.33",
            "kernelVersion": "5.4.0-186-generic",
            "kubeProxyVersion": "v1.30.2",
            "kubeletVersion": "v1.30.2",
            "machineID": "23000007c6c5ef966333a0c9485ad747",
            "operatingSystem": "linux",
            "osImage": "Ubuntu 20.04.6 LTS",
            "systemUUID": "23000007-c6c5-ef96-6333-a0c9485ad747"
        }
    }
}

PLAY RECAP *********************************************************************************************************************************************************************************************************************************
k8s-master-0               : ok=19   changed=6    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
k8s-worker-0               : ok=19   changed=6    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
k8s-worker-1               : ok=19   changed=6    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
k8s-worker-2               : ok=19   changed=6    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
```

### Результат установки kubespray

```bash
$ ansible-playbook -i inventory/local/inventory.ini --become --become-user=root cluster.yml 
[WARNING]: While constructing a mapping from kubernetes-prod/kubespray/roles/bootstrap-os/tasks/main.yml, line 29, column 7, found a duplicate dict key (paths). Using last
defined value only.
[WARNING]: Skipping callback plugin 'ara_default', unable to load

PLAY [Check Ansible version] ***************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  15:47:50 +0300 (0:00:00.138)       0:00:00.138 ************ 

TASK [Check 2.16.4 <= Ansible version < 2.17.0] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:47:50 +0300 (0:00:00.031)       0:00:00.170 ************ 

TASK [Check that python netaddr is installed] **********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:47:50 +0300 (0:00:00.069)       0:00:00.240 ************ 

TASK [Check that jinja is not too old (install via pip)] ***********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
[WARNING]: Could not match supplied host pattern, ignoring: kube-master

PLAY [Add kube-master nodes to kube_control_plane] *****************************************************************************************************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: kube-node

PLAY [Add kube-node nodes to kube_node] ****************************************************************************************************************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: k8s-cluster

PLAY [Add k8s-cluster nodes to k8s_cluster] ************************************************************************************************************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: calico-rr

PLAY [Add calico-rr nodes to calico_rr] ****************************************************************************************************************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: no-floating

PLAY [Add no-floating nodes to no_floating] ************************************************************************************************************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: bastion

PLAY [Install bastion ssh config] **********************************************************************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Bootstrap hosts for Ansible] *********************************************************************************************************************************************************************************************************
Среда 19 июня 2024  15:47:50 +0300 (0:00:00.403)       0:00:00.643 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.124)       0:00:00.767 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.042)       0:00:00.810 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.129)       0:00:00.939 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.039)       0:00:00.979 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.130)       0:00:01.109 ************ 
Среда 19 июня 2024  15:47:51 +0300 (0:00:00.230)       0:00:01.340 ************ 
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Fetch /etc/os-release] ************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:47:55 +0300 (0:00:03.674)       0:00:05.014 ************ 
Среда 19 июня 2024  15:47:55 +0300 (0:00:00.170)       0:00:05.185 ************ 

TASK [bootstrap-os : Include tasks] ********************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/bootstrap-os/tasks/ubuntu.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item=kubernetes-prod/kubespray/roles/bootstrap-os/tasks/ubuntu.yml)
Среда 19 июня 2024  15:47:55 +0300 (0:00:00.282)       0:00:05.467 ************ 

TASK [bootstrap-os : Check if bootstrap is needed] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:47:56 +0300 (0:00:00.618)       0:00:06.086 ************ 

TASK [bootstrap-os : Check http::proxy in apt configuration files] *************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:47:57 +0300 (0:00:00.629)       0:00:06.715 ************ 
Среда 19 июня 2024  15:47:57 +0300 (0:00:00.108)       0:00:06.823 ************ 

TASK [bootstrap-os : Check https::proxy in apt configuration files] ************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:47:57 +0300 (0:00:00.640)       0:00:07.464 ************ 
Среда 19 июня 2024  15:47:57 +0300 (0:00:00.176)       0:00:07.641 ************ 
Среда 19 июня 2024  15:47:58 +0300 (0:00:00.099)       0:00:07.740 ************ 
Среда 19 июня 2024  15:47:58 +0300 (0:00:00.150)       0:00:07.891 ************ 

TASK [bootstrap-os : Create remote_tmp for it is used by another module] *******************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:48:09 +0300 (0:00:10.768)       0:00:18.660 ************ 

TASK [bootstrap-os : Gather facts] *********************************************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:48:26 +0300 (0:00:17.011)       0:00:35.672 ************ 

TASK [bootstrap-os : Assign inventory name to unconfigured hostnames (non-CoreOS, non-Flatcar, Suse and ClearLinux, non-Fedora)] ***********************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:48:42 +0300 (0:00:16.565)       0:00:52.238 ************ 
Среда 19 июня 2024  15:48:42 +0300 (0:00:00.128)       0:00:52.366 ************ 

TASK [bootstrap-os : Ensure bash_completion.d folder exists] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]

PLAY [Gather facts] ************************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  15:48:53 +0300 (0:00:10.854)       0:01:03.220 ************ 

TASK [Gather minimal facts] ****************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:03 +0300 (0:00:09.733)       0:01:12.954 ************ 

TASK [Gather necessary facts (network)] ****************************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:11 +0300 (0:00:07.761)       0:01:20.715 ************ 

TASK [Gather necessary facts (hardware)] ***************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]

PLAY [Prepare for etcd install] ************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  15:49:18 +0300 (0:00:07.705)       0:01:28.421 ************ 
Среда 19 июня 2024  15:49:18 +0300 (0:00:00.214)       0:01:28.635 ************ 

TASK [kubespray-defaults : Create fallback_ips_base] ***************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4 -> localhost]
Среда 19 июня 2024  15:49:19 +0300 (0:00:00.095)       0:01:28.731 ************ 

TASK [kubespray-defaults : Set fallback_ips] ***********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:19 +0300 (0:00:00.146)       0:01:28.877 ************ 
Среда 19 июня 2024  15:49:19 +0300 (0:00:00.049)       0:01:28.927 ************ 
Среда 19 июня 2024  15:49:19 +0300 (0:00:00.144)       0:01:29.072 ************ 
Среда 19 июня 2024  15:49:19 +0300 (0:00:00.174)       0:01:29.247 ************ 

TASK [adduser : User | Create User Group] **************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:26 +0300 (0:00:06.810)       0:01:36.058 ************ 

TASK [adduser : User | Create User] ********************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:30 +0300 (0:00:04.375)       0:01:40.433 ************ 

TASK [kubernetes/preinstall : Check if /etc/fstab exists] **********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:34 +0300 (0:00:03.533)       0:01:43.966 ************ 

TASK [kubernetes/preinstall : Remove swapfile from /etc/fstab] *****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => (item=swap)
ok: [fhms56jfu94iaefdph12] => (item=swap)
ok: [fhm23nh49uft58qu43qa] => (item=swap)
ok: [fhmibjl39dmiukfvfsd4] => (item=swap)
ok: [fhm1q990n3ve0rlv7q48] => (item=swap)
ok: [fhm23nh49uft58qu43qa] => (item=none)
ok: [fhmav03g08hr6feh31au] => (item=none)
ok: [fhm1q990n3ve0rlv7q48] => (item=none)
ok: [fhms56jfu94iaefdph12] => (item=none)
ok: [fhmibjl39dmiukfvfsd4] => (item=none)
ok: [fhm4jldk6ls9qm2tclqm] => (item=swap)
ok: [fhm4jldk6ls9qm2tclqm] => (item=none)
Среда 19 июня 2024  15:49:42 +0300 (0:00:08.212)       0:01:52.178 ************ 

TASK [kubernetes/preinstall : Mask swap.target (persist swapoff)] **************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  15:49:52 +0300 (0:00:10.143)       0:02:02.321 ************ 

TASK [kubernetes/preinstall : Disable swap] ************************************************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhmav03g08hr6feh31au]
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:49:57 +0300 (0:00:04.475)       0:02:06.797 ************ 
Среда 19 июня 2024  15:49:57 +0300 (0:00:00.113)       0:02:06.911 ************ 

TASK [kubernetes/preinstall : Check resolvconf] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:01 +0300 (0:00:03.974)       0:02:10.886 ************ 

TASK [kubernetes/preinstall : Check existence of /etc/resolvconf/resolv.conf.d] ************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:05 +0300 (0:00:04.431)       0:02:15.318 ************ 

TASK [kubernetes/preinstall : Check status of /etc/resolv.conf] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:10 +0300 (0:00:04.363)       0:02:19.681 ************ 

TASK [kubernetes/preinstall : Get content of /etc/resolv.conf] *****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:14 +0300 (0:00:04.811)       0:02:24.493 ************ 

TASK [kubernetes/preinstall : Get currently configured nameservers] ************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:15 +0300 (0:00:00.222)       0:02:24.715 ************ 

TASK [kubernetes/preinstall : Stop if /etc/resolv.conf not configured nameservers] *********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:15 +0300 (0:00:00.154)       0:02:24.870 ************ 

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***********************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:18 +0300 (0:00:03.465)       0:02:28.335 ************ 

TASK [kubernetes/preinstall : Check systemd-resolved] **************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:22 +0300 (0:00:04.200)       0:02:32.536 ************ 

TASK [kubernetes/preinstall : Set default dns if remove_default_searchdomains is false] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:23 +0300 (0:00:00.170)       0:02:32.707 ************ 

TASK [kubernetes/preinstall : Set dns facts] ***********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:23 +0300 (0:00:00.155)       0:02:32.862 ************ 

TASK [kubernetes/preinstall : Check if kubelet is configured] ******************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:27 +0300 (0:00:04.401)       0:02:37.264 ************ 

TASK [kubernetes/preinstall : Check if early DNS configuration stage] **********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:27 +0300 (0:00:00.180)       0:02:37.445 ************ 

TASK [kubernetes/preinstall : Target resolv.conf files] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:28 +0300 (0:00:00.255)       0:02:37.700 ************ 
Среда 19 июня 2024  15:50:28 +0300 (0:00:00.113)       0:02:37.813 ************ 

TASK [kubernetes/preinstall : Check if /etc/dhclient.conf exists] **************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:31 +0300 (0:00:03.395)       0:02:41.209 ************ 
Среда 19 июня 2024  15:50:31 +0300 (0:00:00.110)       0:02:41.319 ************ 

TASK [kubernetes/preinstall : Check if /etc/dhcp/dhclient.conf exists] *********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:34 +0300 (0:00:03.205)       0:02:44.525 ************ 

TASK [kubernetes/preinstall : Target dhclient conf file for /etc/dhcp/dhclient.conf] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:35 +0300 (0:00:00.305)       0:02:44.831 ************ 
Среда 19 июня 2024  15:50:35 +0300 (0:00:00.117)       0:02:44.949 ************ 

TASK [kubernetes/preinstall : Target dhclient hook file for Debian family] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:35 +0300 (0:00:00.152)       0:02:45.101 ************ 

TASK [kubernetes/preinstall : Generate search domains to resolvconf] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:35 +0300 (0:00:00.168)       0:02:45.270 ************ 

TASK [kubernetes/preinstall : Pick coredns cluster IP or default resolver] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:35 +0300 (0:00:00.218)       0:02:45.488 ************ 

TASK [kubernetes/preinstall : Generate nameservers for resolvconf, including cluster DNS] **************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:36 +0300 (0:00:00.174)       0:02:45.663 ************ 
Среда 19 июня 2024  15:50:36 +0300 (0:00:00.182)       0:02:45.846 ************ 
Среда 19 июня 2024  15:50:36 +0300 (0:00:00.108)       0:02:45.954 ************ 

TASK [kubernetes/preinstall : Check /usr readonly] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:38 +0300 (0:00:02.558)       0:02:48.513 ************ 
Среда 19 июня 2024  15:50:38 +0300 (0:00:00.128)       0:02:48.642 ************ 

TASK [kubernetes/preinstall : Stop if either kube_control_plane or kube_node group is empty] ***********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.050)       0:02:48.692 ************ 

TASK [kubernetes/preinstall : Stop if etcd group is empty in external etcd mode] ***********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.052)       0:02:48.745 ************ 

TASK [kubernetes/preinstall : Stop if non systemd OS type] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.230)       0:02:48.975 ************ 

TASK [kubernetes/preinstall : Stop if the os does not support] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.174)       0:02:49.150 ************ 

TASK [kubernetes/preinstall : Stop if unknown network plugin] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.155)       0:02:49.306 ************ 

TASK [kubernetes/preinstall : Stop if unsupported version of Kubernetes] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.170)       0:02:49.477 ************ 

TASK [kubernetes/preinstall : Stop if known booleans are set as strings (Use JSON format on CLI: -e "{'key': true }")] *********************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'download_run_once', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "download_run_once",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'deploy_netchecker', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "deploy_netchecker",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'download_always_pull', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "download_always_pull",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'helm_enabled', 'value': True}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "helm_enabled",
        "value": true
    },
    "msg": "All assertions passed"
}
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'openstack_lbaas_enabled', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "openstack_lbaas_enabled",
        "value": false
    },
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:39 +0300 (0:00:00.120)       0:02:49.598 ************ 

TASK [kubernetes/preinstall : Stop if even number of etcd hosts] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:40 +0300 (0:00:00.121)       0:02:49.719 ************ 

TASK [kubernetes/preinstall : Stop if memory is too small for masters] *********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:40 +0300 (0:00:00.196)       0:02:49.916 ************ 

TASK [kubernetes/preinstall : Stop if memory is too small for nodes] ***********************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:40 +0300 (0:00:00.147)       0:02:50.064 ************ 

TASK [kubernetes/preinstall : Stop if cgroups are not enabled on nodes] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:50:45 +0300 (0:00:04.642)       0:02:54.706 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.125)       0:02:54.832 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.114)       0:02:54.946 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.118)       0:02:55.065 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.194)       0:02:55.259 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.108)       0:02:55.367 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.130)       0:02:55.498 ************ 
Среда 19 июня 2024  15:50:45 +0300 (0:00:00.131)       0:02:55.630 ************ 

TASK [kubernetes/preinstall : Stop if bad hostname] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.148)       0:02:55.778 ************ 
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.203)       0:02:55.982 ************ 

TASK [kubernetes/preinstall : Check that kube_service_addresses is a network range] ********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.082)       0:02:56.065 ************ 

TASK [kubernetes/preinstall : Check that kube_pods_subnet is a network range] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.084)       0:02:56.149 ************ 

TASK [kubernetes/preinstall : Check that kube_pods_subnet does not collide with kube_service_addresses] ************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.087)       0:02:56.237 ************ 
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.028)       0:02:56.265 ************ 

TASK [kubernetes/preinstall : Stop if unknown dns mode] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.051)       0:02:56.317 ************ 

TASK [kubernetes/preinstall : Stop if unknown kube proxy mode] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.048)       0:02:56.366 ************ 

TASK [kubernetes/preinstall : Stop if unknown cert_management] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.055)       0:02:56.421 ************ 

TASK [kubernetes/preinstall : Stop if unknown resolvconf_mode] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.061)       0:02:56.483 ************ 

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host, docker or kubeadm] *************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:46 +0300 (0:00:00.138)       0:02:56.622 ************ 

TASK [kubernetes/preinstall : Stop if container manager is not docker, crio or containerd] *************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.051)       0:02:56.673 ************ 

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host or kubeadm when container_manager != docker] ************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.116)       0:02:56.790 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.039)       0:02:56.830 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.029)       0:02:56.859 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.178)       0:02:57.038 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.112)       0:02:57.150 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.106)       0:02:57.257 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.107)       0:02:57.364 ************ 

TASK [kubernetes/preinstall : Ensure minimum containerd version] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.057)       0:02:57.422 ************ 
Среда 19 июня 2024  15:50:47 +0300 (0:00:00.131)       0:02:57.553 ************ 
Среда 19 июня 2024  15:50:48 +0300 (0:00:00.180)       0:02:57.734 ************ 
Среда 19 июня 2024  15:50:48 +0300 (0:00:00.123)       0:02:57.857 ************ 

TASK [kubernetes/preinstall : Verify that the packages list structure is valid] ************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  15:50:48 +0300 (0:00:00.260)       0:02:58.118 ************ 

TASK [kubernetes/preinstall : Verify that the packages list is sorted] *********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:50:48 +0300 (0:00:00.200)       0:02:58.319 ************ 

TASK [kubernetes/preinstall : Create kubernetes directories] *******************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=/etc/kubernetes)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/kubernetes)
ok: [fhmav03g08hr6feh31au] => (item=/etc/kubernetes)
ok: [fhms56jfu94iaefdph12] => (item=/etc/kubernetes)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/kubernetes)
ok: [fhm23nh49uft58qu43qa] => (item=/etc/kubernetes/manifests)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/kubernetes/manifests)
ok: [fhmav03g08hr6feh31au] => (item=/etc/kubernetes/manifests)
ok: [fhms56jfu94iaefdph12] => (item=/etc/kubernetes/manifests)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/kubernetes/manifests)
ok: [fhmibjl39dmiukfvfsd4] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhm23nh49uft58qu43qa] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhmav03g08hr6feh31au] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhms56jfu94iaefdph12] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhm1q990n3ve0rlv7q48] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhmibjl39dmiukfvfsd4] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
ok: [fhm23nh49uft58qu43qa] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
ok: [fhmav03g08hr6feh31au] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
ok: [fhms56jfu94iaefdph12] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/kubernetes)
ok: [fhm1q990n3ve0rlv7q48] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/kubernetes/manifests)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/usr/local/bin/kubernetes-scripts)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
Среда 19 июня 2024  15:51:01 +0300 (0:00:13.335)       0:03:11.655 ************ 

TASK [kubernetes/preinstall : Create other directories of root owner] **********************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => (item=/etc/kubernetes/ssl)
ok: [fhm23nh49uft58qu43qa] => (item=/etc/kubernetes/ssl)
ok: [fhms56jfu94iaefdph12] => (item=/etc/kubernetes/ssl)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/kubernetes/ssl)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/kubernetes/ssl)
ok: [fhmav03g08hr6feh31au] => (item=/usr/local/bin)
ok: [fhm23nh49uft58qu43qa] => (item=/usr/local/bin)
ok: [fhms56jfu94iaefdph12] => (item=/usr/local/bin)
ok: [fhmibjl39dmiukfvfsd4] => (item=/usr/local/bin)
ok: [fhm1q990n3ve0rlv7q48] => (item=/usr/local/bin)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/kubernetes/ssl)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/usr/local/bin)
Среда 19 июня 2024  15:51:08 +0300 (0:00:06.517)       0:03:18.172 ************ 

TASK [kubernetes/preinstall : Check if kubernetes kubeadm compat cert dir exists] **********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:51:13 +0300 (0:00:04.507)       0:03:22.679 ************ 
Среда 19 июня 2024  15:51:13 +0300 (0:00:00.117)       0:03:22.797 ************ 

TASK [kubernetes/preinstall : Create cni directories] **************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=/etc/cni/net.d)
ok: [fhmav03g08hr6feh31au] => (item=/etc/cni/net.d)
ok: [fhms56jfu94iaefdph12] => (item=/etc/cni/net.d)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/cni/net.d)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/cni/net.d)
ok: [fhm23nh49uft58qu43qa] => (item=/opt/cni/bin)
ok: [fhmav03g08hr6feh31au] => (item=/opt/cni/bin)
ok: [fhms56jfu94iaefdph12] => (item=/opt/cni/bin)
ok: [fhmibjl39dmiukfvfsd4] => (item=/opt/cni/bin)
ok: [fhm1q990n3ve0rlv7q48] => (item=/opt/cni/bin)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/cni/net.d)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/opt/cni/bin)
Среда 19 июня 2024  15:51:21 +0300 (0:00:08.596)       0:03:31.394 ************ 

TASK [kubernetes/preinstall : Create calico cni directories] *******************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=/var/lib/calico)
ok: [fhms56jfu94iaefdph12] => (item=/var/lib/calico)
ok: [fhm1q990n3ve0rlv7q48] => (item=/var/lib/calico)
ok: [fhmibjl39dmiukfvfsd4] => (item=/var/lib/calico)
ok: [fhmav03g08hr6feh31au] => (item=/var/lib/calico)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/var/lib/calico)
Среда 19 июня 2024  15:51:25 +0300 (0:00:03.268)       0:03:34.662 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.225)       0:03:34.887 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.110)       0:03:34.998 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.110)       0:03:35.109 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.161)       0:03:35.271 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.158)       0:03:35.429 ************ 
Среда 19 июня 2024  15:51:25 +0300 (0:00:00.196)       0:03:35.626 ************ 
Среда 19 июня 2024  15:51:26 +0300 (0:00:00.117)       0:03:35.743 ************ 

TASK [kubernetes/preinstall : Create systemd-resolved drop-in directory] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:51:29 +0300 (0:00:03.311)       0:03:39.055 ************ 

TASK [kubernetes/preinstall : Write Kubespray DNS settings to systemd-resolved] ************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:51:38 +0300 (0:00:09.215)       0:03:48.270 ************ 
Среда 19 июня 2024  15:51:38 +0300 (0:00:00.119)       0:03:48.389 ************ 
Среда 19 июня 2024  15:51:38 +0300 (0:00:00.191)       0:03:48.581 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.123)       0:03:48.705 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.112)       0:03:48.817 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.115)       0:03:48.933 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.106)       0:03:49.039 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.107)       0:03:49.147 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.182)       0:03:49.329 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.119)       0:03:49.448 ************ 
Среда 19 июня 2024  15:51:39 +0300 (0:00:00.123)       0:03:49.572 ************ 

TASK [kubernetes/preinstall : Update package management cache (APT)] ***********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:51:50 +0300 (0:00:10.870)       0:04:00.442 ************ 
Среда 19 июня 2024  15:51:50 +0300 (0:00:00.135)       0:04:00.577 ************ 
Среда 19 июня 2024  15:51:51 +0300 (0:00:00.185)       0:04:00.763 ************ 

TASK [kubernetes/preinstall : Install packages requirements] *******************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:51:57 +0300 (0:00:06.258)       0:04:07.022 ************ 
Среда 19 июня 2024  15:51:57 +0300 (0:00:00.117)       0:04:07.139 ************ 
Среда 19 июня 2024  15:51:57 +0300 (0:00:00.113)       0:04:07.253 ************ 
Среда 19 июня 2024  15:51:57 +0300 (0:00:00.114)       0:04:07.368 ************ 

TASK [kubernetes/preinstall : Clean previously used sysctl file locations] *****************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=ipv4-ip_forward.conf)
ok: [fhms56jfu94iaefdph12] => (item=ipv4-ip_forward.conf)
ok: [fhmibjl39dmiukfvfsd4] => (item=ipv4-ip_forward.conf)
ok: [fhm1q990n3ve0rlv7q48] => (item=ipv4-ip_forward.conf)
ok: [fhmav03g08hr6feh31au] => (item=ipv4-ip_forward.conf)
ok: [fhm23nh49uft58qu43qa] => (item=bridge-nf-call.conf)
ok: [fhms56jfu94iaefdph12] => (item=bridge-nf-call.conf)
ok: [fhmibjl39dmiukfvfsd4] => (item=bridge-nf-call.conf)
ok: [fhm1q990n3ve0rlv7q48] => (item=bridge-nf-call.conf)
ok: [fhmav03g08hr6feh31au] => (item=bridge-nf-call.conf)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ipv4-ip_forward.conf)
ok: [fhm4jldk6ls9qm2tclqm] => (item=bridge-nf-call.conf)
Среда 19 июня 2024  15:52:03 +0300 (0:00:06.225)       0:04:13.593 ************ 

TASK [kubernetes/preinstall : Stat sysctl file configuration] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:06 +0300 (0:00:02.870)       0:04:16.464 ************ 

TASK [kubernetes/preinstall : Change sysctl file path to link source if linked] ************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:06 +0300 (0:00:00.186)       0:04:16.650 ************ 

TASK [kubernetes/preinstall : Make sure sysctl file path folder exists] ********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:09 +0300 (0:00:02.627)       0:04:19.278 ************ 

TASK [kubernetes/preinstall : Enable ip forwarding] ****************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:12 +0300 (0:00:02.665)       0:04:21.944 ************ 
Среда 19 июня 2024  15:52:12 +0300 (0:00:00.217)       0:04:22.161 ************ 

TASK [kubernetes/preinstall : Check if we need to set fs.may_detach_mounts] ****************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:14 +0300 (0:00:02.376)       0:04:24.538 ************ 
Среда 19 июня 2024  15:52:15 +0300 (0:00:00.143)       0:04:24.681 ************ 

TASK [kubernetes/preinstall : Ensure kubelet expected parameters are set] ******************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhmav03g08hr6feh31au] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhmav03g08hr6feh31au] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhmav03g08hr6feh31au] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhmav03g08hr6feh31au] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhmav03g08hr6feh31au] => (item={'name': 'vm.panic_on_oom', 'value': 0})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhm23nh49uft58qu43qa] => (item={'name': 'vm.panic_on_oom', 'value': 0})
ok: [fhms56jfu94iaefdph12] => (item={'name': 'vm.panic_on_oom', 'value': 0})
ok: [fhmibjl39dmiukfvfsd4] => (item={'name': 'vm.panic_on_oom', 'value': 0})
ok: [fhm1q990n3ve0rlv7q48] => (item={'name': 'vm.panic_on_oom', 'value': 0})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'kernel.panic', 'value': 10})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'vm.overcommit_memory', 'value': 1})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'name': 'vm.panic_on_oom', 'value': 0})
Среда 19 июня 2024  15:52:29 +0300 (0:00:14.515)       0:04:39.196 ************ 

TASK [kubernetes/preinstall : Check dummy module] ******************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:32 +0300 (0:00:03.128)       0:04:42.325 ************ 
Среда 19 июня 2024  15:52:32 +0300 (0:00:00.210)       0:04:42.536 ************ 

TASK [kubernetes/preinstall : Disable fapolicyd service] ***********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:37 +0300 (0:00:04.808)       0:04:47.345 ************ 
Среда 19 июня 2024  15:52:37 +0300 (0:00:00.139)       0:04:47.484 ************ 
Среда 19 июня 2024  15:52:37 +0300 (0:00:00.124)       0:04:47.609 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.111)       0:04:47.720 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.186)       0:04:47.907 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.114)       0:04:48.021 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.112)       0:04:48.133 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.116)       0:04:48.250 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.115)       0:04:48.365 ************ 
Среда 19 июня 2024  15:52:38 +0300 (0:00:00.208)       0:04:48.574 ************ 

TASK [kubernetes/preinstall : Hosts | create hosts list from inventory] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4 -> localhost]
Среда 19 июня 2024  15:52:39 +0300 (0:00:00.415)       0:04:48.989 ************ 

TASK [kubernetes/preinstall : Hosts | populate inventory into hosts file] ******************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:42 +0300 (0:00:02.789)       0:04:51.778 ************ 
Среда 19 июня 2024  15:52:42 +0300 (0:00:00.130)       0:04:51.909 ************ 

TASK [kubernetes/preinstall : Hosts | Retrieve hosts file content] *************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:52:45 +0300 (0:00:03.064)       0:04:54.974 ************ 

TASK [kubernetes/preinstall : Hosts | Extract existing entries for localhost from hosts file] **********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhm23nh49uft58qu43qa] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhmibjl39dmiukfvfsd4] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
ok: [fhm23nh49uft58qu43qa] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
ok: [fhms56jfu94iaefdph12] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhmav03g08hr6feh31au] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhms56jfu94iaefdph12] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
ok: [fhm1q990n3ve0rlv7q48] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhmav03g08hr6feh31au] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
ok: [fhm1q990n3ve0rlv7q48] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
ok: [fhm4jldk6ls9qm2tclqm] => (item=127.0.0.1 localhost.localdomain localhost)
ok: [fhm4jldk6ls9qm2tclqm] => (item=::1 ip6-localhost localhost6 localhost6.localdomain ip6-loopback)
Среда 19 июня 2024  15:52:45 +0300 (0:00:00.401)       0:04:55.375 ************ 

TASK [kubernetes/preinstall : Hosts | Update target hosts file entries dict with required entries] *****************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhms56jfu94iaefdph12] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhms56jfu94iaefdph12] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhmav03g08hr6feh31au] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhmav03g08hr6feh31au] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
Среда 19 июня 2024  15:52:46 +0300 (0:00:00.290)       0:04:55.665 ************ 

TASK [kubernetes/preinstall : Hosts | Update (if necessary) hosts file] ********************************************************************************************************************************************************************
changed: [fhmav03g08hr6feh31au] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhms56jfu94iaefdph12] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhm1q990n3ve0rlv7q48] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhm23nh49uft58qu43qa] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhmibjl39dmiukfvfsd4] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhmav03g08hr6feh31au] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
changed: [fhm23nh49uft58qu43qa] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
changed: [fhms56jfu94iaefdph12] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
changed: [fhmibjl39dmiukfvfsd4] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
changed: [fhm1q990n3ve0rlv7q48] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
changed: [fhm4jldk6ls9qm2tclqm] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [fhm4jldk6ls9qm2tclqm] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
Среда 19 июня 2024  15:52:55 +0300 (0:00:09.309)       0:05:04.975 ************ 

TASK [kubernetes/preinstall : Update facts] ************************************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:05 +0300 (0:00:09.919)       0:05:14.894 ************ 

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] ***************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:11 +0300 (0:00:06.245)       0:05:21.140 ************ 

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***********************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:30 +0300 (0:00:18.556)       0:05:39.697 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.202)       0:05:39.899 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.110)       0:05:40.010 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.110)       0:05:40.120 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.015)       0:05:40.136 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.015)       0:05:40.151 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.017)       0:05:40.169 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.019)       0:05:40.188 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.019)       0:05:40.208 ************ 
Среда 19 июня 2024  15:53:30 +0300 (0:00:00.016)       0:05:40.224 ************ 

TASK [kubernetes/preinstall : Check if we are running inside a Azure VM] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:38 +0300 (0:00:07.654)       0:05:47.879 ************ 
Среда 19 июня 2024  15:53:38 +0300 (0:00:00.125)       0:05:48.005 ************ 
Среда 19 июня 2024  15:53:38 +0300 (0:00:00.114)       0:05:48.119 ************ 
Среда 19 июня 2024  15:53:38 +0300 (0:00:00.116)       0:05:48.236 ************ 
Среда 19 июня 2024  15:53:38 +0300 (0:00:00.115)       0:05:48.352 ************ 
Среда 19 июня 2024  15:53:38 +0300 (0:00:00.202)       0:05:48.554 ************ 
Среда 19 июня 2024  15:53:39 +0300 (0:00:00.120)       0:05:48.675 ************ 
Среда 19 июня 2024  15:53:39 +0300 (0:00:00.110)       0:05:48.786 ************ 

TASK [Run calico checks] *******************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  15:53:39 +0300 (0:00:00.682)       0:05:49.469 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] **************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:39 +0300 (0:00:00.062)       0:05:49.531 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:39 +0300 (0:00:00.071)       0:05:49.602 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:40 +0300 (0:00:00.061)       0:05:49.663 ************ 
Среда 19 июня 2024  15:53:40 +0300 (0:00:00.041)       0:05:49.704 ************ 

TASK [network_plugin/calico : Stop if supported Calico versions] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:40 +0300 (0:00:00.059)       0:05:49.764 ************ 

TASK [network_plugin/calico : Check if calicoctl.sh exists] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  15:53:42 +0300 (0:00:02.730)       0:05:52.494 ************ 
Среда 19 июня 2024  15:53:42 +0300 (0:00:00.048)       0:05:52.543 ************ 
Среда 19 июня 2024  15:53:42 +0300 (0:00:00.040)       0:05:52.584 ************ 
Среда 19 июня 2024  15:53:42 +0300 (0:00:00.040)       0:05:52.625 ************ 
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.051)       0:05:52.677 ************ 
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.032)       0:05:52.709 ************ 

TASK [network_plugin/calico : Check vars defined correctly] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.061)       0:05:52.771 ************ 

TASK [network_plugin/calico : Check calico network backend defined correctly] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.057)       0:05:52.829 ************ 

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.058)       0:05:52.887 ************ 
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.036)       0:05:52.924 ************ 

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  15:53:43 +0300 (0:00:00.060)       0:05:52.985 ************ 

TASK [network_plugin/calico : Get Calico default-pool configuration] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  15:53:45 +0300 (0:00:02.455)       0:05:55.440 ************ 
Среда 19 июня 2024  15:53:45 +0300 (0:00:00.048)       0:05:55.488 ************ 
Среда 19 июня 2024  15:53:45 +0300 (0:00:00.043)       0:05:55.532 ************ 
Среда 19 июня 2024  15:53:45 +0300 (0:00:00.039)       0:05:55.572 ************ 
Среда 19 июня 2024  15:53:45 +0300 (0:00:00.041)       0:05:55.614 ************ 
Среда 19 июня 2024  15:53:46 +0300 (0:00:00.303)       0:05:55.917 ************ 

TASK [container-engine/validate-container-engine : Validate-container-engine | check if fedora coreos] *************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:51 +0300 (0:00:04.853)       0:06:00.771 ************ 

TASK [container-engine/validate-container-engine : Validate-container-engine | set is_ostree] **********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:51 +0300 (0:00:00.163)       0:06:00.935 ************ 

TASK [container-engine/validate-container-engine : Ensure kubelet systemd unit exists] *****************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:53:56 +0300 (0:00:05.227)       0:06:06.163 ************ 

TASK [container-engine/validate-container-engine : Populate service facts] *****************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:05 +0300 (0:00:09.301)       0:06:15.464 ************ 

TASK [container-engine/validate-container-engine : Check if containerd is installed] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:09 +0300 (0:00:03.702)       0:06:19.167 ************ 

TASK [container-engine/validate-container-engine : Check if docker is installed] ***********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:13 +0300 (0:00:03.696)       0:06:22.864 ************ 

TASK [container-engine/validate-container-engine : Check if crio is installed] *************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:15 +0300 (0:00:02.529)       0:06:25.393 ************ 
Среда 19 июня 2024  15:54:15 +0300 (0:00:00.128)       0:06:25.522 ************ 
Среда 19 июня 2024  15:54:15 +0300 (0:00:00.118)       0:06:25.640 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.113)       0:06:25.753 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.111)       0:06:25.865 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.186)       0:06:26.051 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.187)       0:06:26.239 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.105)       0:06:26.344 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.119)       0:06:26.464 ************ 
Среда 19 июня 2024  15:54:16 +0300 (0:00:00.120)       0:06:26.584 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.111)       0:06:26.695 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.145)       0:06:26.841 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.146)       0:06:26.987 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.106)       0:06:27.094 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.110)       0:06:27.204 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.109)       0:06:27.313 ************ 
Среда 19 июня 2024  15:54:17 +0300 (0:00:00.234)       0:06:27.547 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.120)       0:06:27.668 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.109)       0:06:27.778 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.102)       0:06:27.880 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.183)       0:06:28.064 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.112)       0:06:28.177 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.103)       0:06:28.281 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.108)       0:06:28.389 ************ 
Среда 19 июня 2024  15:54:18 +0300 (0:00:00.122)       0:06:28.512 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.197)       0:06:28.709 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.113)       0:06:28.823 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.176)       0:06:29.000 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.109)       0:06:29.110 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.105)       0:06:29.215 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.101)       0:06:29.317 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.148)       0:06:29.465 ************ 
Среда 19 июня 2024  15:54:19 +0300 (0:00:00.124)       0:06:29.590 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.112)       0:06:29.702 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.103)       0:06:29.806 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.105)       0:06:29.911 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.127)       0:06:30.038 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.107)       0:06:30.146 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.105)       0:06:30.252 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.197)       0:06:30.449 ************ 
Среда 19 июня 2024  15:54:20 +0300 (0:00:00.119)       0:06:30.568 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.111)       0:06:30.680 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.177)       0:06:30.857 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.143)       0:06:31.001 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.106)       0:06:31.108 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.102)       0:06:31.211 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.105)       0:06:31.316 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.110)       0:06:31.427 ************ 
Среда 19 июня 2024  15:54:21 +0300 (0:00:00.117)       0:06:31.544 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.118)       0:06:31.663 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.101)       0:06:31.765 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.223)       0:06:31.988 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.141)       0:06:32.129 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.111)       0:06:32.241 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.110)       0:06:32.351 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.118)       0:06:32.470 ************ 
Среда 19 июня 2024  15:54:22 +0300 (0:00:00.115)       0:06:32.585 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.145)       0:06:32.730 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.111)       0:06:32.842 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.113)       0:06:32.955 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.109)       0:06:33.065 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.183)       0:06:33.248 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.114)       0:06:33.363 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.120)       0:06:33.484 ************ 
Среда 19 июня 2024  15:54:23 +0300 (0:00:00.119)       0:06:33.603 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.105)       0:06:33.709 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.120)       0:06:33.830 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.104)       0:06:33.935 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.139)       0:06:34.075 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.184)       0:06:34.259 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.110)       0:06:34.369 ************ 
Среда 19 июня 2024  15:54:24 +0300 (0:00:00.121)       0:06:34.490 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.189)       0:06:34.680 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.120)       0:06:34.801 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.112)       0:06:34.913 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.118)       0:06:35.032 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.144)       0:06:35.176 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.098)       0:06:35.275 ************ 
Среда 19 июня 2024  15:54:25 +0300 (0:00:00.102)       0:06:35.377 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:01.591)       0:06:36.968 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:00.100)       0:06:37.069 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:00.139)       0:06:37.209 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:00.101)       0:06:37.310 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:00.224)       0:06:37.534 ************ 
Среда 19 июня 2024  15:54:27 +0300 (0:00:00.114)       0:06:37.649 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.104)       0:06:37.754 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.101)       0:06:37.855 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.106)       0:06:37.962 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.104)       0:06:38.066 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.134)       0:06:38.201 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.137)       0:06:38.339 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.112)       0:06:38.452 ************ 
Среда 19 июня 2024  15:54:28 +0300 (0:00:00.118)       0:06:38.570 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.103)       0:06:38.674 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.179)       0:06:38.853 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.142)       0:06:38.996 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.096)       0:06:39.093 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.101)       0:06:39.194 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.101)       0:06:39.296 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.105)       0:06:39.401 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.113)       0:06:39.515 ************ 
Среда 19 июня 2024  15:54:29 +0300 (0:00:00.114)       0:06:39.629 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.102)       0:06:39.732 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.103)       0:06:39.836 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.103)       0:06:39.939 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.100)       0:06:40.039 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.174)       0:06:40.214 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.107)       0:06:40.322 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.133)       0:06:40.455 ************ 
Среда 19 июня 2024  15:54:30 +0300 (0:00:00.112)       0:06:40.568 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.101)       0:06:40.669 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.106)       0:06:40.776 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.110)       0:06:40.887 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.102)       0:06:40.989 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.101)       0:06:41.091 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.116)       0:06:41.207 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.107)       0:06:41.315 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.107)       0:06:41.422 ************ 
Среда 19 июня 2024  15:54:31 +0300 (0:00:00.157)       0:06:41.580 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.186)       0:06:41.767 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.101)       0:06:41.868 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.092)       0:06:41.960 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.098)       0:06:42.059 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.097)       0:06:42.156 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.111)       0:06:42.268 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.096)       0:06:42.365 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.111)       0:06:42.476 ************ 
Среда 19 июня 2024  15:54:32 +0300 (0:00:00.153)       0:06:42.630 ************ 

TASK [container-engine/containerd-common : Containerd-common | check if fedora coreos] *****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:35 +0300 (0:00:02.772)       0:06:45.402 ************ 

TASK [container-engine/containerd-common : Containerd-common | set is_ostree] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:35 +0300 (0:00:00.157)       0:06:45.559 ************ 

TASK [container-engine/containerd-common : Containerd-common | gather os specific variables] ***********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
ok: [fhmav03g08hr6feh31au] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
ok: [fhm1q990n3ve0rlv7q48] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
ok: [fhm4jldk6ls9qm2tclqm] => (item=kubernetes-prod/kubespray/roles/container-engine/containerd/vars/../vars/ubuntu.yml)
Среда 19 июня 2024  15:54:36 +0300 (0:00:00.282)       0:06:45.842 ************ 

TASK [container-engine/runc : Runc | check if fedora coreos] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:39 +0300 (0:00:02.849)       0:06:48.691 ************ 

TASK [container-engine/runc : Runc | set is_ostree] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:39 +0300 (0:00:00.173)       0:06:48.864 ************ 

TASK [container-engine/runc : Runc | Uninstall runc package managed by package manager] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:43 +0300 (0:00:04.554)       0:06:53.419 ************ 

TASK [container-engine/runc : Runc | Download runc binary] *********************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/container-engine/runc/tasks/../../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:54:43 +0300 (0:00:00.201)       0:06:53.620 ************ 

TASK [container-engine/runc : Prep_download | Set a few facts] *****************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:44 +0300 (0:00:00.817)       0:06:54.438 ************ 

TASK [container-engine/runc : Download_file | Show url of file to dowload] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
Среда 19 июня 2024  15:54:46 +0300 (0:00:01.504)       0:06:55.942 ************ 

TASK [container-engine/runc : Download_file | Set pathname of cached file] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:47 +0300 (0:00:01.544)       0:06:57.487 ************ 

TASK [container-engine/runc : Download_file | Create dest directory on node] ***************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:54:53 +0300 (0:00:05.647)       0:07:03.135 ************ 
Среда 19 июня 2024  15:54:53 +0300 (0:00:00.036)       0:07:03.171 ************ 
Среда 19 июня 2024  15:54:53 +0300 (0:00:00.040)       0:07:03.212 ************ 

TASK [container-engine/runc : Download_file | Download item] *******************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:06 +0300 (0:00:12.636)       0:07:15.849 ************ 
Среда 19 июня 2024  15:55:06 +0300 (0:00:00.121)       0:07:15.970 ************ 
Среда 19 июня 2024  15:55:06 +0300 (0:00:00.114)       0:07:16.085 ************ 
Среда 19 июня 2024  15:55:06 +0300 (0:00:00.193)       0:07:16.279 ************ 

TASK [container-engine/runc : Download_file | Extract file archives] ***********************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:55:06 +0300 (0:00:00.217)       0:07:16.496 ************ 
Среда 19 июня 2024  15:55:07 +0300 (0:00:00.853)       0:07:17.349 ************ 

TASK [container-engine/runc : Copy runc binary from download dir] **************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:18 +0300 (0:00:10.890)       0:07:28.240 ************ 

TASK [container-engine/runc : Runc | Remove orphaned binary] *******************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  15:55:25 +0300 (0:00:06.938)       0:07:35.179 ************ 

TASK [container-engine/crictl : Install crictl] ********************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/container-engine/crictl/tasks/crictl.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:55:25 +0300 (0:00:00.155)       0:07:35.334 ************ 

TASK [container-engine/crictl : Crictl | Download crictl] **********************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/container-engine/crictl/tasks/../../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:55:25 +0300 (0:00:00.190)       0:07:35.524 ************ 

TASK [container-engine/crictl : Prep_download | Set a few facts] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:26 +0300 (0:00:00.779)       0:07:36.304 ************ 

TASK [container-engine/crictl : Download_file | Show url of file to dowload] ***************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
Среда 19 июня 2024  15:55:28 +0300 (0:00:01.696)       0:07:38.000 ************ 

TASK [container-engine/crictl : Download_file | Set pathname of cached file] ***************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:30 +0300 (0:00:01.814)       0:07:39.815 ************ 

TASK [container-engine/crictl : Download_file | Create dest directory on node] *************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:38 +0300 (0:00:07.919)       0:07:47.734 ************ 
Среда 19 июня 2024  15:55:38 +0300 (0:00:00.043)       0:07:47.778 ************ 
Среда 19 июня 2024  15:55:38 +0300 (0:00:00.040)       0:07:47.818 ************ 

TASK [container-engine/crictl : Download_file | Download item] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:55:50 +0300 (0:00:11.984)       0:07:59.802 ************ 
Среда 19 июня 2024  15:55:50 +0300 (0:00:00.126)       0:07:59.929 ************ 
Среда 19 июня 2024  15:55:50 +0300 (0:00:00.112)       0:08:00.041 ************ 
Среда 19 июня 2024  15:55:50 +0300 (0:00:00.113)       0:08:00.155 ************ 

TASK [container-engine/crictl : Download_file | Extract file archives] *********************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:55:50 +0300 (0:00:00.183)       0:08:00.339 ************ 

TASK [container-engine/crictl : Extract_file | Unpacking archive] **************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:09 +0300 (0:00:18.880)       0:08:19.219 ************ 

TASK [container-engine/crictl : Install crictl config] *************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:22 +0300 (0:00:12.596)       0:08:31.816 ************ 

TASK [container-engine/crictl : Copy crictl binary from download dir] **********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:27 +0300 (0:00:05.167)       0:08:36.984 ************ 

TASK [container-engine/nerdctl : Nerdctl | Download nerdctl] *******************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/container-engine/nerdctl/tasks/../../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:56:27 +0300 (0:00:00.163)       0:08:37.147 ************ 

TASK [container-engine/nerdctl : Prep_download | Set a few facts] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:28 +0300 (0:00:00.995)       0:08:38.143 ************ 

TASK [container-engine/nerdctl : Download_file | Show url of file to dowload] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
Среда 19 июня 2024  15:56:30 +0300 (0:00:01.629)       0:08:39.773 ************ 

TASK [container-engine/nerdctl : Download_file | Set pathname of cached file] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:31 +0300 (0:00:01.716)       0:08:41.490 ************ 

TASK [container-engine/nerdctl : Download_file | Create dest directory on node] ************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:36 +0300 (0:00:04.879)       0:08:46.369 ************ 
Среда 19 июня 2024  15:56:36 +0300 (0:00:00.046)       0:08:46.416 ************ 
Среда 19 июня 2024  15:56:36 +0300 (0:00:00.056)       0:08:46.473 ************ 

TASK [container-engine/nerdctl : Download_file | Download item] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:56:49 +0300 (0:00:12.361)       0:08:58.834 ************ 
Среда 19 июня 2024  15:56:49 +0300 (0:00:00.103)       0:08:58.937 ************ 
Среда 19 июня 2024  15:56:49 +0300 (0:00:00.118)       0:08:59.055 ************ 
Среда 19 июня 2024  15:56:49 +0300 (0:00:00.106)       0:08:59.162 ************ 

TASK [container-engine/nerdctl : Download_file | Extract file archives] ********************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:56:49 +0300 (0:00:00.163)       0:08:59.326 ************ 

TASK [container-engine/nerdctl : Extract_file | Unpacking archive] *************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:03 +0300 (0:00:13.763)       0:09:13.089 ************ 

TASK [container-engine/nerdctl : Nerdctl | Copy nerdctl binary from download dir] **********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:07 +0300 (0:00:04.503)       0:09:17.593 ************ 

TASK [container-engine/nerdctl : Nerdctl | Create configuration dir] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:10 +0300 (0:00:02.807)       0:09:20.401 ************ 

TASK [container-engine/nerdctl : Nerdctl | Install nerdctl configuration] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:17 +0300 (0:00:06.550)       0:09:26.952 ************ 
Среда 19 июня 2024  15:57:17 +0300 (0:00:00.143)       0:09:27.095 ************ 

TASK [container-engine/containerd : Containerd | Remove any package manager controlled containerd package] *********************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:21 +0300 (0:00:03.690)       0:09:30.786 ************ 
Среда 19 июня 2024  15:57:21 +0300 (0:00:00.113)       0:09:30.900 ************ 

TASK [container-engine/containerd : Containerd | Remove containerd repository] *************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
ok: [fhms56jfu94iaefdph12] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
ok: [fhm1q990n3ve0rlv7q48] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
ok: [fhmibjl39dmiukfvfsd4] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
ok: [fhm23nh49uft58qu43qa] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
ok: [fhm4jldk6ls9qm2tclqm] => (item=deb https://download.docker.com/linux/ubuntu focal stable
)
Среда 19 июня 2024  15:57:25 +0300 (0:00:04.106)       0:09:35.007 ************ 

TASK [container-engine/containerd : Containerd | Download containerd] **********************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/container-engine/containerd/tasks/../../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:57:25 +0300 (0:00:00.167)       0:09:35.175 ************ 

TASK [container-engine/containerd : Prep_download | Set a few facts] ***********************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:26 +0300 (0:00:00.837)       0:09:36.012 ************ 

TASK [container-engine/containerd : Download_file | Show url of file to dowload] ***********************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
Среда 19 июня 2024  15:57:27 +0300 (0:00:01.554)       0:09:37.566 ************ 

TASK [container-engine/containerd : Download_file | Set pathname of cached file] ***********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:29 +0300 (0:00:01.524)       0:09:39.091 ************ 

TASK [container-engine/containerd : Download_file | Create dest directory on node] *********************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:34 +0300 (0:00:04.819)       0:09:43.910 ************ 
Среда 19 июня 2024  15:57:34 +0300 (0:00:00.038)       0:09:43.949 ************ 
Среда 19 июня 2024  15:57:34 +0300 (0:00:00.048)       0:09:43.997 ************ 

TASK [container-engine/containerd : Download_file | Download item] *************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:45 +0300 (0:00:10.939)       0:09:54.936 ************ 
Среда 19 июня 2024  15:57:45 +0300 (0:00:00.123)       0:09:55.059 ************ 
Среда 19 июня 2024  15:57:45 +0300 (0:00:00.204)       0:09:55.264 ************ 
Среда 19 июня 2024  15:57:45 +0300 (0:00:00.119)       0:09:55.383 ************ 

TASK [container-engine/containerd : Download_file | Extract file archives] *****************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  15:57:45 +0300 (0:00:00.210)       0:09:55.594 ************ 
Среда 19 июня 2024  15:57:46 +0300 (0:00:00.959)       0:09:56.554 ************ 

TASK [container-engine/containerd : Containerd | Unpack containerd archive] ****************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:57:59 +0300 (0:00:12.324)       0:10:08.878 ************ 

TASK [container-engine/containerd : Containerd | Remove orphaned binary] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=containerd)
ok: [fhm23nh49uft58qu43qa] => (item=containerd)
ok: [fhmav03g08hr6feh31au] => (item=containerd)
ok: [fhms56jfu94iaefdph12] => (item=containerd)
ok: [fhm1q990n3ve0rlv7q48] => (item=containerd)
ok: [fhmibjl39dmiukfvfsd4] => (item=containerd-shim)
ok: [fhm23nh49uft58qu43qa] => (item=containerd-shim)
ok: [fhmav03g08hr6feh31au] => (item=containerd-shim)
ok: [fhms56jfu94iaefdph12] => (item=containerd-shim)
ok: [fhm1q990n3ve0rlv7q48] => (item=containerd-shim)
ok: [fhmibjl39dmiukfvfsd4] => (item=containerd-shim-runc-v1)
ok: [fhm23nh49uft58qu43qa] => (item=containerd-shim-runc-v1)
ok: [fhmav03g08hr6feh31au] => (item=containerd-shim-runc-v1)
ok: [fhms56jfu94iaefdph12] => (item=containerd-shim-runc-v1)
ok: [fhm1q990n3ve0rlv7q48] => (item=containerd-shim-runc-v1)
ok: [fhmibjl39dmiukfvfsd4] => (item=containerd-shim-runc-v2)
ok: [fhm23nh49uft58qu43qa] => (item=containerd-shim-runc-v2)
ok: [fhmav03g08hr6feh31au] => (item=containerd-shim-runc-v2)
ok: [fhms56jfu94iaefdph12] => (item=containerd-shim-runc-v2)
ok: [fhm1q990n3ve0rlv7q48] => (item=containerd-shim-runc-v2)
ok: [fhmibjl39dmiukfvfsd4] => (item=ctr)
ok: [fhm23nh49uft58qu43qa] => (item=ctr)
ok: [fhmav03g08hr6feh31au] => (item=ctr)
ok: [fhms56jfu94iaefdph12] => (item=ctr)
ok: [fhm1q990n3ve0rlv7q48] => (item=ctr)
ok: [fhm4jldk6ls9qm2tclqm] => (item=containerd)
ok: [fhm4jldk6ls9qm2tclqm] => (item=containerd-shim)
ok: [fhm4jldk6ls9qm2tclqm] => (item=containerd-shim-runc-v1)
ok: [fhm4jldk6ls9qm2tclqm] => (item=containerd-shim-runc-v2)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ctr)
Среда 19 июня 2024  15:58:14 +0300 (0:00:14.944)       0:10:23.822 ************ 

TASK [container-engine/containerd : Containerd | Generate systemd service for containerd] **************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:58:21 +0300 (0:00:07.395)       0:10:31.218 ************ 

TASK [container-engine/containerd : Containerd | Ensure containerd directories exist] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhm23nh49uft58qu43qa] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhms56jfu94iaefdph12] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhmav03g08hr6feh31au] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/containerd)
ok: [fhm23nh49uft58qu43qa] => (item=/etc/containerd)
ok: [fhms56jfu94iaefdph12] => (item=/etc/containerd)
ok: [fhmav03g08hr6feh31au] => (item=/etc/containerd)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/containerd)
ok: [fhmibjl39dmiukfvfsd4] => (item=/var/lib/containerd)
ok: [fhm23nh49uft58qu43qa] => (item=/var/lib/containerd)
ok: [fhms56jfu94iaefdph12] => (item=/var/lib/containerd)
ok: [fhmav03g08hr6feh31au] => (item=/var/lib/containerd)
ok: [fhm1q990n3ve0rlv7q48] => (item=/var/lib/containerd)
ok: [fhmibjl39dmiukfvfsd4] => (item=/run/containerd)
ok: [fhm23nh49uft58qu43qa] => (item=/run/containerd)
ok: [fhms56jfu94iaefdph12] => (item=/run/containerd)
ok: [fhmav03g08hr6feh31au] => (item=/run/containerd)
ok: [fhm1q990n3ve0rlv7q48] => (item=/run/containerd)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/systemd/system/containerd.service.d)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/containerd)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/var/lib/containerd)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/run/containerd)
Среда 19 июня 2024  15:58:30 +0300 (0:00:08.659)       0:10:39.878 ************ 
Среда 19 июня 2024  15:58:30 +0300 (0:00:00.130)       0:10:40.008 ************ 

TASK [container-engine/containerd : Containerd | Generate default base_runtime_spec] *******************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:58:33 +0300 (0:00:02.902)       0:10:42.911 ************ 

TASK [container-engine/containerd : Containerd | Store generated default base_runtime_spec] ************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:58:33 +0300 (0:00:00.178)       0:10:43.090 ************ 

TASK [container-engine/containerd : Containerd | Write base_runtime_specs] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
ok: [fhm23nh49uft58qu43qa] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
ok: [fhms56jfu94iaefdph12] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
ok: [fhmav03g08hr6feh31au] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.1.0', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/sys/devices/virtual/powercap', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
Среда 19 июня 2024  15:58:40 +0300 (0:00:06.675)       0:10:49.765 ************ 

TASK [container-engine/containerd : Containerd | Copy containerd config file] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:58:49 +0300 (0:00:09.334)       0:10:59.100 ************ 

TASK [container-engine/containerd : Containerd | Create registry directories] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhms56jfu94iaefdph12] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhmav03g08hr6feh31au] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhm1q990n3ve0rlv7q48] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhm23nh49uft58qu43qa] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
Среда 19 июня 2024  15:59:08 +0300 (0:00:19.529)       0:11:18.629 ************ 

TASK [container-engine/containerd : Containerd | Write hosts.toml file] ********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhmibjl39dmiukfvfsd4] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhms56jfu94iaefdph12] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhmav03g08hr6feh31au] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhm1q990n3ve0rlv7q48] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'prefix': 'docker.io', 'mirrors': [{'host': 'https://registry-1.docker.io', 'capabilities': ['pull', 'resolve'], 'skip_verify': False}]})
Среда 19 июня 2024  15:59:15 +0300 (0:00:06.967)       0:11:25.597 ************ 
Среда 19 июня 2024  15:59:15 +0300 (0:00:00.021)       0:11:25.618 ************ 
Среда 19 июня 2024  15:59:15 +0300 (0:00:00.014)       0:11:25.632 ************ 
Среда 19 июня 2024  15:59:15 +0300 (0:00:00.017)       0:11:25.649 ************ 
Среда 19 июня 2024  15:59:16 +0300 (0:00:00.017)       0:11:25.667 ************ 
Среда 19 июня 2024  15:59:16 +0300 (0:00:00.016)       0:11:25.683 ************ 
Среда 19 июня 2024  15:59:16 +0300 (0:00:00.015)       0:11:25.699 ************ 

TASK [container-engine/containerd : Containerd | Ensure containerd is started and enabled] *************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:59:21 +0300 (0:00:05.042)       0:11:30.742 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.103)       0:11:30.845 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.101)       0:11:30.947 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.175)       0:11:31.122 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.115)       0:11:31.237 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.098)       0:11:31.336 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.201)       0:11:31.537 ************ 
Среда 19 июня 2024  15:59:21 +0300 (0:00:00.110)       0:11:31.647 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.100)       0:11:31.747 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.141)       0:11:31.889 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.097)       0:11:31.986 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.102)       0:11:32.088 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.155)       0:11:32.243 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.099)       0:11:32.342 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.114)       0:11:32.457 ************ 
Среда 19 июня 2024  15:59:22 +0300 (0:00:00.116)       0:11:32.573 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.104)       0:11:32.678 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.100)       0:11:32.778 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.198)       0:11:32.977 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.113)       0:11:33.091 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.100)       0:11:33.192 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.115)       0:11:33.307 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.106)       0:11:33.414 ************ 
Среда 19 июня 2024  15:59:23 +0300 (0:00:00.117)       0:11:33.531 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.134)       0:11:33.666 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.099)       0:11:33.765 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.120)       0:11:33.886 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.101)       0:11:33.987 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.014)       0:11:34.002 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.013)       0:11:34.015 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.017)       0:11:34.032 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.016)       0:11:34.049 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.016)       0:11:34.065 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.014)       0:11:34.080 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.094)       0:11:34.175 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.190)       0:11:34.366 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.120)       0:11:34.486 ************ 
Среда 19 июня 2024  15:59:24 +0300 (0:00:00.115)       0:11:34.602 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.103)       0:11:34.705 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.100)       0:11:34.806 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.101)       0:11:34.908 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.098)       0:11:35.006 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.103)       0:11:35.109 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.014)       0:11:35.124 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.013)       0:11:35.137 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.017)       0:11:35.154 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.017)       0:11:35.172 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.017)       0:11:35.189 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.016)       0:11:35.205 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.147)       0:11:35.352 ************ 
Среда 19 июня 2024  15:59:25 +0300 (0:00:00.119)       0:11:35.471 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.194)       0:11:35.666 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.123)       0:11:35.789 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.014)       0:11:35.804 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.013)       0:11:35.817 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.014)       0:11:35.832 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.017)       0:11:35.849 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.016)       0:11:35.866 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.087)       0:11:35.954 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.124)       0:11:36.078 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.037)       0:11:36.116 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.045)       0:11:36.162 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.112)       0:11:36.275 ************ 
Среда 19 июня 2024  15:59:26 +0300 (0:00:00.118)       0:11:36.393 ************ 

TASK [download : Prep_download | Register docker images info] ******************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:59:30 +0300 (0:00:03.941)       0:11:40.334 ************ 

TASK [download : Prep_download | Create staging directory on remote node] ******************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhmav03g08hr6feh31au]
changed: [fhms56jfu94iaefdph12]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  15:59:33 +0300 (0:00:02.687)       0:11:43.022 ************ 
Среда 19 июня 2024  15:59:33 +0300 (0:00:00.047)       0:11:43.069 ************ 

TASK [download : Download | Get kubeadm binary and list of required images] ****************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/prep_kubeadm_images.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  15:59:33 +0300 (0:00:00.151)       0:11:43.220 ************ 
Среда 19 июня 2024  15:59:33 +0300 (0:00:00.433)       0:11:43.654 ************ 

TASK [download : Prep_kubeadm_images | Download kubeadm binary] ****************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmibjl39dmiukfvfsd4
Среда 19 июня 2024  15:59:34 +0300 (0:00:00.573)       0:11:44.228 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:34 +0300 (0:00:00.426)       0:11:44.654 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
Среда 19 июня 2024  15:59:35 +0300 (0:00:00.832)       0:11:45.486 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:36 +0300 (0:00:00.970)       0:11:46.456 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:39 +0300 (0:00:02.769)       0:11:49.226 ************ 
Среда 19 июня 2024  15:59:39 +0300 (0:00:00.033)       0:11:49.259 ************ 
Среда 19 июня 2024  15:59:39 +0300 (0:00:00.036)       0:11:49.296 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:46 +0300 (0:00:06.718)       0:11:56.015 ************ 
Среда 19 июня 2024  15:59:46 +0300 (0:00:00.092)       0:11:56.108 ************ 
Среда 19 июня 2024  15:59:46 +0300 (0:00:00.086)       0:11:56.194 ************ 
Среда 19 июня 2024  15:59:46 +0300 (0:00:00.082)       0:11:56.276 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  15:59:46 +0300 (0:00:00.109)       0:11:56.386 ************ 
Среда 19 июня 2024  15:59:47 +0300 (0:00:00.486)       0:11:56.873 ************ 

TASK [download : Prep_kubeadm_images | Create kubeadm config] ******************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:51 +0300 (0:00:04.343)       0:12:01.216 ************ 

TASK [download : Prep_kubeadm_images | Copy kubeadm binary from download dir to system path] ***********************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:55 +0300 (0:00:03.715)       0:12:04.931 ************ 

TASK [download : Prep_kubeadm_images | Set kubeadm binary permissions] *********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  15:59:57 +0300 (0:00:01.755)       0:12:06.687 ************ 

TASK [download : Prep_kubeadm_images | Generate list of required images] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  15:59:58 +0300 (0:00:01.190)       0:12:07.877 ************ 

TASK [download : Prep_kubeadm_images | Parse list of images] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=registry.k8s.io/kube-apiserver:v1.29.5)
ok: [fhmibjl39dmiukfvfsd4] => (item=registry.k8s.io/kube-controller-manager:v1.29.5)
ok: [fhmibjl39dmiukfvfsd4] => (item=registry.k8s.io/kube-scheduler:v1.29.5)
ok: [fhmibjl39dmiukfvfsd4] => (item=registry.k8s.io/kube-proxy:v1.29.5)
Среда 19 июня 2024  15:59:58 +0300 (0:00:00.116)       0:12:07.993 ************ 

TASK [download : Prep_kubeadm_images | Convert list of images to dict for later use] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  15:59:58 +0300 (0:00:00.052)       0:12:08.046 ************ 

TASK [download : Download | Download files / images] ***************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa => (item={'key': 'etcd', 'value': {'container': False, 'file': True, 'enabled': True, 'version': 'v3.5.12', 'dest': '/tmp/releases/etcd-v3.5.12-linux-amd64.tar.gz', 'repo': 'quay.io/coreos/etcd', 'tag': 'v3.5.12', 'sha256': 'f2ff0cb43ce119f55a85012255609b61c64263baea83aa7c8e6846c0938adca5', 'url': 'https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['etcd']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'cni', 'value': {'enabled': True, 'file': True, 'version': 'v1.3.0', 'dest': '/tmp/releases/cni-plugins-linux-amd64-v1.3.0.tgz', 'sha256': '754a71ed60a4bd08726c3af705a7d55ee3df03122b12e389fdba4bea35d7dd7e', 'url': 'https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'kubeadm', 'value': {'enabled': True, 'file': True, 'version': 'v1.29.5', 'dest': '/tmp/releases/kubeadm-v1.29.5-amd64', 'sha256': 'e424dcdbe661314b6ca1fcc94726eb554bc3f4392b060b9626f9df8d7d44d42c', 'url': 'https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'kubelet', 'value': {'enabled': True, 'file': True, 'version': 'v1.29.5', 'dest': '/tmp/releases/kubelet-v1.29.5-amd64', 'sha256': '261dc3f3c384d138835fe91a02071c642af94abb0cca56ebc04719240440944c', 'url': 'https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa => (item={'key': 'kubectl', 'value': {'enabled': True, 'file': True, 'version': 'v1.29.5', 'dest': '/tmp/releases/kubectl-v1.29.5-amd64', 'sha256': '603c8681fc0d8609c851f9cc58bcf55eeb97e2934896e858d0232aa8d1138366', 'url': 'https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubectl', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'crictl', 'value': {'file': True, 'enabled': True, 'version': 'v1.29.0', 'dest': '/tmp/releases/crictl-v1.29.0-linux-amd64.tar.gz', 'sha256': 'd16a1ffb3938f5a19d5c8f45d363bd091ef89c0bc4d44ad16b933eede32fdcbb', 'url': 'https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'runc', 'value': {'file': True, 'enabled': True, 'version': 'v1.1.12', 'dest': '/tmp/releases/runc-v1.1.12.amd64', 'sha256': 'aadeef400b8f05645768c1476d1023f7875b78f52c7ff1967a6dbce236b8cbd8', 'url': 'https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'containerd', 'value': {'enabled': True, 'file': True, 'version': '1.7.16', 'dest': '/tmp/releases/containerd-1.7.16-linux-amd64.tar.gz', 'sha256': '4f4f2c3c7d14fd59a404961a3a3341303c2fdeeba0e78808c209f606e828f99c', 'url': 'https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'nerdctl', 'value': {'file': True, 'enabled': True, 'version': '1.7.4', 'dest': '/tmp/releases/nerdctl-1.7.4-linux-amd64.tar.gz', 'sha256': '71aee9d987b7fad0ff2ade50b038ad7e2356324edc02c54045960a3521b3e6a7', 'url': 'https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'calicoctl', 'value': {'enabled': True, 'file': True, 'version': 'v3.27.3', 'dest': '/tmp/releases/calicoctl-v3.27.3-amd64', 'sha256': 'e22b8bb41684f8ffb5143b50bf3b2ab76985604d774d397cfb6fb11d8a19f326', 'url': 'https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'calico_node', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/node', 'tag': 'v3.27.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'calico_cni', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/cni', 'tag': 'v3.27.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'calico_flexvol', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/pod2daemon-flexvol', 'tag': 'v3.27.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'calico_policy', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/kube-controllers', 'tag': 'v3.27.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa => (item={'key': 'calico_crds', 'value': {'file': True, 'enabled': True, 'version': 'v3.27.3', 'dest': '/tmp/releases/calico-v3.27.3-kdd-crds/v3.27.3.tar.gz', 'sha256': 'd11a32919bff389f642af5df8180ad3cec586030decd35adb2a7d4a8aa3b298e', 'url': 'https://github.com/projectcalico/calico/archive/v3.27.3.tar.gz', 'unarchive': True, 'unarchive_extra_opts': ['--strip=3', '--wildcards', '*/libcalico-go/config/crd/'], 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'pod_infra', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/pause', 'tag': '3.9', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'coredns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/coredns/coredns', 'tag': 'v1.11.1', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhmav03g08hr6feh31au, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'nodelocaldns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/dns/k8s-dns-node-cache', 'tag': '1.22.28', 'sha256': '', 'groups': ['k8s_cluster']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa => (item={'key': 'dnsautoscaler', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/cpa/cluster-proportional-autoscaler', 'tag': 'v1.8.8', 'sha256': '', 'groups': ['kube_control_plane']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhms56jfu94iaefdph12, fhm23nh49uft58qu43qa => (item={'key': 'helm', 'value': {'enabled': True, 'file': True, 'version': 'v3.14.2', 'dest': '/tmp/releases/helm-v3.14.2/helm-v3.14.2-linux-amd64.tar.gz', 'sha256': '0885a501d586c1e949e9b113bf3fb3290b0bbf74db9444a1d8c2723a143006a5', 'url': 'https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: kubernetes-prod/kubespray/roles/download/tasks/download_container.yml for fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm => (item={'key': 'nginx', 'value': {'enabled': True, 'container': True, 'repo': 'docker.io/library/nginx', 'tag': '1.25.2-alpine', 'sha256': '', 'groups': ['kube_node']}})
Среда 19 июня 2024  16:00:01 +0300 (0:00:02.944)       0:12:10.990 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:01 +0300 (0:00:00.086)       0:12:11.076 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:00:01 +0300 (0:00:00.084)       0:12:11.161 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:01 +0300 (0:00:00.098)       0:12:11.259 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:00:03 +0300 (0:00:01.670)       0:12:12.930 ************ 
Среда 19 июня 2024  16:00:03 +0300 (0:00:00.036)       0:12:12.966 ************ 
Среда 19 июня 2024  16:00:03 +0300 (0:00:00.034)       0:12:13.000 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:05 +0300 (0:00:02.224)       0:12:15.225 ************ 
Среда 19 июня 2024  16:00:05 +0300 (0:00:00.085)       0:12:15.310 ************ 
Среда 19 июня 2024  16:00:05 +0300 (0:00:00.077)       0:12:15.388 ************ 
Среда 19 июня 2024  16:00:05 +0300 (0:00:00.171)       0:12:15.559 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:00:06 +0300 (0:00:00.122)       0:12:15.681 ************ 

TASK [download : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:11 +0300 (0:00:05.173)       0:12:20.855 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:11 +0300 (0:00:00.165)       0:12:21.020 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
}
Среда 19 июня 2024  16:00:11 +0300 (0:00:00.145)       0:12:21.166 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:11 +0300 (0:00:00.160)       0:12:21.326 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhmav03g08hr6feh31au]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:13 +0300 (0:00:02.250)       0:12:23.576 ************ 
Среда 19 июня 2024  16:00:13 +0300 (0:00:00.037)       0:12:23.614 ************ 
Среда 19 июня 2024  16:00:13 +0300 (0:00:00.035)       0:12:23.649 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:18 +0300 (0:00:04.731)       0:12:28.381 ************ 
Среда 19 июня 2024  16:00:18 +0300 (0:00:00.142)       0:12:28.523 ************ 
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.136)       0:12:28.660 ************ 
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.125)       0:12:28.786 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.202)       0:12:28.988 ************ 
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.122)       0:12:29.111 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.274)       0:12:29.385 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubeadm"
}
Среда 19 июня 2024  16:00:19 +0300 (0:00:00.157)       0:12:29.543 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:20 +0300 (0:00:00.173)       0:12:29.717 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:28 +0300 (0:00:08.625)       0:12:38.342 ************ 
Среда 19 июня 2024  16:00:28 +0300 (0:00:00.040)       0:12:38.383 ************ 
Среда 19 июня 2024  16:00:28 +0300 (0:00:00.040)       0:12:38.423 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:34 +0300 (0:00:05.511)       0:12:43.934 ************ 
Среда 19 июня 2024  16:00:34 +0300 (0:00:00.116)       0:12:44.051 ************ 
Среда 19 июня 2024  16:00:34 +0300 (0:00:00.106)       0:12:44.157 ************ 
Среда 19 июня 2024  16:00:34 +0300 (0:00:00.104)       0:12:44.262 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:00:34 +0300 (0:00:00.212)       0:12:44.475 ************ 
Среда 19 июня 2024  16:00:34 +0300 (0:00:00.132)       0:12:44.607 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:35 +0300 (0:00:00.138)       0:12:44.746 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubelet"
}
Среда 19 июня 2024  16:00:35 +0300 (0:00:00.275)       0:12:45.021 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:35 +0300 (0:00:00.143)       0:12:45.165 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:39 +0300 (0:00:04.463)       0:12:49.628 ************ 
Среда 19 июня 2024  16:00:40 +0300 (0:00:00.040)       0:12:49.668 ************ 
Среда 19 июня 2024  16:00:40 +0300 (0:00:00.043)       0:12:49.712 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:44 +0300 (0:00:04.754)       0:12:54.467 ************ 
Среда 19 июня 2024  16:00:44 +0300 (0:00:00.124)       0:12:54.591 ************ 
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.117)       0:12:54.708 ************ 
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.110)       0:12:54.819 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.195)       0:12:55.014 ************ 
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.109)       0:12:55.124 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.090)       0:12:55.215 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubectl"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubectl"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubectl"
}
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.070)       0:12:55.285 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:45 +0300 (0:00:00.093)       0:12:55.379 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:00:47 +0300 (0:00:02.061)       0:12:57.440 ************ 
Среда 19 июня 2024  16:00:47 +0300 (0:00:00.046)       0:12:57.487 ************ 
Среда 19 июня 2024  16:00:47 +0300 (0:00:00.040)       0:12:57.527 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:00:50 +0300 (0:00:02.694)       0:13:00.221 ************ 
Среда 19 июня 2024  16:00:50 +0300 (0:00:00.083)       0:13:00.305 ************ 
Среда 19 июня 2024  16:00:50 +0300 (0:00:00.072)       0:13:00.378 ************ 
Среда 19 июня 2024  16:00:50 +0300 (0:00:00.077)       0:13:00.456 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:00:50 +0300 (0:00:00.129)       0:13:00.585 ************ 
Среда 19 июня 2024  16:00:51 +0300 (0:00:00.079)       0:13:00.665 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:51 +0300 (0:00:00.144)       0:13:00.809 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:00:51 +0300 (0:00:00.139)       0:13:00.949 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:00:51 +0300 (0:00:00.154)       0:13:01.103 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:00 +0300 (0:00:08.835)       0:13:09.939 ************ 
Среда 19 июня 2024  16:01:00 +0300 (0:00:00.032)       0:13:09.971 ************ 
Среда 19 июня 2024  16:01:00 +0300 (0:00:00.039)       0:13:10.010 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:15 +0300 (0:00:15.086)       0:13:25.096 ************ 
Среда 19 июня 2024  16:01:15 +0300 (0:00:00.111)       0:13:25.207 ************ 
Среда 19 июня 2024  16:01:15 +0300 (0:00:00.202)       0:13:25.410 ************ 
Среда 19 июня 2024  16:01:15 +0300 (0:00:00.123)       0:13:25.534 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:01:16 +0300 (0:00:00.205)       0:13:25.739 ************ 

TASK [download : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:38 +0300 (0:00:22.072)       0:13:47.812 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:38 +0300 (0:00:00.156)       0:13:47.969 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64"
}
Среда 19 июня 2024  16:01:38 +0300 (0:00:00.154)       0:13:48.124 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:38 +0300 (0:00:00.143)       0:13:48.267 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:46 +0300 (0:00:08.330)       0:13:56.598 ************ 
Среда 19 июня 2024  16:01:46 +0300 (0:00:00.036)       0:13:56.634 ************ 
Среда 19 июня 2024  16:01:47 +0300 (0:00:00.036)       0:13:56.670 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:50 +0300 (0:00:03.224)       0:13:59.895 ************ 
Среда 19 июня 2024  16:01:50 +0300 (0:00:00.117)       0:14:00.012 ************ 
Среда 19 июня 2024  16:01:50 +0300 (0:00:00.107)       0:14:00.120 ************ 
Среда 19 июня 2024  16:01:50 +0300 (0:00:00.105)       0:14:00.226 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:01:50 +0300 (0:00:00.302)       0:14:00.528 ************ 
Среда 19 июня 2024  16:01:50 +0300 (0:00:00.122)       0:14:00.650 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:51 +0300 (0:00:00.139)       0:14:00.790 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:01:51 +0300 (0:00:00.157)       0:14:00.947 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:51 +0300 (0:00:00.149)       0:14:01.097 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:01:56 +0300 (0:00:05.367)       0:14:06.465 ************ 
Среда 19 июня 2024  16:01:56 +0300 (0:00:00.037)       0:14:06.502 ************ 
Среда 19 июня 2024  16:01:56 +0300 (0:00:00.042)       0:14:06.544 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:03 +0300 (0:00:06.769)       0:14:13.314 ************ 
Среда 19 июня 2024  16:02:03 +0300 (0:00:00.116)       0:14:13.431 ************ 
Среда 19 июня 2024  16:02:03 +0300 (0:00:00.127)       0:14:13.558 ************ 
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.110)       0:14:13.668 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.186)       0:14:13.855 ************ 
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.220)       0:14:14.076 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.139)       0:14:14.216 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.7.4/nerdctl-1.7.4-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.154)       0:14:14.370 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:04 +0300 (0:00:00.170)       0:14:14.541 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:15 +0300 (0:00:11.013)       0:14:25.554 ************ 
Среда 19 июня 2024  16:02:15 +0300 (0:00:00.035)       0:14:25.590 ************ 
Среда 19 июня 2024  16:02:15 +0300 (0:00:00.043)       0:14:25.633 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:25 +0300 (0:00:09.388)       0:14:35.022 ************ 
Среда 19 июня 2024  16:02:25 +0300 (0:00:00.113)       0:14:35.135 ************ 
Среда 19 июня 2024  16:02:25 +0300 (0:00:00.105)       0:14:35.241 ************ 
Среда 19 июня 2024  16:02:25 +0300 (0:00:00.104)       0:14:35.345 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:02:25 +0300 (0:00:00.208)       0:14:35.554 ************ 

TASK [download : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:33 +0300 (0:00:07.762)       0:14:43.317 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:33 +0300 (0:00:00.191)       0:14:43.509 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64"
}
Среда 19 июня 2024  16:02:34 +0300 (0:00:00.277)       0:14:43.786 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:34 +0300 (0:00:00.144)       0:14:43.930 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:36 +0300 (0:00:02.652)       0:14:46.582 ************ 
Среда 19 июня 2024  16:02:36 +0300 (0:00:00.038)       0:14:46.620 ************ 
Среда 19 июня 2024  16:02:36 +0300 (0:00:00.038)       0:14:46.659 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:40 +0300 (0:00:03.856)       0:14:50.515 ************ 
Среда 19 июня 2024  16:02:40 +0300 (0:00:00.128)       0:14:50.643 ************ 
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.104)       0:14:50.748 ************ 
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.110)       0:14:50.858 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.200)       0:14:51.059 ************ 
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.114)       0:14:51.173 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.142)       0:14:51.316 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "quay.io/calico/node"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "quay.io/calico/node"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "quay.io/calico/node"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "quay.io/calico/node"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "quay.io/calico/node"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "quay.io/calico/node"
}
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.161)       0:14:51.477 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:41 +0300 (0:00:00.169)       0:14:51.647 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.255)       0:14:51.903 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.145)       0:14:52.048 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.131)       0:14:52.180 ************ 
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.105)       0:14:52.285 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.141)       0:14:52.427 ************ 
Среда 19 июня 2024  16:02:42 +0300 (0:00:00.128)       0:14:52.555 ************ 
Среда 19 июня 2024  16:02:43 +0300 (0:00:00.109)       0:14:52.665 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:43 +0300 (0:00:00.131)       0:14:52.796 ************ 
Среда 19 июня 2024  16:02:43 +0300 (0:00:00.107)       0:14:52.904 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:02:43 +0300 (0:00:00.204)       0:14:53.109 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:54 +0300 (0:00:11.210)       0:15:04.320 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.382)       0:15:04.702 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.117)       0:15:04.820 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull quay.io/calico/node:v3.27.3 required is: False"
}
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.139)       0:15:04.959 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.115)       0:15:05.075 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.114)       0:15:05.189 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.104)       0:15:05.294 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.134)       0:15:05.428 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.043)       0:15:05.472 ************ 
Среда 19 июня 2024  16:02:55 +0300 (0:00:00.128)       0:15:05.600 ************ 
Среда 19 июня 2024  16:02:56 +0300 (0:00:00.104)       0:15:05.705 ************ 
Среда 19 июня 2024  16:02:56 +0300 (0:00:00.099)       0:15:05.805 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:59 +0300 (0:00:03.514)       0:15:09.319 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:02:59 +0300 (0:00:00.164)       0:15:09.483 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "quay.io/calico/cni"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "quay.io/calico/cni"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "quay.io/calico/cni"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "quay.io/calico/cni"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "quay.io/calico/cni"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "quay.io/calico/cni"
}
Среда 19 июня 2024  16:02:59 +0300 (0:00:00.158)       0:15:09.642 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.245)       0:15:09.887 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.145)       0:15:10.033 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.146)       0:15:10.179 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.148)       0:15:10.328 ************ 
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.128)       0:15:10.457 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:00 +0300 (0:00:00.157)       0:15:10.615 ************ 
Среда 19 июня 2024  16:03:01 +0300 (0:00:00.109)       0:15:10.725 ************ 
Среда 19 июня 2024  16:03:01 +0300 (0:00:00.104)       0:15:10.829 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:01 +0300 (0:00:00.175)       0:15:11.004 ************ 
Среда 19 июня 2024  16:03:01 +0300 (0:00:00.128)       0:15:11.133 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:03:01 +0300 (0:00:00.215)       0:15:11.348 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:08 +0300 (0:00:06.687)       0:15:18.036 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:08 +0300 (0:00:00.276)       0:15:18.312 ************ 
Среда 19 июня 2024  16:03:08 +0300 (0:00:00.117)       0:15:18.430 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull quay.io/calico/cni:v3.27.3 required is: False"
}
Среда 19 июня 2024  16:03:08 +0300 (0:00:00.151)       0:15:18.582 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.114)       0:15:18.696 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.105)       0:15:18.802 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.101)       0:15:18.904 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.120)       0:15:19.025 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.038)       0:15:19.063 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.104)       0:15:19.167 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.105)       0:15:19.273 ************ 
Среда 19 июня 2024  16:03:09 +0300 (0:00:00.106)       0:15:19.380 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:12 +0300 (0:00:02.427)       0:15:21.807 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:12 +0300 (0:00:00.160)       0:15:21.968 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
Среда 19 июня 2024  16:03:12 +0300 (0:00:00.140)       0:15:22.108 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:12 +0300 (0:00:00.289)       0:15:22.397 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:12 +0300 (0:00:00.162)       0:15:22.560 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.149)       0:15:22.709 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.136)       0:15:22.845 ************ 
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.107)       0:15:22.953 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.142)       0:15:23.096 ************ 
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.106)       0:15:23.203 ************ 
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.107)       0:15:23.310 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.150)       0:15:23.461 ************ 
Среда 19 июня 2024  16:03:13 +0300 (0:00:00.122)       0:15:23.583 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:03:14 +0300 (0:00:00.217)       0:15:23.800 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:19 +0300 (0:00:05.094)       0:15:28.895 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:19 +0300 (0:00:00.266)       0:15:29.162 ************ 
Среда 19 июня 2024  16:03:19 +0300 (0:00:00.114)       0:15:29.277 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.27.3 required is: False"
}
Среда 19 июня 2024  16:03:19 +0300 (0:00:00.158)       0:15:29.435 ************ 
Среда 19 июня 2024  16:03:19 +0300 (0:00:00.133)       0:15:29.568 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.109)       0:15:29.678 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.106)       0:15:29.784 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.122)       0:15:29.907 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.037)       0:15:29.944 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.108)       0:15:30.052 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.106)       0:15:30.159 ************ 
Среда 19 июня 2024  16:03:20 +0300 (0:00:00.104)       0:15:30.264 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:23 +0300 (0:00:02.828)       0:15:33.092 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:23 +0300 (0:00:00.139)       0:15:33.232 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "quay.io/calico/kube-controllers"
}
Среда 19 июня 2024  16:03:23 +0300 (0:00:00.150)       0:15:33.383 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.298)       0:15:33.681 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.149)       0:15:33.831 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.132)       0:15:33.963 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.136)       0:15:34.100 ************ 
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.110)       0:15:34.210 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.129)       0:15:34.340 ************ 
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.121)       0:15:34.461 ************ 
Среда 19 июня 2024  16:03:24 +0300 (0:00:00.128)       0:15:34.590 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:25 +0300 (0:00:00.137)       0:15:34.728 ************ 
Среда 19 июня 2024  16:03:25 +0300 (0:00:00.106)       0:15:34.835 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:03:25 +0300 (0:00:00.197)       0:15:35.032 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:29 +0300 (0:00:03.916)       0:15:38.948 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:29 +0300 (0:00:00.261)       0:15:39.210 ************ 
Среда 19 июня 2024  16:03:29 +0300 (0:00:00.111)       0:15:39.321 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.27.3 required is: False"
}
Среда 19 июня 2024  16:03:29 +0300 (0:00:00.164)       0:15:39.486 ************ 
Среда 19 июня 2024  16:03:29 +0300 (0:00:00.122)       0:15:39.608 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.099)       0:15:39.708 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.099)       0:15:39.807 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.124)       0:15:39.932 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.035)       0:15:39.967 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.107)       0:15:40.075 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.104)       0:15:40.179 ************ 
Среда 19 июня 2024  16:03:30 +0300 (0:00:00.106)       0:15:40.286 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:33 +0300 (0:00:02.717)       0:15:43.004 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:03:33 +0300 (0:00:00.080)       0:15:43.085 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/projectcalico/calico/archive/v3.27.3.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/projectcalico/calico/archive/v3.27.3.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/projectcalico/calico/archive/v3.27.3.tar.gz"
}
Среда 19 июня 2024  16:03:33 +0300 (0:00:00.074)       0:15:43.159 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:03:33 +0300 (0:00:00.195)       0:15:43.354 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:03:35 +0300 (0:00:01.468)       0:15:44.822 ************ 
Среда 19 июня 2024  16:03:35 +0300 (0:00:00.034)       0:15:44.857 ************ 
Среда 19 июня 2024  16:03:35 +0300 (0:00:00.036)       0:15:44.893 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:03:37 +0300 (0:00:02.027)       0:15:46.921 ************ 
Среда 19 июня 2024  16:03:37 +0300 (0:00:00.076)       0:15:46.997 ************ 
Среда 19 июня 2024  16:03:37 +0300 (0:00:00.071)       0:15:47.068 ************ 
Среда 19 июня 2024  16:03:37 +0300 (0:00:00.068)       0:15:47.137 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:03:37 +0300 (0:00:00.112)       0:15:47.250 ************ 

TASK [download : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:03:43 +0300 (0:00:05.985)       0:15:53.236 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:43 +0300 (0:00:00.148)       0:15:53.384 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "registry.k8s.io/pause"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "registry.k8s.io/pause"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "registry.k8s.io/pause"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "registry.k8s.io/pause"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "registry.k8s.io/pause"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "registry.k8s.io/pause"
}
Среда 19 июня 2024  16:03:43 +0300 (0:00:00.161)       0:15:53.546 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.149)       0:15:53.695 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.141)       0:15:53.836 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.130)       0:15:53.966 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.145)       0:15:54.112 ************ 
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.201)       0:15:54.313 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.159)       0:15:54.473 ************ 
Среда 19 июня 2024  16:03:44 +0300 (0:00:00.123)       0:15:54.596 ************ 
Среда 19 июня 2024  16:03:45 +0300 (0:00:00.105)       0:15:54.701 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:45 +0300 (0:00:00.138)       0:15:54.839 ************ 
Среда 19 июня 2024  16:03:45 +0300 (0:00:00.112)       0:15:54.952 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:03:45 +0300 (0:00:00.203)       0:15:55.155 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:51 +0300 (0:00:05.980)       0:16:01.136 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:03:51 +0300 (0:00:00.149)       0:16:01.285 ************ 
Среда 19 июня 2024  16:03:51 +0300 (0:00:00.112)       0:16:01.398 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull registry.k8s.io/pause:3.9 required is: False"
}
Среда 19 июня 2024  16:03:51 +0300 (0:00:00.182)       0:16:01.581 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.213)       0:16:01.795 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.113)       0:16:01.908 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.106)       0:16:02.014 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.123)       0:16:02.138 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.039)       0:16:02.177 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.104)       0:16:02.282 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.108)       0:16:02.390 ************ 
Среда 19 июня 2024  16:03:52 +0300 (0:00:00.120)       0:16:02.510 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:04:14 +0300 (0:00:22.088)       0:16:24.599 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:15 +0300 (0:00:00.144)       0:16:24.744 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
Среда 19 июня 2024  16:04:15 +0300 (0:00:00.142)       0:16:24.887 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:15 +0300 (0:00:00.137)       0:16:25.024 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:15 +0300 (0:00:00.151)       0:16:25.176 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:15 +0300 (0:00:00.142)       0:16:25.319 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.370)       0:16:25.690 ************ 
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.113)       0:16:25.803 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.140)       0:16:25.943 ************ 
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.104)       0:16:26.047 ************ 
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.104)       0:16:26.152 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.134)       0:16:26.286 ************ 
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.108)       0:16:26.395 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:04:16 +0300 (0:00:00.233)       0:16:26.629 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:23 +0300 (0:00:06.773)       0:16:33.402 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:23 +0300 (0:00:00.191)       0:16:33.593 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.110)       0:16:33.704 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.11.1 required is: False"
}
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.136)       0:16:33.841 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.208)       0:16:34.050 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.111)       0:16:34.161 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.103)       0:16:34.265 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.132)       0:16:34.397 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.052)       0:16:34.450 ************ 
Среда 19 июня 2024  16:04:24 +0300 (0:00:00.125)       0:16:34.576 ************ 
Среда 19 июня 2024  16:04:25 +0300 (0:00:00.113)       0:16:34.689 ************ 
Среда 19 июня 2024  16:04:25 +0300 (0:00:00.105)       0:16:34.795 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:33 +0300 (0:00:08.808)       0:16:43.603 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.148)       0:16:43.751 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.143)       0:16:43.895 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.135)       0:16:44.031 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.146)       0:16:44.177 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.144)       0:16:44.322 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:34 +0300 (0:00:00.285)       0:16:44.608 ************ 
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.115)       0:16:44.724 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.155)       0:16:44.879 ************ 
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.109)       0:16:44.989 ************ 
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.102)       0:16:45.091 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.135)       0:16:45.227 ************ 
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.107)       0:16:45.335 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:04:35 +0300 (0:00:00.242)       0:16:45.577 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:48 +0300 (0:00:13.033)       0:16:58.611 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.140)       0:16:58.752 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.109)       0:16:58.862 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.22.28 required is: False"
}
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.141)       0:16:59.003 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.213)       0:16:59.217 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.116)       0:16:59.333 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.118)       0:16:59.452 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.148)       0:16:59.600 ************ 
Среда 19 июня 2024  16:04:49 +0300 (0:00:00.037)       0:16:59.638 ************ 
Среда 19 июня 2024  16:04:50 +0300 (0:00:00.109)       0:16:59.747 ************ 
Среда 19 июня 2024  16:04:50 +0300 (0:00:00.106)       0:16:59.854 ************ 
Среда 19 июня 2024  16:04:50 +0300 (0:00:00.108)       0:16:59.962 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:04:56 +0300 (0:00:06.445)       0:17:06.407 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:56 +0300 (0:00:00.109)       0:17:06.517 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "registry.k8s.io/cpa/cluster-proportional-autoscaler"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "registry.k8s.io/cpa/cluster-proportional-autoscaler"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "registry.k8s.io/cpa/cluster-proportional-autoscaler"
}
Среда 19 июня 2024  16:04:56 +0300 (0:00:00.094)       0:17:06.612 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.083)       0:17:06.696 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.079)       0:17:06.776 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.082)       0:17:06.858 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.172)       0:17:07.031 ************ 
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.081)       0:17:07.112 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.086)       0:17:07.199 ************ 
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.075)       0:17:07.275 ************ 
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.072)       0:17:07.347 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.079)       0:17:07.426 ************ 
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.086)       0:17:07.512 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:04:57 +0300 (0:00:00.141)       0:17:07.654 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:05:07 +0300 (0:00:09.504)       0:17:17.158 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:05:07 +0300 (0:00:00.099)       0:17:17.258 ************ 
Среда 19 июня 2024  16:05:07 +0300 (0:00:00.075)       0:17:17.333 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "Pull registry.k8s.io/cpa/cluster-proportional-autoscaler:v1.8.8 required is: False"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "Pull registry.k8s.io/cpa/cluster-proportional-autoscaler:v1.8.8 required is: False"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "Pull registry.k8s.io/cpa/cluster-proportional-autoscaler:v1.8.8 required is: False"
}
Среда 19 июня 2024  16:05:07 +0300 (0:00:00.099)       0:17:17.433 ************ 
Среда 19 июня 2024  16:05:07 +0300 (0:00:00.085)       0:17:17.518 ************ 
Среда 19 июня 2024  16:05:07 +0300 (0:00:00.086)       0:17:17.605 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.085)       0:17:17.690 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.076)       0:17:17.767 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.038)       0:17:17.805 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.073)       0:17:17.879 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.072)       0:17:17.951 ************ 
Среда 19 июня 2024  16:05:08 +0300 (0:00:00.068)       0:17:18.020 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:05:12 +0300 (0:00:03.825)       0:17:21.846 ************ 

TASK [download : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:05:12 +0300 (0:00:00.099)       0:17:21.945 ************ 

TASK [download : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:05:12 +0300 (0:00:00.077)       0:17:22.023 ************ 

TASK [download : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:05:12 +0300 (0:00:00.076)       0:17:22.100 ************ 

TASK [download : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:05:14 +0300 (0:00:02.345)       0:17:24.445 ************ 
Среда 19 июня 2024  16:05:14 +0300 (0:00:00.031)       0:17:24.477 ************ 
Среда 19 июня 2024  16:05:14 +0300 (0:00:00.053)       0:17:24.530 ************ 

TASK [download : Download_file | Download item] ********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:05:24 +0300 (0:00:09.487)       0:17:34.018 ************ 
Среда 19 июня 2024  16:05:24 +0300 (0:00:00.077)       0:17:34.096 ************ 
Среда 19 июня 2024  16:05:24 +0300 (0:00:00.072)       0:17:34.169 ************ 
Среда 19 июня 2024  16:05:24 +0300 (0:00:00.070)       0:17:34.239 ************ 

TASK [download : Download_file | Extract file archives] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:05:24 +0300 (0:00:00.109)       0:17:34.349 ************ 

TASK [download : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:05:45 +0300 (0:00:20.798)       0:17:55.148 ************ 

TASK [download : Set default values for flag variables] ************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:45 +0300 (0:00:00.102)       0:17:55.251 ************ 

TASK [download : Set_container_facts | Display the name of the image being processed] ******************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => {
    "msg": "docker.io/library/nginx"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "docker.io/library/nginx"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "docker.io/library/nginx"
}
Среда 19 июня 2024  16:05:45 +0300 (0:00:00.101)       0:17:55.352 ************ 

TASK [download : Set_container_facts | Set if containers should be pulled by digest] *******************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:45 +0300 (0:00:00.118)       0:17:55.471 ************ 

TASK [download : Set_container_facts | Define by what name to pull the image] **************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.321)       0:17:55.792 ************ 

TASK [download : Set_container_facts | Define file name of image] **************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.106)       0:17:55.899 ************ 

TASK [download : Set_container_facts | Define path of image] *******************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.095)       0:17:55.995 ************ 
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.080)       0:17:56.075 ************ 

TASK [download : Set image save/load command for containerd] *******************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.102)       0:17:56.178 ************ 
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.078)       0:17:56.256 ************ 
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.075)       0:17:56.332 ************ 

TASK [download : Set image save/load command for containerd on localhost] ******************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.121)       0:17:56.454 ************ 
Среда 19 июня 2024  16:05:46 +0300 (0:00:00.096)       0:17:56.550 ************ 

TASK [download : Download_container | Prepare container download] **************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/check_pull_required.yml for fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:05:47 +0300 (0:00:00.149)       0:17:56.700 ************ 

TASK [download : Check_pull_required |  Generate a list of information about the images on a node] *****************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:05:52 +0300 (0:00:05.327)       0:18:02.028 ************ 

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *******************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:05:52 +0300 (0:00:00.102)       0:18:02.130 ************ 
Среда 19 июня 2024  16:05:52 +0300 (0:00:00.080)       0:18:02.211 ************ 

TASK [download : debug] ********************************************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => {
    "msg": "Pull docker.io/library/nginx:1.25.2-alpine required is: False"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "msg": "Pull docker.io/library/nginx:1.25.2-alpine required is: False"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "msg": "Pull docker.io/library/nginx:1.25.2-alpine required is: False"
}
Среда 19 июня 2024  16:05:52 +0300 (0:00:00.094)       0:18:02.305 ************ 
Среда 19 июня 2024  16:05:52 +0300 (0:00:00.194)       0:18:02.500 ************ 
Среда 19 июня 2024  16:05:52 +0300 (0:00:00.087)       0:18:02.587 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.083)       0:18:02.670 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.090)       0:18:02.761 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.058)       0:18:02.820 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.080)       0:18:02.900 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.076)       0:18:02.977 ************ 
Среда 19 июня 2024  16:05:53 +0300 (0:00:00.080)       0:18:03.057 ************ 

TASK [download : Download_container | Remove container image from cache] *******************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]

PLAY [Add worker nodes to the etcd play if needed] *****************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:05:55 +0300 (0:00:02.136)       0:18:05.193 ************ 
Среда 19 июня 2024  16:05:55 +0300 (0:00:00.101)       0:18:05.294 ************ 
Среда 19 июня 2024  16:05:55 +0300 (0:00:00.032)       0:18:05.327 ************ 
Среда 19 июня 2024  16:05:55 +0300 (0:00:00.066)       0:18:05.394 ************ 
Среда 19 июня 2024  16:05:55 +0300 (0:00:00.041)       0:18:05.435 ************ 
Среда 19 июня 2024  16:05:55 +0300 (0:00:00.072)       0:18:05.507 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.193)       0:18:05.701 ************ 
[WARNING]: Could not match supplied host pattern, ignoring: _kubespray_needs_etcd

PLAY [Install etcd] ************************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.181)       0:18:05.882 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.101)       0:18:05.983 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.030)       0:18:06.014 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.058)       0:18:06.073 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.031)       0:18:06.105 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.056)       0:18:06.161 ************ 
Среда 19 июня 2024  16:05:56 +0300 (0:00:00.070)       0:18:06.232 ************ 

TASK [adduser : User | Create User Group] **************************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:06:00 +0300 (0:00:03.943)       0:18:10.175 ************ 

TASK [adduser : User | Create User] ********************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:06:05 +0300 (0:00:04.710)       0:18:14.886 ************ 

TASK [adduser : User | Create User Group] **************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:06:12 +0300 (0:00:07.160)       0:18:22.047 ************ 

TASK [adduser : User | Create User] ********************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:06:14 +0300 (0:00:02.293)       0:18:24.340 ************ 

TASK [etcd : Check etcd certs] *************************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/check_certs.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:06:14 +0300 (0:00:00.103)       0:18:24.443 ************ 

TASK [etcd : Check_certs | Register certs that have already been generated on first etcd node] *********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:06:16 +0300 (0:00:01.505)       0:18:25.948 ************ 

TASK [etcd : Check_certs | Set default value for 'sync_certs', 'gen_certs' and 'etcd_secret_changed' to false] *****************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:06:16 +0300 (0:00:00.071)       0:18:26.020 ************ 

TASK [etcd : Check certs | Register ca and etcd admin/member certs on etcd hosts] **********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=ca.pem)
ok: [fhms56jfu94iaefdph12] => (item=ca.pem)
ok: [fhm23nh49uft58qu43qa] => (item=ca.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=member-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12] => (item=member-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa] => (item=member-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=member-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhms56jfu94iaefdph12] => (item=member-fhms56jfu94iaefdph12-key.pem)
ok: [fhm23nh49uft58qu43qa] => (item=member-fhm23nh49uft58qu43qa-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=admin-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12] => (item=admin-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa] => (item=admin-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=admin-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhms56jfu94iaefdph12] => (item=admin-fhms56jfu94iaefdph12-key.pem)
ok: [fhm23nh49uft58qu43qa] => (item=admin-fhm23nh49uft58qu43qa-key.pem)
Среда 19 июня 2024  16:06:24 +0300 (0:00:08.193)       0:18:34.213 ************ 

TASK [etcd : Check certs | Register ca and etcd node certs on kubernetes hosts] ************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12] => (item=ca.pem)
ok: [fhm23nh49uft58qu43qa] => (item=ca.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=ca.pem)
ok: [fhms56jfu94iaefdph12] => (item=node-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa] => (item=node-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=node-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12] => (item=node-fhms56jfu94iaefdph12-key.pem)
ok: [fhm23nh49uft58qu43qa] => (item=node-fhm23nh49uft58qu43qa-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=node-fhmibjl39dmiukfvfsd4-key.pem)
Среда 19 июня 2024  16:06:28 +0300 (0:00:03.637)       0:18:37.851 ************ 

TASK [etcd : Check_certs | Set 'gen_certs' to true if expected certificates are not on the first etcd node(1/2)] ***************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/ca.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem)
Среда 19 июня 2024  16:06:28 +0300 (0:00:00.328)       0:18:38.180 ************ 
Среда 19 июня 2024  16:06:28 +0300 (0:00:00.176)       0:18:38.356 ************ 

TASK [etcd : Check_certs | Set 'gen_*_certs' groups to track which nodes needs to have certs generated on first etcd node] *****************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4] => (item={'node_type': 'master', 'certs': ['/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem', '/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem', '/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem', '/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem']})
changed: [fhmibjl39dmiukfvfsd4] => (item={'node_type': 'node', 'certs': ['/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem', '/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem']})
changed: [fhm23nh49uft58qu43qa] => (item={'node_type': 'master', 'certs': ['/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem', '/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem', '/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem', '/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem']})
changed: [fhm23nh49uft58qu43qa] => (item={'node_type': 'node', 'certs': ['/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem', '/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem']})
changed: [fhms56jfu94iaefdph12] => (item={'node_type': 'master', 'certs': ['/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem', '/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem', '/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem', '/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem']})
changed: [fhms56jfu94iaefdph12] => (item={'node_type': 'node', 'certs': ['/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem', '/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem']})
Среда 19 июня 2024  16:06:28 +0300 (0:00:00.108)       0:18:38.465 ************ 
Среда 19 июня 2024  16:06:28 +0300 (0:00:00.093)       0:18:38.558 ************ 
Среда 19 июня 2024  16:06:28 +0300 (0:00:00.061)       0:18:38.619 ************ 

TASK [etcd : Check_certs | Set 'sync_certs' to true] ***************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:06:29 +0300 (0:00:00.072)       0:18:38.691 ************ 

TASK [etcd : Generate etcd certs] **********************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/gen_certs_script.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:06:29 +0300 (0:00:00.131)       0:18:38.822 ************ 

TASK [etcd : Gen_certs | create etcd cert dir] *********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:06:30 +0300 (0:00:01.548)       0:18:40.371 ************ 

TASK [etcd : Gen_certs | create etcd script dir (on fhmibjl39dmiukfvfsd4)] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:06:32 +0300 (0:00:01.330)       0:18:41.702 ************ 

TASK [etcd : Gen_certs | write openssl config] *********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:06:36 +0300 (0:00:04.406)       0:18:46.108 ************ 

TASK [etcd : Gen_certs | copy certs generation script] *************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:06:39 +0300 (0:00:02.866)       0:18:48.975 ************ 

TASK [etcd : Gen_certs | run cert generation script for etcd and kube control plane nodes] *************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:06:41 +0300 (0:00:02.153)       0:18:51.129 ************ 
Среда 19 июня 2024  16:06:41 +0300 (0:00:00.038)       0:18:51.168 ************ 

TASK [etcd : Gen_certs | Gather etcd member/admin and kube_control_plane client certs from first etcd node] ********************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/ca.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/ca.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/ca-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/ca-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem)
ok: [fhm23nh49uft58qu43qa -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem)
ok: [fhms56jfu94iaefdph12 -> fhmibjl39dmiukfvfsd4(158.160.97.146)] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem)
Среда 19 июня 2024  16:07:08 +0300 (0:00:27.195)       0:19:18.363 ************ 

TASK [etcd : Gen_certs | Write etcd member/admin and kube_control_plane client certs to other etcd nodes] **********************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/ca.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/ca.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/ca-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/ca-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhm23nh49uft58qu43qa-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhm23nh49uft58qu43qa-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/admin-fhms56jfu94iaefdph12-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/member-fhms56jfu94iaefdph12-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhmibjl39dmiukfvfsd4-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhm23nh49uft58qu43qa-key.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12.pem)
changed: [fhms56jfu94iaefdph12] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem)
changed: [fhm23nh49uft58qu43qa] => (item=/etc/ssl/etcd/ssl/node-fhms56jfu94iaefdph12-key.pem)
Среда 19 июня 2024  16:08:43 +0300 (0:01:34.953)       0:20:53.317 ************ 
Среда 19 июня 2024  16:08:43 +0300 (0:00:00.244)       0:20:53.561 ************ 
Среда 19 июня 2024  16:08:44 +0300 (0:00:00.153)       0:20:53.714 ************ 
Среда 19 июня 2024  16:08:44 +0300 (0:00:00.055)       0:20:53.770 ************ 
Среда 19 июня 2024  16:08:44 +0300 (0:00:00.056)       0:20:53.826 ************ 

TASK [etcd : Gen_certs | check certificate permissions] ************************************************************************************************************************************************************************************
changed: [fhms56jfu94iaefdph12]
changed: [fhm23nh49uft58qu43qa]
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:08:45 +0300 (0:00:01.634)       0:20:55.460 ************ 

TASK [etcd : Trust etcd CA] ****************************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/upd_ca_trust.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:08:45 +0300 (0:00:00.136)       0:20:55.597 ************ 

TASK [etcd : Gen_certs | target ca-certificate store file] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:08:46 +0300 (0:00:00.068)       0:20:55.665 ************ 

TASK [etcd : Gen_certs | add CA to trusted CA dir] *****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:08:52 +0300 (0:00:06.659)       0:21:02.325 ************ 
Среда 19 июня 2024  16:08:52 +0300 (0:00:00.073)       0:21:02.399 ************ 
Среда 19 июня 2024  16:08:52 +0300 (0:00:00.062)       0:21:02.461 ************ 
Среда 19 июня 2024  16:08:52 +0300 (0:00:00.058)       0:21:02.519 ************ 
Среда 19 июня 2024  16:08:52 +0300 (0:00:00.061)       0:21:02.581 ************ 
Среда 19 июня 2024  16:08:52 +0300 (0:00:00.061)       0:21:02.643 ************ 
Среда 19 июня 2024  16:08:53 +0300 (0:00:00.055)       0:21:02.698 ************ 
Среда 19 июня 2024  16:08:53 +0300 (0:00:00.065)       0:21:02.764 ************ 

TASK [etcdctl_etcdutl : Download etcd binary] **********************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcdctl_etcdutl/tasks/../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:08:53 +0300 (0:00:00.088)       0:21:02.852 ************ 

TASK [etcdctl_etcdutl : Prep_download | Set a few facts] ***********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:08:53 +0300 (0:00:00.526)       0:21:03.379 ************ 

TASK [etcdctl_etcdutl : Download_file | Show url of file to dowload] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:08:54 +0300 (0:00:00.886)       0:21:04.266 ************ 

TASK [etcdctl_etcdutl : Download_file | Set pathname of cached file] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:08:55 +0300 (0:00:00.873)       0:21:05.139 ************ 

TASK [etcdctl_etcdutl : Download_file | Create dest directory on node] *********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:08:58 +0300 (0:00:03.185)       0:21:08.324 ************ 
Среда 19 июня 2024  16:08:58 +0300 (0:00:00.031)       0:21:08.356 ************ 
Среда 19 июня 2024  16:08:58 +0300 (0:00:00.039)       0:21:08.395 ************ 

TASK [etcdctl_etcdutl : Download_file | Download item] *************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:09:03 +0300 (0:00:04.842)       0:21:13.237 ************ 
Среда 19 июня 2024  16:09:03 +0300 (0:00:00.064)       0:21:13.302 ************ 
Среда 19 июня 2024  16:09:03 +0300 (0:00:00.065)       0:21:13.368 ************ 
Среда 19 июня 2024  16:09:03 +0300 (0:00:00.060)       0:21:13.428 ************ 

TASK [etcdctl_etcdutl : Download_file | Extract file archives] *****************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:03 +0300 (0:00:00.106)       0:21:13.535 ************ 

TASK [etcdctl_etcdutl : Extract_file | Unpacking archive] **********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:09:11 +0300 (0:00:07.918)       0:21:21.453 ************ 

TASK [etcdctl_etcdutl : Copy etcd binary] **************************************************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:09:19 +0300 (0:00:07.996)       0:21:29.450 ************ 

TASK [etcdctl_etcdutl : Copy etcdctl and etcdutl binary from download dir] *****************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=etcdctl)
ok: [fhmibjl39dmiukfvfsd4] => (item=etcdctl)
ok: [fhms56jfu94iaefdph12] => (item=etcdctl)
ok: [fhms56jfu94iaefdph12] => (item=etcdutl)
ok: [fhmibjl39dmiukfvfsd4] => (item=etcdutl)
ok: [fhm23nh49uft58qu43qa] => (item=etcdutl)
Среда 19 июня 2024  16:09:31 +0300 (0:00:12.148)       0:21:41.599 ************ 

TASK [etcdctl_etcdutl : Create etcdctl wrapper script] *************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:09:35 +0300 (0:00:03.464)       0:21:45.064 ************ 

TASK [etcd : Install etcd] *****************************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/install_host.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:35 +0300 (0:00:00.113)       0:21:45.178 ************ 

TASK [etcd : Get currently-deployed etcd version] ******************************************************************************************************************************************************************************************
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:09:36 +0300 (0:00:01.062)       0:21:46.240 ************ 
Среда 19 июня 2024  16:09:36 +0300 (0:00:00.074)       0:21:46.315 ************ 
Среда 19 июня 2024  16:09:36 +0300 (0:00:00.056)       0:21:46.371 ************ 

TASK [etcd : Install | Copy etcd binary from download dir] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=etcd)
ok: [fhm23nh49uft58qu43qa] => (item=etcd)
ok: [fhms56jfu94iaefdph12] => (item=etcd)
Среда 19 июня 2024  16:09:38 +0300 (0:00:02.078)       0:21:48.450 ************ 

TASK [etcd : Configure etcd] ***************************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/configure.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:38 +0300 (0:00:00.187)       0:21:48.638 ************ 

TASK [etcd : Configure | Check if etcd cluster is healthy] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:09:41 +0300 (0:00:02.667)       0:21:51.306 ************ 
Среда 19 июня 2024  16:09:41 +0300 (0:00:00.034)       0:21:51.340 ************ 

TASK [etcd : Configure | Refresh etcd config] **********************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/refresh_config.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:41 +0300 (0:00:00.102)       0:21:51.443 ************ 

TASK [etcd : Refresh config | Create etcd config file] *************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:09:45 +0300 (0:00:03.260)       0:21:54.703 ************ 
Среда 19 июня 2024  16:09:45 +0300 (0:00:00.067)       0:21:54.771 ************ 

TASK [etcd : Configure | Copy etcd.service systemd file] ***********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:09:48 +0300 (0:00:03.132)       0:21:57.904 ************ 
Среда 19 июня 2024  16:09:48 +0300 (0:00:00.053)       0:21:57.957 ************ 

TASK [etcd : Configure | reload systemd] ***************************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:09:50 +0300 (0:00:01.947)       0:21:59.905 ************ 

TASK [etcd : Configure | Ensure etcd is running] *******************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:09:52 +0300 (0:00:01.817)       0:22:01.722 ************ 
Среда 19 июня 2024  16:09:52 +0300 (0:00:00.059)       0:22:01.782 ************ 

TASK [etcd : Configure | Wait for etcd cluster to be healthy] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:09:53 +0300 (0:00:01.678)       0:22:03.460 ************ 
Среда 19 июня 2024  16:09:53 +0300 (0:00:00.033)       0:22:03.494 ************ 

TASK [etcd : Configure | Check if member is in etcd cluster] *******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:09:55 +0300 (0:00:01.186)       0:22:04.680 ************ 
Среда 19 июня 2024  16:09:55 +0300 (0:00:00.061)       0:22:04.741 ************ 
Среда 19 июня 2024  16:09:55 +0300 (0:00:00.065)       0:22:04.806 ************ 
Среда 19 июня 2024  16:09:55 +0300 (0:00:00.062)       0:22:04.869 ************ 

TASK [etcd : Refresh etcd config] **********************************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/refresh_config.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:55 +0300 (0:00:00.126)       0:22:04.996 ************ 

TASK [etcd : Refresh config | Create etcd config file] *************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:09:58 +0300 (0:00:03.018)       0:22:08.015 ************ 
Среда 19 июня 2024  16:09:58 +0300 (0:00:00.065)       0:22:08.081 ************ 
Среда 19 июня 2024  16:09:58 +0300 (0:00:00.055)       0:22:08.136 ************ 
Среда 19 июня 2024  16:09:58 +0300 (0:00:00.054)       0:22:08.191 ************ 

TASK [etcd : Refresh etcd config again for idempotency] ************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/etcd/tasks/refresh_config.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:09:58 +0300 (0:00:00.133)       0:22:08.324 ************ 

TASK [etcd : Refresh config | Create etcd config file] *************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:10:01 +0300 (0:00:03.311)       0:22:11.636 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.105)       0:22:11.741 ************ 

RUNNING HANDLER [etcd : Set etcd_secret_changed] *******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]

PLAY [Install Kubernetes nodes] ************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.159)       0:22:11.900 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.106)       0:22:12.007 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.031)       0:22:12.039 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.121)       0:22:12.160 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.032)       0:22:12.193 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.121)       0:22:12.315 ************ 
Среда 19 июня 2024  16:10:02 +0300 (0:00:00.283)       0:22:12.599 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.109)       0:22:12.708 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.099)       0:22:12.807 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.100)       0:22:12.908 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.099)       0:22:13.007 ************ 

TASK [kubernetes/node : Set kubelet_cgroup_driver_detected fact for containerd] ************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.123)       0:22:13.131 ************ 

TASK [kubernetes/node : Set kubelet_cgroup_driver] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.124)       0:22:13.255 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.106)       0:22:13.361 ************ 
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.112)       0:22:13.473 ************ 

TASK [kubernetes/node : Os specific vars] **************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
ok: [fhmav03g08hr6feh31au] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
ok: [fhm1q990n3ve0rlv7q48] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
ok: [fhm4jldk6ls9qm2tclqm] => (item=kubernetes-prod/kubespray/roles/kubernetes/node/vars/ubuntu-20.yml)
Среда 19 июня 2024  16:10:03 +0300 (0:00:00.162)       0:22:13.636 ************ 

TASK [kubernetes/node : Pre-upgrade | check if kubelet container exists] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:06 +0300 (0:00:02.308)       0:22:15.945 ************ 
Среда 19 июня 2024  16:10:06 +0300 (0:00:00.105)       0:22:16.051 ************ 
Среда 19 июня 2024  16:10:06 +0300 (0:00:00.100)       0:22:16.151 ************ 
Среда 19 июня 2024  16:10:06 +0300 (0:00:00.209)       0:22:16.361 ************ 

TASK [kubernetes/node : Ensure /var/lib/cni exists] ****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:11 +0300 (0:00:05.130)       0:22:21.492 ************ 

TASK [kubernetes/node : Install | Copy kubeadm binary from download dir] *******************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:10:18 +0300 (0:00:06.855)       0:22:28.347 ************ 

TASK [kubernetes/node : Install | Copy kubelet binary from download dir] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:25 +0300 (0:00:06.333)       0:22:34.681 ************ 
Среда 19 июня 2024  16:10:25 +0300 (0:00:00.118)       0:22:34.800 ************ 
Среда 19 июня 2024  16:10:25 +0300 (0:00:00.103)       0:22:34.903 ************ 

TASK [kubernetes/node : Haproxy | Cleanup potentially deployed haproxy] ********************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:10:26 +0300 (0:00:01.281)       0:22:36.185 ************ 

TASK [kubernetes/node : Nginx-proxy | Make nginx directory] ********************************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:10:27 +0300 (0:00:01.108)       0:22:37.294 ************ 

TASK [kubernetes/node : Nginx-proxy | Write nginx-proxy configuration] *********************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:10:30 +0300 (0:00:03.127)       0:22:40.422 ************ 

TASK [kubernetes/node : Nginx-proxy | Get checksum from config] ****************************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:10:31 +0300 (0:00:01.122)       0:22:41.544 ************ 

TASK [kubernetes/node : Nginx-proxy | Write static pod] ************************************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:10:34 +0300 (0:00:02.916)       0:22:44.460 ************ 
Среда 19 июня 2024  16:10:34 +0300 (0:00:00.151)       0:22:44.612 ************ 
Среда 19 июня 2024  16:10:35 +0300 (0:00:00.121)       0:22:44.734 ************ 
Среда 19 июня 2024  16:10:35 +0300 (0:00:00.322)       0:22:45.056 ************ 
Среда 19 июня 2024  16:10:35 +0300 (0:00:00.126)       0:22:45.183 ************ 
Среда 19 июня 2024  16:10:35 +0300 (0:00:00.124)       0:22:45.307 ************ 

TASK [kubernetes/node : Ensure nodePort range is reserved] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:37 +0300 (0:00:02.204)       0:22:47.512 ************ 

TASK [kubernetes/node : Verify if br_netfilter module exists] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:10:39 +0300 (0:00:02.046)       0:22:49.558 ************ 

TASK [kubernetes/node : Verify br_netfilter module path exists] ****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=/etc/modules-load.d)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/modules-load.d)
ok: [fhms56jfu94iaefdph12] => (item=/etc/modules-load.d)
ok: [fhmav03g08hr6feh31au] => (item=/etc/modules-load.d)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/modules-load.d)
ok: [fhm23nh49uft58qu43qa] => (item=/etc/modprobe.d)
ok: [fhm1q990n3ve0rlv7q48] => (item=/etc/modprobe.d)
ok: [fhmav03g08hr6feh31au] => (item=/etc/modprobe.d)
ok: [fhms56jfu94iaefdph12] => (item=/etc/modprobe.d)
ok: [fhmibjl39dmiukfvfsd4] => (item=/etc/modprobe.d)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/modules-load.d)
ok: [fhm4jldk6ls9qm2tclqm] => (item=/etc/modprobe.d)
Среда 19 июня 2024  16:10:49 +0300 (0:00:09.421)       0:22:58.980 ************ 

TASK [kubernetes/node : Enable br_netfilter module] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:10:56 +0300 (0:00:06.905)       0:23:05.886 ************ 

TASK [kubernetes/node : Persist br_netfilter module] ***************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:11:01 +0300 (0:00:05.557)       0:23:11.443 ************ 

TASK [kubernetes/node : Check if bridge-nf-call-iptables key exists] ***********************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:11:04 +0300 (0:00:02.270)       0:23:13.713 ************ 

TASK [kubernetes/node : Enable bridge-nf-call tables] **************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhmibjl39dmiukfvfsd4] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhms56jfu94iaefdph12] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhm23nh49uft58qu43qa] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhmibjl39dmiukfvfsd4] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhms56jfu94iaefdph12] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhm1q990n3ve0rlv7q48] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhm23nh49uft58qu43qa] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhmibjl39dmiukfvfsd4] => (item=net.bridge.bridge-nf-call-ip6tables)
ok: [fhmav03g08hr6feh31au] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhms56jfu94iaefdph12] => (item=net.bridge.bridge-nf-call-ip6tables)
ok: [fhm1q990n3ve0rlv7q48] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhm23nh49uft58qu43qa] => (item=net.bridge.bridge-nf-call-ip6tables)
ok: [fhm1q990n3ve0rlv7q48] => (item=net.bridge.bridge-nf-call-ip6tables)
ok: [fhm4jldk6ls9qm2tclqm] => (item=net.bridge.bridge-nf-call-iptables)
ok: [fhmav03g08hr6feh31au] => (item=net.bridge.bridge-nf-call-ip6tables)
ok: [fhm4jldk6ls9qm2tclqm] => (item=net.bridge.bridge-nf-call-arptables)
ok: [fhm4jldk6ls9qm2tclqm] => (item=net.bridge.bridge-nf-call-ip6tables)
Среда 19 июня 2024  16:11:18 +0300 (0:00:14.389)       0:23:28.103 ************ 

TASK [kubernetes/node : Modprobe Kernel Module for IPVS] ***********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs_rr)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs_rr)
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs_rr)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs_rr)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs_rr)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs_wrr)
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs_wrr)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs_wrr)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs_wrr)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs_sh)
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs_sh)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs_sh)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs_wrr)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs_sh)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs_wlc)
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs_wlc)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs_sh)
ok: [fhm1q990n3ve0rlv7q48] => (item=ip_vs_lc)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs_wlc)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs_wlc)
ok: [fhmibjl39dmiukfvfsd4] => (item=ip_vs_lc)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs_wlc)
ok: [fhms56jfu94iaefdph12] => (item=ip_vs_lc)
ok: [fhm23nh49uft58qu43qa] => (item=ip_vs_lc)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs)
ok: [fhmav03g08hr6feh31au] => (item=ip_vs_lc)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs_rr)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs_wrr)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs_sh)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs_wlc)
ok: [fhm4jldk6ls9qm2tclqm] => (item=ip_vs_lc)
Среда 19 июня 2024  16:11:43 +0300 (0:00:24.653)       0:23:52.757 ************ 

TASK [kubernetes/node : Modprobe conntrack module] *****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=nf_conntrack)
fatal: [fhmibjl39dmiukfvfsd4]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
ok: [fhm23nh49uft58qu43qa] => (item=nf_conntrack)
fatal: [fhm23nh49uft58qu43qa]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
ok: [fhmav03g08hr6feh31au] => (item=nf_conntrack)
fatal: [fhmav03g08hr6feh31au]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
ok: [fhms56jfu94iaefdph12] => (item=nf_conntrack)
ok: [fhm1q990n3ve0rlv7q48] => (item=nf_conntrack)
fatal: [fhms56jfu94iaefdph12]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
fatal: [fhm1q990n3ve0rlv7q48]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
ok: [fhm4jldk6ls9qm2tclqm] => (item=nf_conntrack)
fatal: [fhm4jldk6ls9qm2tclqm]: FAILED! => {"msg": "The conditional check '(modprobe_conntrack_module|default({'rc': 1})).rc != 0' failed. The error was: error while evaluating conditional ((modprobe_conntrack_module|default({'rc': 1})).rc != 0): 'dict object' has no attribute 'rc'. 'dict object' has no attribute 'rc'\n\nThe error appears to be in 'kubernetes-prod/kubespray/roles/kubernetes/node/tasks/main.yml': line 126, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Modprobe conntrack module\n  ^ here\n"}
...ignoring
Среда 19 июня 2024  16:11:46 +0300 (0:00:03.849)       0:23:56.606 ************ 
Среда 19 июня 2024  16:11:47 +0300 (0:00:00.120)       0:23:56.727 ************ 
Среда 19 июня 2024  16:11:47 +0300 (0:00:00.109)       0:23:56.837 ************ 
Среда 19 июня 2024  16:11:47 +0300 (0:00:00.218)       0:23:57.056 ************ 
Среда 19 июня 2024  16:11:47 +0300 (0:00:00.117)       0:23:57.173 ************ 

TASK [kubernetes/node : Set kubelet api version to v1beta1] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:11:47 +0300 (0:00:00.141)       0:23:57.315 ************ 

TASK [kubernetes/node : Write kubelet environment config file (kubeadm)] *******************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:11:55 +0300 (0:00:07.476)       0:24:04.791 ************ 

TASK [kubernetes/node : Write kubelet config file] *****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:12:01 +0300 (0:00:06.706)       0:24:11.498 ************ 

TASK [kubernetes/node : Write kubelet systemd init file] ***********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:12:08 +0300 (0:00:07.081)       0:24:18.580 ************ 
Среда 19 июня 2024  16:12:08 +0300 (0:00:00.013)       0:24:18.593 ************ 
Среда 19 июня 2024  16:12:08 +0300 (0:00:00.014)       0:24:18.607 ************ 
Среда 19 июня 2024  16:12:08 +0300 (0:00:00.014)       0:24:18.621 ************ 
Среда 19 июня 2024  16:12:08 +0300 (0:00:00.019)       0:24:18.640 ************ 
Среда 19 июня 2024  16:12:08 +0300 (0:00:00.016)       0:24:18.657 ************ 
Среда 19 июня 2024  16:12:09 +0300 (0:00:00.014)       0:24:18.671 ************ 

TASK [kubernetes/node : Enable kubelet] ****************************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]

PLAY [Install the control plane] ***********************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:12:13 +0300 (0:00:04.220)       0:24:22.892 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.118)       0:24:23.011 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.033)       0:24:23.044 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.071)       0:24:23.116 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.036)       0:24:23.153 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.068)       0:24:23.221 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.080)       0:24:23.302 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.033)       0:24:23.335 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.058)       0:24:23.394 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.028)       0:24:23.422 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.064)       0:24:23.486 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.028)       0:24:23.515 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.072)       0:24:23.587 ************ 
Среда 19 июня 2024  16:12:13 +0300 (0:00:00.033)       0:24:23.621 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.058)       0:24:23.679 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.053)       0:24:23.733 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.031)       0:24:23.765 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.032)       0:24:23.798 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.071)       0:24:23.870 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.061)       0:24:23.931 ************ 
Среда 19 июня 2024  16:12:14 +0300 (0:00:00.089)       0:24:24.020 ************ 

TASK [kubernetes/control-plane : Pre-upgrade | Delete master manifests if etcd secrets changed] ********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=kube-apiserver)
ok: [fhmibjl39dmiukfvfsd4] => (item=kube-controller-manager)
ok: [fhmibjl39dmiukfvfsd4] => (item=kube-scheduler)
Среда 19 июня 2024  16:12:17 +0300 (0:00:03.274)       0:24:27.295 ************ 
Среда 19 июня 2024  16:12:17 +0300 (0:00:00.075)       0:24:27.370 ************ 
Среда 19 июня 2024  16:12:17 +0300 (0:00:00.063)       0:24:27.433 ************ 
Среда 19 июня 2024  16:12:17 +0300 (0:00:00.063)       0:24:27.497 ************ 

TASK [kubernetes/control-plane : Create kube-scheduler config] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:20 +0300 (0:00:02.854)       0:24:30.351 ************ 
Среда 19 июня 2024  16:12:20 +0300 (0:00:00.080)       0:24:30.432 ************ 
Среда 19 июня 2024  16:12:20 +0300 (0:00:00.070)       0:24:30.503 ************ 
Среда 19 июня 2024  16:12:20 +0300 (0:00:00.061)       0:24:30.564 ************ 
Среда 19 июня 2024  16:12:21 +0300 (0:00:00.166)       0:24:30.730 ************ 
Среда 19 июня 2024  16:12:21 +0300 (0:00:00.091)       0:24:30.822 ************ 
Среда 19 июня 2024  16:12:21 +0300 (0:00:00.052)       0:24:30.875 ************ 

TASK [kubernetes/control-plane : Install | Copy kubectl binary from download dir] **********************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:12:24 +0300 (0:00:02.817)       0:24:33.692 ************ 

TASK [kubernetes/control-plane : Install kubectl bash completion] **************************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:25 +0300 (0:00:01.114)       0:24:34.807 ************ 

TASK [kubernetes/control-plane : Set kubectl bash completion file permissions] *************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:12:26 +0300 (0:00:01.112)       0:24:35.920 ************ 
Среда 19 июня 2024  16:12:26 +0300 (0:00:00.064)       0:24:35.984 ************ 

TASK [kubernetes/control-plane : Check which kube-control nodes are already members of the cluster] ****************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:12:27 +0300 (0:00:01.444)       0:24:37.429 ************ 

TASK [kubernetes/control-plane : Set fact joined_control_planes] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=fhmibjl39dmiukfvfsd4)
ok: [fhmibjl39dmiukfvfsd4 -> fhm23nh49uft58qu43qa(158.160.125.52)] => (item=fhm23nh49uft58qu43qa)
ok: [fhmibjl39dmiukfvfsd4 -> fhms56jfu94iaefdph12(158.160.58.198)] => (item=fhms56jfu94iaefdph12)
Среда 19 июня 2024  16:12:27 +0300 (0:00:00.125)       0:24:37.554 ************ 

TASK [kubernetes/control-plane : Set fact first_kube_control_plane] ************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:27 +0300 (0:00:00.082)       0:24:37.637 ************ 
Среда 19 июня 2024  16:12:28 +0300 (0:00:00.061)       0:24:37.699 ************ 

TASK [kubernetes/control-plane : Kubeadm | Check if kubeadm has already run] ***************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:29 +0300 (0:00:00.974)       0:24:38.673 ************ 

TASK [kubernetes/control-plane : Backup old certs and keys] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=apiserver.crt)
changed: [fhms56jfu94iaefdph12] => (item=apiserver.crt)
changed: [fhm23nh49uft58qu43qa] => (item=apiserver.crt)
ok: [fhmibjl39dmiukfvfsd4] => (item=apiserver.key)
changed: [fhms56jfu94iaefdph12] => (item=apiserver.key)
changed: [fhm23nh49uft58qu43qa] => (item=apiserver.key)
ok: [fhmibjl39dmiukfvfsd4] => (item=apiserver-kubelet-client.crt)
changed: [fhms56jfu94iaefdph12] => (item=apiserver-kubelet-client.crt)
changed: [fhm23nh49uft58qu43qa] => (item=apiserver-kubelet-client.crt)
changed: [fhm23nh49uft58qu43qa] => (item=apiserver-kubelet-client.key)
ok: [fhmibjl39dmiukfvfsd4] => (item=apiserver-kubelet-client.key)
changed: [fhms56jfu94iaefdph12] => (item=apiserver-kubelet-client.key)
changed: [fhm23nh49uft58qu43qa] => (item=front-proxy-client.crt)
ok: [fhmibjl39dmiukfvfsd4] => (item=front-proxy-client.crt)
changed: [fhms56jfu94iaefdph12] => (item=front-proxy-client.crt)
changed: [fhm23nh49uft58qu43qa] => (item=front-proxy-client.key)
ok: [fhmibjl39dmiukfvfsd4] => (item=front-proxy-client.key)
changed: [fhms56jfu94iaefdph12] => (item=front-proxy-client.key)
Среда 19 июня 2024  16:12:48 +0300 (0:00:19.374)       0:24:58.048 ************ 

TASK [kubernetes/control-plane : Backup old confs] *****************************************************************************************************************************************************************************************
changed: [fhms56jfu94iaefdph12] => (item=admin.conf)
changed: [fhmibjl39dmiukfvfsd4] => (item=admin.conf)
changed: [fhm23nh49uft58qu43qa] => (item=admin.conf)
changed: [fhms56jfu94iaefdph12] => (item=controller-manager.conf)
changed: [fhmibjl39dmiukfvfsd4] => (item=controller-manager.conf)
changed: [fhm23nh49uft58qu43qa] => (item=controller-manager.conf)
changed: [fhms56jfu94iaefdph12] => (item=kubelet.conf)
changed: [fhmibjl39dmiukfvfsd4] => (item=kubelet.conf)
changed: [fhm23nh49uft58qu43qa] => (item=kubelet.conf)
changed: [fhms56jfu94iaefdph12] => (item=scheduler.conf)
changed: [fhmibjl39dmiukfvfsd4] => (item=scheduler.conf)
changed: [fhm23nh49uft58qu43qa] => (item=scheduler.conf)
Среда 19 июня 2024  16:12:56 +0300 (0:00:07.981)       0:25:06.030 ************ 

TASK [kubernetes/control-plane : Kubeadm | aggregate all SANs] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.224)       0:25:06.254 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.064)       0:25:06.319 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.068)       0:25:06.387 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.064)       0:25:06.451 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.061)       0:25:06.512 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.067)       0:25:06.580 ************ 
Среда 19 июня 2024  16:12:56 +0300 (0:00:00.069)       0:25:06.650 ************ 

TASK [kubernetes/control-plane : Set kubeadm api version to v1beta3] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:12:57 +0300 (0:00:00.076)       0:25:06.726 ************ 

TASK [kubernetes/control-plane : Kubeadm | Create kubeadm config] **************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:13:00 +0300 (0:00:03.449)       0:25:10.176 ************ 
Среда 19 июня 2024  16:13:00 +0300 (0:00:00.071)       0:25:10.247 ************ 
Среда 19 июня 2024  16:13:00 +0300 (0:00:00.056)       0:25:10.304 ************ 
Среда 19 июня 2024  16:13:00 +0300 (0:00:00.051)       0:25:10.355 ************ 
Среда 19 июня 2024  16:13:00 +0300 (0:00:00.078)       0:25:10.434 ************ 

TASK [kubernetes/control-plane : Kubeadm | Check apiserver.crt SAN IPs] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=10.233.0.1)
ok: [fhms56jfu94iaefdph12] => (item=10.233.0.1)
ok: [fhm23nh49uft58qu43qa] => (item=10.233.0.1)
ok: [fhmibjl39dmiukfvfsd4] => (item=127.0.0.1)
ok: [fhms56jfu94iaefdph12] => (item=127.0.0.1)
ok: [fhm23nh49uft58qu43qa] => (item=127.0.0.1)
ok: [fhmibjl39dmiukfvfsd4] => (item=192.168.99.20)
ok: [fhms56jfu94iaefdph12] => (item=192.168.99.20)
ok: [fhm23nh49uft58qu43qa] => (item=192.168.99.20)
ok: [fhmibjl39dmiukfvfsd4] => (item=192.168.99.27)
ok: [fhm23nh49uft58qu43qa] => (item=192.168.99.27)
ok: [fhmibjl39dmiukfvfsd4] => (item=192.168.99.33)
ok: [fhms56jfu94iaefdph12] => (item=192.168.99.27)
ok: [fhm23nh49uft58qu43qa] => (item=192.168.99.33)
ok: [fhms56jfu94iaefdph12] => (item=192.168.99.33)
Среда 19 июня 2024  16:13:14 +0300 (0:00:13.374)       0:25:23.809 ************ 

TASK [kubernetes/control-plane : Kubeadm | Check apiserver.crt SAN hosts] ******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa] => (item=localhost)
ok: [fhms56jfu94iaefdph12] => (item=localhost)
ok: [fhmibjl39dmiukfvfsd4] => (item=localhost)
ok: [fhm23nh49uft58qu43qa] => (item=fhm23nh49uft58qu43qa.auto.internal)
ok: [fhms56jfu94iaefdph12] => (item=fhm23nh49uft58qu43qa.auto.internal)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhm23nh49uft58qu43qa.auto.internal)
ok: [fhms56jfu94iaefdph12] => (item=lb-apiserver.kubernetes.local)
ok: [fhm23nh49uft58qu43qa] => (item=lb-apiserver.kubernetes.local)
ok: [fhmibjl39dmiukfvfsd4] => (item=lb-apiserver.kubernetes.local)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes)
ok: [fhm23nh49uft58qu43qa] => (item=fhm23nh49uft58qu43qa)
ok: [fhms56jfu94iaefdph12] => (item=fhm23nh49uft58qu43qa)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhm23nh49uft58qu43qa)
ok: [fhm23nh49uft58qu43qa] => (item=fhmibjl39dmiukfvfsd4.auto.internal)
ok: [fhms56jfu94iaefdph12] => (item=fhmibjl39dmiukfvfsd4.auto.internal)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhmibjl39dmiukfvfsd4.auto.internal)
ok: [fhms56jfu94iaefdph12] => (item=fhmibjl39dmiukfvfsd4)
ok: [fhm23nh49uft58qu43qa] => (item=fhmibjl39dmiukfvfsd4)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhmibjl39dmiukfvfsd4)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes.default.svc)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes.default.svc)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes.default.svc)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes.default)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes.default)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes.default)
ok: [fhm23nh49uft58qu43qa] => (item=fhms56jfu94iaefdph12.auto.internal)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhms56jfu94iaefdph12.auto.internal)
ok: [fhms56jfu94iaefdph12] => (item=fhms56jfu94iaefdph12.auto.internal)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes.default.svc.cluster.local)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes.default.svc.cluster.local)
ok: [fhm23nh49uft58qu43qa] => (item=fhms56jfu94iaefdph12)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes.default.svc.cluster.local)
ok: [fhmibjl39dmiukfvfsd4] => (item=fhms56jfu94iaefdph12)
ok: [fhms56jfu94iaefdph12] => (item=fhms56jfu94iaefdph12)
Среда 19 июня 2024  16:13:45 +0300 (0:00:31.482)       0:25:55.291 ************ 
Среда 19 июня 2024  16:13:45 +0300 (0:00:00.070)       0:25:55.361 ************ 
Среда 19 июня 2024  16:13:45 +0300 (0:00:00.067)       0:25:55.429 ************ 
Среда 19 июня 2024  16:13:45 +0300 (0:00:00.074)       0:25:55.503 ************ 
Среда 19 июня 2024  16:13:45 +0300 (0:00:00.074)       0:25:55.578 ************ 
Среда 19 июня 2024  16:13:45 +0300 (0:00:00.059)       0:25:55.638 ************ 
Среда 19 июня 2024  16:13:46 +0300 (0:00:00.072)       0:25:55.710 ************ 
Среда 19 июня 2024  16:13:46 +0300 (0:00:00.053)       0:25:55.763 ************ 
Среда 19 июня 2024  16:13:46 +0300 (0:00:00.053)       0:25:55.816 ************ 

TASK [kubernetes/control-plane : Create kubeadm token for joining nodes with 24h expiration (default)] *************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12 -> fhm23nh49uft58qu43qa(158.160.125.52)]
ok: [fhmibjl39dmiukfvfsd4 -> fhm23nh49uft58qu43qa(158.160.125.52)]
ok: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:13:47 +0300 (0:00:01.455)       0:25:57.271 ************ 

TASK [kubernetes/control-plane : Set kubeadm_token] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:13:47 +0300 (0:00:00.089)       0:25:57.361 ************ 

TASK [kubernetes/control-plane : Kubeadm | Join other masters] *****************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-secondary.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:13:47 +0300 (0:00:00.103)       0:25:57.464 ************ 

TASK [kubernetes/control-plane : Set kubeadm_discovery_address] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:13:47 +0300 (0:00:00.130)       0:25:57.594 ************ 

TASK [kubernetes/control-plane : Upload certificates so they are fresh and not expired] ****************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:13:49 +0300 (0:00:01.132)       0:25:58.727 ************ 
Среда 19 июня 2024  16:13:49 +0300 (0:00:00.053)       0:25:58.781 ************ 
Среда 19 июня 2024  16:13:49 +0300 (0:00:00.057)       0:25:58.838 ************ 

TASK [kubernetes/control-plane : Wait for k8s apiserver] ***********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:13:50 +0300 (0:00:01.264)       0:26:00.102 ************ 

TASK [kubernetes/control-plane : Check already run] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": true
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": true
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": true
}
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.078)       0:26:00.181 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.066)       0:26:00.247 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.036)       0:26:00.284 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.054)       0:26:00.338 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.086)       0:26:00.424 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.062)       0:26:00.486 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.074)       0:26:00.561 ************ 
Среда 19 июня 2024  16:13:50 +0300 (0:00:00.060)       0:26:00.622 ************ 

TASK [kubernetes/control-plane : Include kubeadm secondary server apiserver fixes] *********************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-fix-apiserver.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:13:51 +0300 (0:00:00.123)       0:26:00.745 ************ 

TASK [kubernetes/control-plane : Update server field in component kubeconfigs] *************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=admin.conf)
ok: [fhm23nh49uft58qu43qa] => (item=admin.conf)
ok: [fhms56jfu94iaefdph12] => (item=admin.conf)
ok: [fhmibjl39dmiukfvfsd4] => (item=controller-manager.conf)
ok: [fhm23nh49uft58qu43qa] => (item=controller-manager.conf)
ok: [fhms56jfu94iaefdph12] => (item=controller-manager.conf)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubelet.conf)
ok: [fhm23nh49uft58qu43qa] => (item=kubelet.conf)
ok: [fhms56jfu94iaefdph12] => (item=kubelet.conf)
ok: [fhmibjl39dmiukfvfsd4] => (item=scheduler.conf)
ok: [fhm23nh49uft58qu43qa] => (item=scheduler.conf)
ok: [fhms56jfu94iaefdph12] => (item=scheduler.conf)
Среда 19 июня 2024  16:13:55 +0300 (0:00:04.327)       0:26:05.073 ************ 

TASK [kubernetes/control-plane : Include kubelet client cert rotation fixes] ***************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/kubernetes/control-plane/tasks/kubelet-fix-client-cert-rotation.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:13:55 +0300 (0:00:00.126)       0:26:05.200 ************ 

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 1/2] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:13:56 +0300 (0:00:01.261)       0:26:06.461 ************ 

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 2/2] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:13:58 +0300 (0:00:01.415)       0:26:07.877 ************ 

TASK [kubernetes/control-plane : Install script to renew K8S control plane certificates] ***************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:01 +0300 (0:00:03.017)       0:26:10.894 ************ 
Среда 19 июня 2024  16:14:01 +0300 (0:00:00.075)       0:26:10.969 ************ 
Среда 19 июня 2024  16:14:01 +0300 (0:00:00.087)       0:26:11.057 ************ 

TASK [kubernetes/client : Set external kube-apiserver endpoint] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:01 +0300 (0:00:00.081)       0:26:11.138 ************ 

TASK [kubernetes/client : Create kube config dir for current/ansible become user] **********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:02 +0300 (0:00:01.145)       0:26:12.284 ************ 

TASK [kubernetes/client : Copy admin kubeconfig to current/ansible become user home] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:04 +0300 (0:00:01.805)       0:26:14.090 ************ 
Среда 19 июня 2024  16:14:04 +0300 (0:00:00.040)       0:26:14.130 ************ 

TASK [kubernetes/client : Wait for k8s apiserver] ******************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.992)       0:26:15.123 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.035)       0:26:15.159 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.060)       0:26:15.219 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.073)       0:26:15.293 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.025)       0:26:15.319 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.025)       0:26:15.344 ************ 
Среда 19 июня 2024  16:14:05 +0300 (0:00:00.052)       0:26:15.397 ************ 

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Wait for kube-apiserver] ***********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:08 +0300 (0:00:02.721)       0:26:18.118 ************ 

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Add ClusterRoleBinding to admit nodes] *********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:11 +0300 (0:00:02.956)       0:26:21.075 ************ 
Среда 19 июня 2024  16:14:11 +0300 (0:00:00.165)       0:26:21.241 ************ 

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Remove old webhook ClusterRole] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:12 +0300 (0:00:01.394)       0:26:22.635 ************ 

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Remove old webhook ClusterRoleBinding] *********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:14 +0300 (0:00:01.115)       0:26:23.751 ************ 
Среда 19 июня 2024  16:14:14 +0300 (0:00:00.075)       0:26:23.826 ************ 

TASK [kubernetes-apps/cluster_roles : PriorityClass | Copy k8s-cluster-critical-pc.yml file] ***********************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:14:17 +0300 (0:00:03.388)       0:26:27.214 ************ 

TASK [kubernetes-apps/cluster_roles : PriorityClass | Create k8s-cluster-critical] *********************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]

PLAY [Invoke kubeadm and install a CNI] ****************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:14:18 +0300 (0:00:01.364)       0:26:28.579 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.115)       0:26:28.694 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.045)       0:26:28.740 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.118)       0:26:28.858 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.046)       0:26:28.904 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.127)       0:26:29.031 ************ 
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.160)       0:26:29.192 ************ 

TASK [kubernetes/kubeadm : Set kubeadm_discovery_address] **********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:19 +0300 (0:00:00.191)       0:26:29.384 ************ 

TASK [kubernetes/kubeadm : Check if kubelet.conf exists] ***********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:22 +0300 (0:00:02.437)       0:26:31.822 ************ 

TASK [kubernetes/kubeadm : Check if kubeadm CA cert is accessible] *************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:22 +0300 (0:00:00.780)       0:26:32.602 ************ 

TASK [kubernetes/kubeadm : Calculate kubeadm CA cert hash] *********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:23 +0300 (0:00:00.916)       0:26:33.519 ************ 

TASK [kubernetes/kubeadm : Create kubeadm token for joining nodes with 24h expiration (default)] *******************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au -> fhmibjl39dmiukfvfsd4(158.160.97.146)]
ok: [fhm4jldk6ls9qm2tclqm -> fhmibjl39dmiukfvfsd4(158.160.97.146)]
ok: [fhm1q990n3ve0rlv7q48 -> fhmibjl39dmiukfvfsd4(158.160.97.146)]
Среда 19 июня 2024  16:14:25 +0300 (0:00:01.397)       0:26:34.916 ************ 

TASK [kubernetes/kubeadm : Set kubeadm_token to generated token] ***************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:25 +0300 (0:00:00.152)       0:26:35.068 ************ 

TASK [kubernetes/kubeadm : Set kubeadm api version to v1beta3] *****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:25 +0300 (0:00:00.166)       0:26:35.236 ************ 
Среда 19 июня 2024  16:14:25 +0300 (0:00:00.038)       0:26:35.274 ************ 
Среда 19 июня 2024  16:14:25 +0300 (0:00:00.146)       0:26:35.421 ************ 

TASK [kubernetes/kubeadm : Create kubeadm client config] ***********************************************************************************************************************************************************************************
changed: [fhmav03g08hr6feh31au]
changed: [fhm4jldk6ls9qm2tclqm]
changed: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:14:30 +0300 (0:00:04.497)       0:26:39.919 ************ 
Среда 19 июня 2024  16:14:30 +0300 (0:00:00.178)       0:26:40.097 ************ 
Среда 19 июня 2024  16:14:30 +0300 (0:00:00.138)       0:26:40.236 ************ 

TASK [kubernetes/kubeadm : Join to cluster] ************************************************************************************************************************************************************************************************
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhm4jldk6ls9qm2tclqm]
changed: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:14:34 +0300 (0:00:03.806)       0:26:44.042 ************ 
Среда 19 июня 2024  16:14:34 +0300 (0:00:00.129)       0:26:44.172 ************ 

TASK [kubernetes/kubeadm : Update server field in kubelet kubeconfig] **********************************************************************************************************************************************************************
changed: [fhm4jldk6ls9qm2tclqm]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:14:36 +0300 (0:00:02.128)       0:26:46.301 ************ 
Среда 19 июня 2024  16:14:36 +0300 (0:00:00.147)       0:26:46.448 ************ 

TASK [kubernetes/kubeadm : Update server field in kube-proxy kubeconfig] *******************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:38 +0300 (0:00:02.140)       0:26:48.588 ************ 
Среда 19 июня 2024  16:14:38 +0300 (0:00:00.052)       0:26:48.641 ************ 

TASK [kubernetes/kubeadm : Set ca.crt file permission] *************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:41 +0300 (0:00:02.410)       0:26:51.052 ************ 

TASK [kubernetes/kubeadm : Restart all kube-proxy pods to ensure that they load the new configmap] *****************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:44 +0300 (0:00:02.985)       0:26:54.037 ************ 
Среда 19 июня 2024  16:14:44 +0300 (0:00:00.154)       0:26:54.192 ************ 

TASK [kubernetes/node-label : Kubernetes Apps | Wait for kube-apiserver] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:14:46 +0300 (0:00:02.110)       0:26:56.303 ************ 

TASK [kubernetes/node-label : Set role node label to empty list] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:46 +0300 (0:00:00.144)       0:26:56.448 ************ 
Среда 19 июня 2024  16:14:46 +0300 (0:00:00.131)       0:26:56.579 ************ 

TASK [kubernetes/node-label : Set inventory node label to empty list] **********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.133)       0:26:56.713 ************ 
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.211)       0:26:56.924 ************ 

TASK [kubernetes/node-label : debug] *******************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "role_node_labels": []
}
ok: [fhm23nh49uft58qu43qa] => {
    "role_node_labels": []
}
ok: [fhms56jfu94iaefdph12] => {
    "role_node_labels": []
}
ok: [fhmav03g08hr6feh31au] => {
    "role_node_labels": []
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "role_node_labels": []
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "role_node_labels": []
}
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.140)       0:26:57.065 ************ 

TASK [kubernetes/node-label : debug] *******************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "inventory_node_labels": []
}
ok: [fhm23nh49uft58qu43qa] => {
    "inventory_node_labels": []
}
ok: [fhms56jfu94iaefdph12] => {
    "inventory_node_labels": []
}
ok: [fhmav03g08hr6feh31au] => {
    "inventory_node_labels": []
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "inventory_node_labels": []
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "inventory_node_labels": []
}
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.140)       0:26:57.205 ************ 
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.141)       0:26:57.347 ************ 

TASK [kubernetes/node-taint : Set role and inventory node taint to empty list] *************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.157)       0:26:57.504 ************ 
Среда 19 июня 2024  16:14:47 +0300 (0:00:00.121)       0:26:57.625 ************ 
Среда 19 июня 2024  16:14:48 +0300 (0:00:00.104)       0:26:57.730 ************ 

TASK [kubernetes/node-taint : debug] *******************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "role_node_taints": []
}
ok: [fhm23nh49uft58qu43qa] => {
    "role_node_taints": []
}
ok: [fhms56jfu94iaefdph12] => {
    "role_node_taints": []
}
ok: [fhmav03g08hr6feh31au] => {
    "role_node_taints": []
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "role_node_taints": []
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "role_node_taints": []
}
Среда 19 июня 2024  16:14:48 +0300 (0:00:00.124)       0:26:57.855 ************ 

TASK [kubernetes/node-taint : debug] *******************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "inventory_node_taints": []
}
ok: [fhm23nh49uft58qu43qa] => {
    "inventory_node_taints": []
}
ok: [fhms56jfu94iaefdph12] => {
    "inventory_node_taints": []
}
ok: [fhmav03g08hr6feh31au] => {
    "inventory_node_taints": []
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "inventory_node_taints": []
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "inventory_node_taints": []
}
Среда 19 июня 2024  16:14:48 +0300 (0:00:00.144)       0:26:58.000 ************ 
Среда 19 июня 2024  16:14:48 +0300 (0:00:00.156)       0:26:58.157 ************ 

TASK [network_plugin/cni : CNI | make sure /opt/cni/bin exists] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:14:50 +0300 (0:00:02.063)       0:27:00.220 ************ 

TASK [network_plugin/cni : CNI | Copy cni plugins] *****************************************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhmav03g08hr6feh31au]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:15:03 +0300 (0:00:13.265)       0:27:13.486 ************ 
Среда 19 июня 2024  16:15:03 +0300 (0:00:00.137)       0:27:13.624 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.107)       0:27:13.731 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.108)       0:27:13.840 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.107)       0:27:13.948 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.128)       0:27:14.076 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.127)       0:27:14.204 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.123)       0:27:14.328 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.122)       0:27:14.450 ************ 
Среда 19 июня 2024  16:15:04 +0300 (0:00:00.133)       0:27:14.583 ************ 
Среда 19 июня 2024  16:15:05 +0300 (0:00:00.190)       0:27:14.774 ************ 

TASK [network_plugin/calico : Slurp CNI config] ********************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:15:12 +0300 (0:00:07.619)       0:27:22.394 ************ 
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.365)       0:27:22.759 ************ 
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.127)       0:27:22.887 ************ 
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.129)       0:27:23.016 ************ 

TASK [network_plugin/calico : Calico | Gather os specific variables] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [fhmav03g08hr6feh31au] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [fhm1q990n3ve0rlv7q48] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [fhm4jldk6ls9qm2tclqm] => (item=kubernetes-prod/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.152)       0:27:23.169 ************ 
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.104)       0:27:23.273 ************ 

TASK [network_plugin/calico : Calico install] **********************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/network_plugin/calico/tasks/install.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12, fhmav03g08hr6feh31au, fhm1q990n3ve0rlv7q48, fhm4jldk6ls9qm2tclqm
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.205)       0:27:23.478 ************ 
Среда 19 июня 2024  16:15:13 +0300 (0:00:00.121)       0:27:23.599 ************ 

TASK [network_plugin/calico : Calico | Copy calicoctl binary from download dir] ************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm23nh49uft58qu43qa]
changed: [fhmav03g08hr6feh31au]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhms56jfu94iaefdph12]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:15:20 +0300 (0:00:06.090)       0:27:29.690 ************ 
Среда 19 июня 2024  16:15:20 +0300 (0:00:00.122)       0:27:29.813 ************ 
Среда 19 июня 2024  16:15:20 +0300 (0:00:00.127)       0:27:29.940 ************ 
Среда 19 июня 2024  16:15:20 +0300 (0:00:00.104)       0:27:30.045 ************ 
Среда 19 июня 2024  16:15:20 +0300 (0:00:00.105)       0:27:30.151 ************ 

TASK [network_plugin/calico : Calico | Install calicoctl wrapper script] *******************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhmav03g08hr6feh31au]
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:15:32 +0300 (0:00:12.156)       0:27:42.307 ************ 
Среда 19 июня 2024  16:15:32 +0300 (0:00:00.031)       0:27:42.339 ************ 

TASK [network_plugin/calico : Calico | Check if calico network pool has already been configured] *******************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:35 +0300 (0:00:02.813)       0:27:45.152 ************ 
Среда 19 июня 2024  16:15:35 +0300 (0:00:00.112)       0:27:45.264 ************ 
Среда 19 июня 2024  16:15:35 +0300 (0:00:00.116)       0:27:45.381 ************ 
Среда 19 июня 2024  16:15:35 +0300 (0:00:00.132)       0:27:45.513 ************ 

TASK [network_plugin/calico : Calico | Check if extra directory is needed] *****************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:15:37 +0300 (0:00:01.335)       0:27:46.849 ************ 
Среда 19 июня 2024  16:15:37 +0300 (0:00:00.117)       0:27:46.966 ************ 

TASK [network_plugin/calico : Calico | Set kdd path when calico > v3.22.2] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:15:37 +0300 (0:00:00.113)       0:27:47.080 ************ 

TASK [network_plugin/calico : Calico | Create calico manifests for kdd] ********************************************************************************************************************************************************************
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm23nh49uft58qu43qa]
Среда 19 июня 2024  16:15:39 +0300 (0:00:02.301)       0:27:49.382 ************ 

TASK [network_plugin/calico : Calico | Create Calico Kubernetes datastore resources] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:42 +0300 (0:00:03.013)       0:27:52.396 ************ 

TASK [network_plugin/calico : Calico | Get existing FelixConfiguration] ********************************************************************************************************************************************************************
fatal: [fhmibjl39dmiukfvfsd4]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "felixconfig", "default", "-o", "json"], "delta": "0:00:00.109039", "end": "2024-06-19 13:15:44.001735", "msg": "non-zero return code", "rc": 1, "start": "2024-06-19 13:15:43.892696", "stderr": "resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Среда 19 июня 2024  16:15:44 +0300 (0:00:01.456)       0:27:53.852 ************ 

TASK [network_plugin/calico : Calico | Set kubespray FelixConfiguration] *******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:44 +0300 (0:00:00.116)       0:27:53.968 ************ 
Среда 19 июня 2024  16:15:44 +0300 (0:00:00.109)       0:27:54.078 ************ 

TASK [network_plugin/calico : Calico | Configure calico FelixConfiguration] ****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:45 +0300 (0:00:01.333)       0:27:55.412 ************ 

TASK [network_plugin/calico : Calico | Get existing calico network pool] *******************************************************************************************************************************************************************
fatal: [fhmibjl39dmiukfvfsd4]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "ippool", "default-pool", "-o", "json"], "delta": "0:00:00.322814", "end": "2024-06-19 13:15:47.469359", "msg": "non-zero return code", "rc": 1, "start": "2024-06-19 13:15:47.146545", "stderr": "resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found", "stderr_lines": ["resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Среда 19 июня 2024  16:15:47 +0300 (0:00:01.883)       0:27:57.295 ************ 

TASK [network_plugin/calico : Calico | Set kubespray calico network pool] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:47 +0300 (0:00:00.121)       0:27:57.417 ************ 
Среда 19 июня 2024  16:15:47 +0300 (0:00:00.131)       0:27:57.549 ************ 
Среда 19 июня 2024  16:15:48 +0300 (0:00:00.113)       0:27:57.663 ************ 

TASK [network_plugin/calico : Calico | Configure calico network pool] **********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:49 +0300 (0:00:01.624)       0:27:59.287 ************ 
Среда 19 июня 2024  16:15:49 +0300 (0:00:00.124)       0:27:59.412 ************ 
Среда 19 июня 2024  16:15:49 +0300 (0:00:00.123)       0:27:59.536 ************ 
Среда 19 июня 2024  16:15:49 +0300 (0:00:00.112)       0:27:59.648 ************ 
Среда 19 июня 2024  16:15:50 +0300 (0:00:00.108)       0:27:59.757 ************ 
Среда 19 июня 2024  16:15:50 +0300 (0:00:00.113)       0:27:59.871 ************ 
Среда 19 июня 2024  16:15:50 +0300 (0:00:00.022)       0:27:59.894 ************ 
Среда 19 июня 2024  16:15:50 +0300 (0:00:00.022)       0:27:59.916 ************ 
Среда 19 июня 2024  16:15:50 +0300 (0:00:00.028)       0:27:59.945 ************ 

TASK [network_plugin/calico : Calico | Get existing BGP Configuration] *********************************************************************************************************************************************************************
fatal: [fhmibjl39dmiukfvfsd4]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "bgpconfig", "default", "-o", "json"], "delta": "0:00:00.092780", "end": "2024-06-19 13:15:51.205773", "msg": "non-zero return code", "rc": 1, "start": "2024-06-19 13:15:51.112993", "stderr": "resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Среда 19 июня 2024  16:15:51 +0300 (0:00:01.177)       0:28:01.122 ************ 

TASK [network_plugin/calico : Calico | Set kubespray BGP Configuration] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:51 +0300 (0:00:00.120)       0:28:01.243 ************ 
Среда 19 июня 2024  16:15:51 +0300 (0:00:00.216)       0:28:01.459 ************ 

TASK [network_plugin/calico : Calico | Set up BGP Configuration] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:15:53 +0300 (0:00:01.229)       0:28:02.688 ************ 

TASK [network_plugin/calico : Calico | Create calico manifests] ****************************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-config', 'file': 'calico-config.yml', 'type': 'cm'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico-config', 'file': 'calico-config.yml', 'type': 'cm'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico-config', 'file': 'calico-config.yml', 'type': 'cm'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-node', 'file': 'calico-node.yml', 'type': 'ds'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico-node', 'file': 'calico-node.yml', 'type': 'ds'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico-node', 'file': 'calico-node.yml', 'type': 'ds'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico', 'file': 'calico-node-sa.yml', 'type': 'sa'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico', 'file': 'calico-node-sa.yml', 'type': 'sa'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico', 'file': 'calico-node-sa.yml', 'type': 'sa'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico', 'file': 'calico-cr.yml', 'type': 'clusterrole'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico', 'file': 'calico-cr.yml', 'type': 'clusterrole'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico', 'file': 'calico-cr.yml', 'type': 'clusterrole'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico', 'file': 'calico-crb.yml', 'type': 'clusterrolebinding'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico', 'file': 'calico-crb.yml', 'type': 'clusterrolebinding'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico', 'file': 'calico-crb.yml', 'type': 'clusterrolebinding'})
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'kubernetes-services-endpoint', 'file': 'kubernetes-services-endpoint.yml', 'type': 'cm'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'kubernetes-services-endpoint', 'file': 'kubernetes-services-endpoint.yml', 'type': 'cm'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'kubernetes-services-endpoint', 'file': 'kubernetes-services-endpoint.yml', 'type': 'cm'})
Среда 19 июня 2024  16:16:35 +0300 (0:00:42.052)       0:28:44.741 ************ 
Среда 19 июня 2024  16:16:35 +0300 (0:00:00.116)       0:28:44.858 ************ 
Среда 19 июня 2024  16:16:35 +0300 (0:00:00.105)       0:28:44.964 ************ 
Среда 19 июня 2024  16:16:35 +0300 (0:00:00.102)       0:28:45.066 ************ 
Среда 19 июня 2024  16:16:35 +0300 (0:00:00.118)       0:28:45.185 ************ 

TASK [network_plugin/calico : Start Calico resources] **************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-config.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-node.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-node-sa.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-cr.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-crb.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes-services-endpoint.yml)
Среда 19 июня 2024  16:16:47 +0300 (0:00:12.458)       0:28:57.643 ************ 
Среда 19 июня 2024  16:16:48 +0300 (0:00:00.124)       0:28:57.768 ************ 

TASK [network_plugin/calico : Wait for calico kubeconfig to be created] ********************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:16:49 +0300 (0:00:01.433)       0:28:59.201 ************ 

TASK [network_plugin/calico : Calico | Create Calico ipam manifests] ***********************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa] => (item={'name': 'calico', 'file': 'calico-ipamconfig.yml', 'type': 'ipam'})
changed: [fhms56jfu94iaefdph12] => (item={'name': 'calico', 'file': 'calico-ipamconfig.yml', 'type': 'ipam'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico', 'file': 'calico-ipamconfig.yml', 'type': 'ipam'})
Среда 19 июня 2024  16:16:54 +0300 (0:00:04.512)       0:29:03.714 ************ 

TASK [network_plugin/calico : Calico | Create ipamconfig resources] ************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:16:57 +0300 (0:00:03.663)       0:29:07.377 ************ 
Среда 19 июня 2024  16:16:57 +0300 (0:00:00.148)       0:29:07.525 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.272)       0:29:07.798 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.114)       0:29:07.913 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.164)       0:29:08.077 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.109)       0:29:08.186 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.151)       0:29:08.337 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.126)       0:29:08.464 ************ 
Среда 19 июня 2024  16:16:58 +0300 (0:00:00.124)       0:29:08.588 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.105)       0:29:08.693 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.101)       0:29:08.795 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.101)       0:29:08.897 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.130)       0:29:09.027 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.099)       0:29:09.127 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.235)       0:29:09.363 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.116)       0:29:09.479 ************ 
Среда 19 июня 2024  16:16:59 +0300 (0:00:00.133)       0:29:09.613 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.126)       0:29:09.739 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.100)       0:29:09.840 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.101)       0:29:09.941 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.138)       0:29:10.080 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.124)       0:29:10.205 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.168)       0:29:10.373 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.119)       0:29:10.493 ************ 
Среда 19 июня 2024  16:17:00 +0300 (0:00:00.110)       0:29:10.604 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.101)       0:29:10.705 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.207)       0:29:10.913 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.118)       0:29:11.031 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.111)       0:29:11.143 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.100)       0:29:11.244 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.101)       0:29:11.345 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.100)       0:29:11.445 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.099)       0:29:11.545 ************ 
Среда 19 июня 2024  16:17:01 +0300 (0:00:00.069)       0:29:11.615 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.125)       0:29:11.740 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.101)       0:29:11.842 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.102)       0:29:11.944 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.104)       0:29:12.048 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.105)       0:29:12.153 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.100)       0:29:12.254 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.260)       0:29:12.515 ************ 
Среда 19 июня 2024  16:17:02 +0300 (0:00:00.114)       0:29:12.630 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.110)       0:29:12.740 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.102)       0:29:12.842 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.151)       0:29:12.994 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.102)       0:29:13.097 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.019)       0:29:13.117 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.063)       0:29:13.180 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.134)       0:29:13.315 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.102)       0:29:13.417 ************ 
Среда 19 июня 2024  16:17:03 +0300 (0:00:00.237)       0:29:13.655 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.122)       0:29:13.777 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.214)       0:29:13.992 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.104)       0:29:14.096 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.105)       0:29:14.201 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.102)       0:29:14.304 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.106)       0:29:14.410 ************ 
Среда 19 июня 2024  16:17:04 +0300 (0:00:00.161)       0:29:14.572 ************ 
Среда 19 июня 2024  16:17:05 +0300 (0:00:00.109)       0:29:14.682 ************ 
Среда 19 июня 2024  16:17:05 +0300 (0:00:00.110)       0:29:14.792 ************ 
Среда 19 июня 2024  16:17:05 +0300 (0:00:00.108)       0:29:14.901 ************ 
Среда 19 июня 2024  16:17:05 +0300 (0:00:00.264)       0:29:15.165 ************ 

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload systemd] ****************************************************************************************************************************************************************************
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
Среда 19 июня 2024  16:17:08 +0300 (0:00:02.602)       0:29:17.768 ************ 

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload kubelet] ****************************************************************************************************************************************************************************
changed: [fhm4jldk6ls9qm2tclqm]
changed: [fhmav03g08hr6feh31au]
changed: [fhm1q990n3ve0rlv7q48]

PLAY [Install Calico Route Reflector] ******************************************************************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Patch Kubernetes for Windows] ********************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:17:10 +0300 (0:00:02.508)       0:29:20.276 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.105)       0:29:20.382 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.033)       0:29:20.415 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.032)       0:29:20.448 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.034)       0:29:20.483 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.041)       0:29:20.525 ************ 
Среда 19 июня 2024  16:17:10 +0300 (0:00:00.036)       0:29:20.561 ************ 

TASK [win_nodes/kubernetes_patch : Ensure that user manifests directory exists] ************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:17:12 +0300 (0:00:01.552)       0:29:22.114 ************ 

TASK [win_nodes/kubernetes_patch : Check current nodeselector for kube-proxy daemonset] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:17:13 +0300 (0:00:01.464)       0:29:23.578 ************ 

TASK [win_nodes/kubernetes_patch : Apply nodeselector patch for kube-proxy daemonset] ******************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:17:15 +0300 (0:00:01.410)       0:29:24.988 ************ 

TASK [win_nodes/kubernetes_patch : debug] **************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": [
        "daemonset.apps/kube-proxy patched (no change)"
    ]
}
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.047)       0:29:25.035 ************ 

TASK [win_nodes/kubernetes_patch : debug] **************************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": []
}

PLAY [Install Kubernetes apps] *************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.163)       0:29:25.199 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.110)       0:29:25.309 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.039)       0:29:25.348 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.068)       0:29:25.417 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.038)       0:29:25.456 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.078)       0:29:25.534 ************ 
Среда 19 июня 2024  16:17:15 +0300 (0:00:00.089)       0:29:25.623 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.059)       0:29:25.683 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.058)       0:29:25.741 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.062)       0:29:25.803 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.080)       0:29:25.883 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.091)       0:29:25.975 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.056)       0:29:26.032 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.068)       0:29:26.100 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.073)       0:29:26.174 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.058)       0:29:26.232 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.066)       0:29:26.299 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.116)       0:29:26.416 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.064)       0:29:26.481 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.092)       0:29:26.573 ************ 
Среда 19 июня 2024  16:17:16 +0300 (0:00:00.062)       0:29:26.636 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.059)       0:29:26.696 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.062)       0:29:26.758 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.081)       0:29:26.839 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.131)       0:29:26.971 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.070)       0:29:27.041 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.069)       0:29:27.111 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.099)       0:29:27.210 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.051)       0:29:27.262 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.074)       0:29:27.336 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.035)       0:29:27.372 ************ 
Среда 19 июня 2024  16:17:17 +0300 (0:00:00.056)       0:29:27.428 ************ 
Среда 19 июня 2024  16:17:18 +0300 (0:00:00.312)       0:29:27.741 ************ 

TASK [policy_controller/calico : Create calico-kube-controllers manifests] *****************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-controllers.yml', 'type': 'deployment'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-sa.yml', 'type': 'sa'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-cr.yml', 'type': 'clusterrole'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-crb.yml', 'type': 'clusterrolebinding'})
Среда 19 июня 2024  16:17:47 +0300 (0:00:29.730)       0:29:57.472 ************ 

TASK [policy_controller/calico : Start of Calico kube controllers] *************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-kube-controllers.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-kube-sa.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-kube-cr.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=calico-kube-crb.yml)
Среда 19 июня 2024  16:17:59 +0300 (0:00:12.036)       0:30:09.508 ************ 
Среда 19 июня 2024  16:17:59 +0300 (0:00:00.060)       0:30:09.568 ************ 
Среда 19 июня 2024  16:17:59 +0300 (0:00:00.059)       0:30:09.628 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.061)       0:30:09.689 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.053)       0:30:09.743 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.053)       0:30:09.797 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.077)       0:30:09.874 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.055)       0:30:09.929 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.053)       0:30:09.982 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.052)       0:30:10.035 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.060)       0:30:10.096 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.055)       0:30:10.151 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.073)       0:30:10.225 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.060)       0:30:10.285 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.079)       0:30:10.365 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.145)       0:30:10.511 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.089)       0:30:10.601 ************ 
Среда 19 июня 2024  16:18:00 +0300 (0:00:00.054)       0:30:10.655 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.064)       0:30:10.720 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.053)       0:30:10.774 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.072)       0:30:10.846 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.062)       0:30:10.909 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.174)       0:30:11.084 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.059)       0:30:11.143 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.053)       0:30:11.197 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.054)       0:30:11.252 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.058)       0:30:11.311 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.073)       0:30:11.384 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.052)       0:30:11.436 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.058)       0:30:11.495 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.052)       0:30:11.547 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.052)       0:30:11.600 ************ 
Среда 19 июня 2024  16:18:01 +0300 (0:00:00.052)       0:30:11.653 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.059)       0:30:11.713 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.072)       0:30:11.785 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.052)       0:30:11.838 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.058)       0:30:11.896 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.053)       0:30:11.949 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.053)       0:30:12.003 ************ 
Среда 19 июня 2024  16:18:02 +0300 (0:00:00.090)       0:30:12.094 ************ 

TASK [kubernetes-apps/ansible : Kubernetes Apps | Wait for kube-apiserver] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:18:07 +0300 (0:00:05.098)       0:30:17.193 ************ 

TASK [kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates] **************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-clusterrole.yml', 'type': 'clusterrole'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-clusterrolebinding.yml', 'type': 'clusterrolebinding'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-config.yml', 'type': 'configmap'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-deployment.yml', 'type': 'deployment'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-sa.yml', 'type': 'sa'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-svc.yml', 'type': 'svc'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler.yml', 'type': 'deployment'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-clusterrole.yml', 'type': 'clusterrole'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-clusterrolebinding.yml', 'type': 'clusterrolebinding'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'coredns', 'file': 'coredns-poddisruptionbudget.yml', 'type': 'poddisruptionbudget', 'condition': 'coredns_pod_disruption_budget'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-sa.yml', 'type': 'sa'})
Среда 19 июня 2024  16:19:22 +0300 (0:01:15.095)       0:31:32.288 ************ 
Среда 19 июня 2024  16:19:22 +0300 (0:00:00.075)       0:31:32.363 ************ 

TASK [kubernetes-apps/ansible : Kubernetes Apps | set up necessary nodelocaldns parameters] ************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:19:22 +0300 (0:00:00.089)       0:31:32.453 ************ 

TASK [kubernetes-apps/ansible : Kubernetes Apps | Lay Down nodelocaldns Template] **********************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-config.yml', 'type': 'configmap'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-sa.yml', 'type': 'sa'})
changed: [fhmibjl39dmiukfvfsd4] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-daemonset.yml', 'type': 'daemonset'})
Среда 19 июня 2024  16:19:38 +0300 (0:00:16.050)       0:31:48.503 ************ 
Среда 19 июня 2024  16:19:38 +0300 (0:00:00.086)       0:31:48.590 ************ 

TASK [kubernetes-apps/ansible : Kubernetes Apps | Start Resources] *************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-clusterrole.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-clusterrolebinding.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-config.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-deployment.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-sa.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-svc.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=dns-autoscaler.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=dns-autoscaler-clusterrole.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=dns-autoscaler-clusterrolebinding.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=coredns-poddisruptionbudget.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=dns-autoscaler-sa.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=nodelocaldns-config.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=nodelocaldns-sa.yml)
ok: [fhmibjl39dmiukfvfsd4] => (item=nodelocaldns-daemonset.yml)
Среда 19 июня 2024  16:20:05 +0300 (0:00:26.521)       0:32:15.111 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.074)       0:32:15.186 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.067)       0:32:15.254 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.058)       0:32:15.312 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.059)       0:32:15.371 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.072)       0:32:15.444 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.065)       0:32:15.509 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.066)       0:32:15.576 ************ 
Среда 19 июня 2024  16:20:05 +0300 (0:00:00.065)       0:32:15.641 ************ 
Среда 19 июня 2024  16:20:06 +0300 (0:00:00.090)       0:32:15.732 ************ 

TASK [kubernetes-apps/helm : Helm | Gather os specific variables] **************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=kubernetes-prod/kubespray/roles/kubernetes-apps/helm/vars/../vars/ubuntu.yml)
ok: [fhm23nh49uft58qu43qa] => (item=kubernetes-prod/kubespray/roles/kubernetes-apps/helm/vars/../vars/ubuntu.yml)
ok: [fhms56jfu94iaefdph12] => (item=kubernetes-prod/kubespray/roles/kubernetes-apps/helm/vars/../vars/ubuntu.yml)
Среда 19 июня 2024  16:20:06 +0300 (0:00:00.078)       0:32:15.811 ************ 

TASK [kubernetes-apps/helm : Helm | Install PyYaml] ****************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:12 +0300 (0:00:06.698)       0:32:22.509 ************ 
Среда 19 июня 2024  16:20:12 +0300 (0:00:00.077)       0:32:22.587 ************ 

TASK [kubernetes-apps/helm : Helm | Download helm] *****************************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/kubernetes-apps/helm/tasks/../../../download/tasks/download_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:20:13 +0300 (0:00:00.087)       0:32:22.674 ************ 

TASK [kubernetes-apps/helm : Prep_download | Set a few facts] ******************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:13 +0300 (0:00:00.396)       0:32:23.071 ************ 

TASK [kubernetes-apps/helm : Download_file | Show url of file to dowload] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
ok: [fhm23nh49uft58qu43qa] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
ok: [fhms56jfu94iaefdph12] => {
    "msg": "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz"
}
Среда 19 июня 2024  16:20:14 +0300 (0:00:00.733)       0:32:23.804 ************ 

TASK [kubernetes-apps/helm : Download_file | Set pathname of cached file] ******************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:14 +0300 (0:00:00.732)       0:32:24.536 ************ 

TASK [kubernetes-apps/helm : Download_file | Create dest directory on node] ****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:18 +0300 (0:00:03.165)       0:32:27.701 ************ 
Среда 19 июня 2024  16:20:18 +0300 (0:00:00.034)       0:32:27.736 ************ 
Среда 19 июня 2024  16:20:18 +0300 (0:00:00.046)       0:32:27.782 ************ 

TASK [kubernetes-apps/helm : Download_file | Download item] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:24 +0300 (0:00:06.157)       0:32:33.940 ************ 
Среда 19 июня 2024  16:20:24 +0300 (0:00:00.066)       0:32:34.006 ************ 
Среда 19 июня 2024  16:20:24 +0300 (0:00:00.062)       0:32:34.068 ************ 
Среда 19 июня 2024  16:20:24 +0300 (0:00:00.066)       0:32:34.135 ************ 

TASK [kubernetes-apps/helm : Download_file | Extract file archives] ************************************************************************************************************************************************************************
included: kubernetes-prod/kubespray/roles/download/tasks/extract_file.yml for fhmibjl39dmiukfvfsd4, fhm23nh49uft58qu43qa, fhms56jfu94iaefdph12
Среда 19 июня 2024  16:20:24 +0300 (0:00:00.099)       0:32:34.234 ************ 

TASK [kubernetes-apps/helm : Extract_file | Unpacking archive] *****************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:34 +0300 (0:00:10.380)       0:32:44.615 ************ 

TASK [kubernetes-apps/helm : Helm | Copy helm binary from download dir] ********************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhms56jfu94iaefdph12]
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:20:42 +0300 (0:00:07.642)       0:32:52.257 ************ 

TASK [kubernetes-apps/helm : Helm | Get helm completion] ***********************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:20:44 +0300 (0:00:02.178)       0:32:54.435 ************ 

TASK [kubernetes-apps/helm : Helm | Install helm completion] *******************************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhms56jfu94iaefdph12]
Среда 19 июня 2024  16:20:53 +0300 (0:00:08.792)       0:33:03.228 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.057)       0:33:03.286 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.054)       0:33:03.340 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.058)       0:33:03.398 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.075)       0:33:03.474 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.067)       0:33:03.542 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.065)       0:33:03.607 ************ 
Среда 19 июня 2024  16:20:53 +0300 (0:00:00.029)       0:33:03.637 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.028)       0:33:03.666 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.027)       0:33:03.693 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.027)       0:33:03.721 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.026)       0:33:03.748 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.050)       0:33:03.798 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.054)       0:33:03.852 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.053)       0:33:03.906 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.056)       0:33:03.963 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.053)       0:33:04.017 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.053)       0:33:04.071 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.056)       0:33:04.127 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.065)       0:33:04.193 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.055)       0:33:04.248 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.054)       0:33:04.303 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.060)       0:33:04.363 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.093)       0:33:04.457 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.063)       0:33:04.520 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.061)       0:33:04.582 ************ 
Среда 19 июня 2024  16:20:54 +0300 (0:00:00.065)       0:33:04.647 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.167)       0:33:04.814 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.062)       0:33:04.877 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.075)       0:33:04.953 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.072)       0:33:05.026 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.086)       0:33:05.112 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.056)       0:33:05.168 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.040)       0:33:05.208 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.053)       0:33:05.262 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.057)       0:33:05.319 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.082)       0:33:05.401 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.115)       0:33:05.516 ************ 
Среда 19 июня 2024  16:20:55 +0300 (0:00:00.081)       0:33:05.598 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.098)       0:33:05.696 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.053)       0:33:05.750 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.052)       0:33:05.803 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.054)       0:33:05.857 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.079)       0:33:05.937 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.098)       0:33:06.035 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.050)       0:33:06.085 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.057)       0:33:06.142 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.052)       0:33:06.195 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.073)       0:33:06.269 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.096)       0:33:06.365 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.058)       0:33:06.424 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.064)       0:33:06.488 ************ 
Среда 19 июня 2024  16:20:56 +0300 (0:00:00.081)       0:33:06.569 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.104)       0:33:06.674 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.057)       0:33:06.732 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.059)       0:33:06.791 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.086)       0:33:06.877 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.081)       0:33:06.959 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.060)       0:33:07.019 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.076)       0:33:07.096 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.054)       0:33:07.150 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.071)       0:33:07.222 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.058)       0:33:07.281 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.072)       0:33:07.353 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.056)       0:33:07.409 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.084)       0:33:07.494 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.058)       0:33:07.552 ************ 
Среда 19 июня 2024  16:20:57 +0300 (0:00:00.079)       0:33:07.632 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.053)       0:33:07.686 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.071)       0:33:07.758 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.058)       0:33:07.816 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.090)       0:33:07.906 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.058)       0:33:07.965 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.066)       0:33:08.032 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.083)       0:33:08.115 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.059)       0:33:08.174 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.088)       0:33:08.263 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.058)       0:33:08.321 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.054)       0:33:08.376 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.058)       0:33:08.435 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.084)       0:33:08.520 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.059)       0:33:08.579 ************ 
Среда 19 июня 2024  16:20:58 +0300 (0:00:00.055)       0:33:08.635 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.054)       0:33:08.690 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.080)       0:33:08.770 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.055)       0:33:08.825 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.076)       0:33:08.901 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.054)       0:33:08.956 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.091)       0:33:09.048 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.062)       0:33:09.110 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.052)       0:33:09.163 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.052)       0:33:09.216 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.058)       0:33:09.275 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.063)       0:33:09.338 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.212)       0:33:09.551 ************ 
Среда 19 июня 2024  16:20:59 +0300 (0:00:00.074)       0:33:09.626 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.059)       0:33:09.685 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.059)       0:33:09.745 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.069)       0:33:09.814 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.060)       0:33:09.874 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.059)       0:33:09.933 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.059)       0:33:09.993 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.069)       0:33:10.062 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.060)       0:33:10.123 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.058)       0:33:10.182 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.058)       0:33:10.241 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.068)       0:33:10.309 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.060)       0:33:10.370 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.064)       0:33:10.434 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.089)       0:33:10.524 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.059)       0:33:10.584 ************ 
Среда 19 июня 2024  16:21:00 +0300 (0:00:00.052)       0:33:10.636 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.053)       0:33:10.690 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.057)       0:33:10.747 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.053)       0:33:10.800 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.052)       0:33:10.853 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.056)       0:33:10.910 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.062)       0:33:10.973 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.060)       0:33:11.033 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.059)       0:33:11.092 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.052)       0:33:11.145 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.081)       0:33:11.227 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.052)       0:33:11.279 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.060)       0:33:11.340 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.057)       0:33:11.398 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.067)       0:33:11.465 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.065)       0:33:11.530 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.058)       0:33:11.589 ************ 
Среда 19 июня 2024  16:21:01 +0300 (0:00:00.062)       0:33:11.651 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.053)       0:33:11.705 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.070)       0:33:11.776 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.055)       0:33:11.832 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.091)       0:33:11.924 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.092)       0:33:12.016 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.056)       0:33:12.073 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.071)       0:33:12.144 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.053)       0:33:12.197 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.066)       0:33:12.264 ************ 
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.055)       0:33:12.320 ************ 

PLAY [Apply resolv.conf changes now that cluster DNS is up] ********************************************************************************************************************************************************************************
Среда 19 июня 2024  16:21:02 +0300 (0:00:00.297)       0:33:12.617 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.102)       0:33:12.720 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.030)       0:33:12.751 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.113)       0:33:12.864 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.032)       0:33:12.897 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.114)       0:33:13.012 ************ 
Среда 19 июня 2024  16:21:03 +0300 (0:00:00.145)       0:33:13.158 ************ 

TASK [adduser : User | Create User Group] **************************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:08 +0300 (0:00:05.100)       0:33:18.258 ************ 

TASK [adduser : User | Create User] ********************************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:16 +0300 (0:00:07.637)       0:33:25.896 ************ 
Среда 19 июня 2024  16:21:16 +0300 (0:00:00.101)       0:33:25.997 ************ 
Среда 19 июня 2024  16:21:16 +0300 (0:00:00.123)       0:33:26.121 ************ 
Среда 19 июня 2024  16:21:16 +0300 (0:00:00.101)       0:33:26.222 ************ 
Среда 19 июня 2024  16:21:16 +0300 (0:00:00.103)       0:33:26.326 ************ 
Среда 19 июня 2024  16:21:16 +0300 (0:00:00.111)       0:33:26.437 ************ 

TASK [kubernetes/preinstall : Check resolvconf] ********************************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:23 +0300 (0:00:06.673)       0:33:33.111 ************ 

TASK [kubernetes/preinstall : Check existence of /etc/resolvconf/resolv.conf.d] ************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm4jldk6ls9qm2tclqm]
ok: [fhm1q990n3ve0rlv7q48]
Среда 19 июня 2024  16:21:30 +0300 (0:00:07.158)       0:33:40.269 ************ 

TASK [kubernetes/preinstall : Check status of /etc/resolv.conf] ****************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:37 +0300 (0:00:07.027)       0:33:47.296 ************ 

TASK [kubernetes/preinstall : Get content of /etc/resolv.conf] *****************************************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:45 +0300 (0:00:07.411)       0:33:54.708 ************ 

TASK [kubernetes/preinstall : Get currently configured nameservers] ************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:45 +0300 (0:00:00.185)       0:33:54.894 ************ 

TASK [kubernetes/preinstall : Stop if /etc/resolv.conf not configured nameservers] *********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm23nh49uft58qu43qa] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhms56jfu94iaefdph12] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhmav03g08hr6feh31au] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm1q990n3ve0rlv7q48] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [fhm4jldk6ls9qm2tclqm] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:21:45 +0300 (0:00:00.138)       0:33:55.032 ************ 

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***********************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:52 +0300 (0:00:06.943)       0:34:01.976 ************ 

TASK [kubernetes/preinstall : Check systemd-resolved] **************************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:21:59 +0300 (0:00:07.609)       0:34:09.585 ************ 

TASK [kubernetes/preinstall : Set default dns if remove_default_searchdomains is false] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:00 +0300 (0:00:00.284)       0:34:09.870 ************ 

TASK [kubernetes/preinstall : Set dns facts] ***********************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:00 +0300 (0:00:00.134)       0:34:10.004 ************ 

TASK [kubernetes/preinstall : Check if kubelet is configured] ******************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:08 +0300 (0:00:08.143)       0:34:18.148 ************ 

TASK [kubernetes/preinstall : Check if early DNS configuration stage] **********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:08 +0300 (0:00:00.137)       0:34:18.285 ************ 

TASK [kubernetes/preinstall : Target resolv.conf files] ************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:08 +0300 (0:00:00.136)       0:34:18.422 ************ 
Среда 19 июня 2024  16:22:08 +0300 (0:00:00.121)       0:34:18.544 ************ 

TASK [kubernetes/preinstall : Check if /etc/dhclient.conf exists] **************************************************************************************************************************************************************************
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:16 +0300 (0:00:07.262)       0:34:25.806 ************ 
Среда 19 июня 2024  16:22:16 +0300 (0:00:00.115)       0:34:25.921 ************ 

TASK [kubernetes/preinstall : Check if /etc/dhcp/dhclient.conf exists] *********************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:24 +0300 (0:00:08.107)       0:34:34.029 ************ 

TASK [kubernetes/preinstall : Target dhclient conf file for /etc/dhcp/dhclient.conf] *******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:24 +0300 (0:00:00.146)       0:34:34.175 ************ 
Среда 19 июня 2024  16:22:24 +0300 (0:00:00.112)       0:34:34.287 ************ 

TASK [kubernetes/preinstall : Target dhclient hook file for Debian family] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:24 +0300 (0:00:00.152)       0:34:34.440 ************ 

TASK [kubernetes/preinstall : Generate search domains to resolvconf] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:24 +0300 (0:00:00.183)       0:34:34.624 ************ 

TASK [kubernetes/preinstall : Pick coredns cluster IP or default resolver] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:25 +0300 (0:00:00.322)       0:34:34.946 ************ 

TASK [kubernetes/preinstall : Generate nameservers for resolvconf, including cluster DNS] **************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm23nh49uft58qu43qa]
ok: [fhms56jfu94iaefdph12]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:25 +0300 (0:00:00.290)       0:34:35.236 ************ 
Среда 19 июня 2024  16:22:25 +0300 (0:00:00.115)       0:34:35.352 ************ 
Среда 19 июня 2024  16:22:25 +0300 (0:00:00.128)       0:34:35.481 ************ 

TASK [kubernetes/preinstall : Check /usr readonly] *****************************************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:33 +0300 (0:00:07.875)       0:34:43.357 ************ 
Среда 19 июня 2024  16:22:33 +0300 (0:00:00.126)       0:34:43.483 ************ 
Среда 19 июня 2024  16:22:33 +0300 (0:00:00.027)       0:34:43.511 ************ 
Среда 19 июня 2024  16:22:33 +0300 (0:00:00.037)       0:34:43.548 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.117)       0:34:43.666 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.111)       0:34:43.777 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.110)       0:34:43.888 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.109)       0:34:43.997 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.048)       0:34:44.045 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.114)       0:34:44.160 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.107)       0:34:44.267 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.109)       0:34:44.376 ************ 
Среда 19 июня 2024  16:22:34 +0300 (0:00:00.119)       0:34:44.496 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.234)       0:34:44.731 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.111)       0:34:44.842 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.110)       0:34:44.952 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.106)       0:34:45.059 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.110)       0:34:45.169 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.107)       0:34:45.277 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.115)       0:34:45.392 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.125)       0:34:45.518 ************ 
Среда 19 июня 2024  16:22:35 +0300 (0:00:00.124)       0:34:45.642 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.027)       0:34:45.669 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.029)       0:34:45.699 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.030)       0:34:45.730 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.028)       0:34:45.759 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.025)       0:34:45.784 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.027)       0:34:45.811 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.027)       0:34:45.838 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.025)       0:34:45.864 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.112)       0:34:45.976 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.023)       0:34:45.999 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.110)       0:34:46.110 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.025)       0:34:46.135 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.028)       0:34:46.163 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.110)       0:34:46.274 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.111)       0:34:46.385 ************ 
Среда 19 июня 2024  16:22:36 +0300 (0:00:00.229)       0:34:46.615 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.107)       0:34:46.722 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.024)       0:34:46.747 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.105)       0:34:46.852 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.109)       0:34:46.962 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.107)       0:34:47.070 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.108)       0:34:47.178 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.109)       0:34:47.288 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.150)       0:34:47.438 ************ 
Среда 19 июня 2024  16:22:37 +0300 (0:00:00.140)       0:34:47.578 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.110)       0:34:47.688 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.107)       0:34:47.795 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.130)       0:34:47.925 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.113)       0:34:48.039 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.227)       0:34:48.267 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.118)       0:34:48.385 ************ 
Среда 19 июня 2024  16:22:38 +0300 (0:00:00.119)       0:34:48.505 ************ 
Среда 19 июня 2024  16:22:39 +0300 (0:00:00.164)       0:34:48.669 ************ 
Среда 19 июня 2024  16:22:39 +0300 (0:00:00.151)       0:34:48.821 ************ 
Среда 19 июня 2024  16:22:39 +0300 (0:00:00.111)       0:34:48.932 ************ 
Среда 19 июня 2024  16:22:39 +0300 (0:00:00.111)       0:34:49.044 ************ 

TASK [kubernetes/preinstall : Create systemd-resolved drop-in directory] *******************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:22:47 +0300 (0:00:07.640)       0:34:56.685 ************ 

TASK [kubernetes/preinstall : Write Kubespray DNS settings to systemd-resolved] ************************************************************************************************************************************************************
changed: [fhm23nh49uft58qu43qa]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhms56jfu94iaefdph12]
changed: [fhmav03g08hr6feh31au]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:23:07 +0300 (0:00:20.003)       0:35:16.688 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.118)       0:35:16.807 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.112)       0:35:16.920 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.109)       0:35:17.029 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.112)       0:35:17.142 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.236)       0:35:17.379 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.137)       0:35:17.517 ************ 
Среда 19 июня 2024  16:23:07 +0300 (0:00:00.123)       0:35:17.640 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.108)       0:35:17.749 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.108)       0:35:17.857 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.104)       0:35:17.962 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.102)       0:35:18.065 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.109)       0:35:18.174 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.108)       0:35:18.283 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.111)       0:35:18.394 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.125)       0:35:18.519 ************ 
Среда 19 июня 2024  16:23:08 +0300 (0:00:00.115)       0:35:18.635 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.104)       0:35:18.739 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.230)       0:35:18.969 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.113)       0:35:19.083 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.109)       0:35:19.193 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.105)       0:35:19.298 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.114)       0:35:19.413 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.119)       0:35:19.533 ************ 
Среда 19 июня 2024  16:23:09 +0300 (0:00:00.109)       0:35:19.642 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.107)       0:35:19.749 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.145)       0:35:19.895 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.109)       0:35:20.004 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.104)       0:35:20.108 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.105)       0:35:20.214 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.208)       0:35:20.422 ************ 
Среда 19 июня 2024  16:23:10 +0300 (0:00:00.126)       0:35:20.549 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.113)       0:35:20.663 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.105)       0:35:20.768 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.110)       0:35:20.879 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.104)       0:35:20.984 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.102)       0:35:21.086 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.101)       0:35:21.187 ************ 
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.108)       0:35:21.296 ************ 

TASK [kubernetes/preinstall : Hosts | create hosts list from inventory] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4 -> localhost]
Среда 19 июня 2024  16:23:11 +0300 (0:00:00.319)       0:35:21.615 ************ 

TASK [kubernetes/preinstall : Hosts | populate inventory into hosts file] ******************************************************************************************************************************************************************
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmav03g08hr6feh31au]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:23:19 +0300 (0:00:07.522)       0:35:29.138 ************ 
Среда 19 июня 2024  16:23:19 +0300 (0:00:00.129)       0:35:29.267 ************ 

TASK [kubernetes/preinstall : Hosts | Retrieve hosts file content] *************************************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhms56jfu94iaefdph12]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:23:26 +0300 (0:00:07.352)       0:35:36.620 ************ 

TASK [kubernetes/preinstall : Hosts | Extract existing entries for localhost from hosts file] **********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhm23nh49uft58qu43qa] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhmibjl39dmiukfvfsd4] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
ok: [fhms56jfu94iaefdph12] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhm23nh49uft58qu43qa] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
ok: [fhmav03g08hr6feh31au] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhms56jfu94iaefdph12] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
ok: [fhm1q990n3ve0rlv7q48] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhmav03g08hr6feh31au] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
ok: [fhm1q990n3ve0rlv7q48] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
ok: [fhm4jldk6ls9qm2tclqm] => (item=127.0.0.1 localhost localhost.localdomain)
ok: [fhm4jldk6ls9qm2tclqm] => (item=::1 localhost6 ip6-loopback ip6-localhost localhost6.localdomain)
Среда 19 июня 2024  16:23:27 +0300 (0:00:00.527)       0:35:37.148 ************ 

TASK [kubernetes/preinstall : Hosts | Update target hosts file entries dict with required entries] *****************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhms56jfu94iaefdph12] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhms56jfu94iaefdph12] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhmav03g08hr6feh31au] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhmav03g08hr6feh31au] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
Среда 19 июня 2024  16:23:27 +0300 (0:00:00.195)       0:35:37.343 ************ 

TASK [kubernetes/preinstall : Hosts | Update (if necessary) hosts file] ********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhms56jfu94iaefdph12] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhmav03g08hr6feh31au] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhm23nh49uft58qu43qa] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
ok: [fhms56jfu94iaefdph12] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
ok: [fhmibjl39dmiukfvfsd4] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
ok: [fhm1q990n3ve0rlv7q48] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
ok: [fhmav03g08hr6feh31au] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
ok: [fhm4jldk6ls9qm2tclqm] => (item={'key': '::1', 'value': ['localhost6', 'ip6-loopback', 'ip6-localhost', 'localhost6.localdomain']})
Среда 19 июня 2024  16:23:41 +0300 (0:00:13.899)       0:35:51.243 ************ 
Среда 19 июня 2024  16:23:41 +0300 (0:00:00.130)       0:35:51.373 ************ 

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] ***************************************************************************************************************************************************
ok: [fhm23nh49uft58qu43qa]
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:23:48 +0300 (0:00:06.754)       0:35:58.128 ************ 

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***********************************************************************************************************************************************************
ok: [fhmav03g08hr6feh31au]
ok: [fhms56jfu94iaefdph12]
ok: [fhm23nh49uft58qu43qa]
ok: [fhm1q990n3ve0rlv7q48]
ok: [fhmibjl39dmiukfvfsd4]
ok: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:24:04 +0300 (0:00:16.067)       0:36:14.195 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.137)       0:36:14.333 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.129)       0:36:14.462 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.142)       0:36:14.605 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.017)       0:36:14.622 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.011)       0:36:14.634 ************ 
Среда 19 июня 2024  16:24:04 +0300 (0:00:00.018)       0:36:14.652 ************ 
Среда 19 июня 2024  16:24:05 +0300 (0:00:00.017)       0:36:14.670 ************ 
Среда 19 июня 2024  16:24:05 +0300 (0:00:00.020)       0:36:14.690 ************ 
Среда 19 июня 2024  16:24:05 +0300 (0:00:00.016)       0:36:14.707 ************ 

RUNNING HANDLER [kubernetes/preinstall : Preinstall | Restart systemd-resolved] ************************************************************************************************************************************************************
changed: [fhms56jfu94iaefdph12]
changed: [fhm23nh49uft58qu43qa]
changed: [fhmav03g08hr6feh31au]
changed: [fhm1q990n3ve0rlv7q48]
changed: [fhmibjl39dmiukfvfsd4]
changed: [fhm4jldk6ls9qm2tclqm]
Среда 19 июня 2024  16:24:26 +0300 (0:00:21.318)       0:36:36.026 ************ 
Среда 19 июня 2024  16:24:26 +0300 (0:00:00.130)       0:36:36.157 ************ 
Среда 19 июня 2024  16:24:26 +0300 (0:00:00.114)       0:36:36.271 ************ 
Среда 19 июня 2024  16:24:26 +0300 (0:00:00.120)       0:36:36.392 ************ 
Среда 19 июня 2024  16:24:26 +0300 (0:00:00.139)       0:36:36.532 ************ 
Среда 19 июня 2024  16:24:27 +0300 (0:00:00.246)       0:36:36.779 ************ 
Среда 19 июня 2024  16:24:27 +0300 (0:00:00.121)       0:36:36.900 ************ 
Среда 19 июня 2024  16:24:27 +0300 (0:00:00.109)       0:36:37.010 ************ 
Среда 19 июня 2024  16:24:27 +0300 (0:00:00.108)       0:36:37.118 ************ 

TASK [Run calico checks] *******************************************************************************************************************************************************************************************************************
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.611)       0:36:37.730 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] **************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.057)       0:36:37.788 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *********************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.047)       0:36:37.835 ************ 

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.050)       0:36:37.886 ************ 
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.041)       0:36:37.927 ************ 

TASK [network_plugin/calico : Stop if supported Calico versions] ***************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:28 +0300 (0:00:00.054)       0:36:37.981 ************ 

TASK [network_plugin/calico : Check if calicoctl.sh exists] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:24:30 +0300 (0:00:01.989)       0:36:39.971 ************ 

TASK [network_plugin/calico : Check if calico ready] ***************************************************************************************************************************************************************************************
changed: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:24:32 +0300 (0:00:02.199)       0:36:42.170 ************ 

TASK [network_plugin/calico : Get current calico version] **********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:24:34 +0300 (0:00:02.141)       0:36:44.312 ************ 

TASK [network_plugin/calico : Assert that current calico version is enough for upgrade] ****************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.062)       0:36:44.374 ************ 
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.043)       0:36:44.418 ************ 
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.037)       0:36:44.455 ************ 

TASK [network_plugin/calico : Check vars defined correctly] ********************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.059)       0:36:44.514 ************ 

TASK [network_plugin/calico : Check calico network backend defined correctly] **************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.069)       0:36:44.584 ************ 

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *****************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:34 +0300 (0:00:00.055)       0:36:44.639 ************ 
Среда 19 июня 2024  16:24:35 +0300 (0:00:00.033)       0:36:44.673 ************ 

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *********************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:35 +0300 (0:00:00.058)       0:36:44.732 ************ 

TASK [network_plugin/calico : Get Calico default-pool configuration] ***********************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:24:37 +0300 (0:00:02.449)       0:36:47.181 ************ 

TASK [network_plugin/calico : Set calico_pool_conf] ****************************************************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4]
Среда 19 июня 2024  16:24:37 +0300 (0:00:00.061)       0:36:47.243 ************ 

TASK [network_plugin/calico : Check if inventory match current cluster configuration] ******************************************************************************************************************************************************
ok: [fhmibjl39dmiukfvfsd4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Среда 19 июня 2024  16:24:37 +0300 (0:00:00.056)       0:36:47.299 ************ 
Среда 19 июня 2024  16:24:37 +0300 (0:00:00.033)       0:36:47.333 ************ 
Среда 19 июня 2024  16:24:37 +0300 (0:00:00.035)       0:36:47.369 ************ 

PLAY RECAP *********************************************************************************************************************************************************************************************************************************
fhm1q990n3ve0rlv7q48       : ok=398  changed=13   unreachable=0    failed=0    skipped=658  rescued=0    ignored=1   
fhm23nh49uft58qu43qa       : ok=521  changed=24   unreachable=0    failed=0    skipped=983  rescued=0    ignored=1   
fhm4jldk6ls9qm2tclqm       : ok=398  changed=14   unreachable=0    failed=0    skipped=658  rescued=0    ignored=1   
fhmav03g08hr6feh31au       : ok=398  changed=13   unreachable=0    failed=0    skipped=662  rescued=0    ignored=1   
fhmibjl39dmiukfvfsd4       : ok=609  changed=31   unreachable=0    failed=0    skipped=1113 rescued=0    ignored=4   
fhms56jfu94iaefdph12       : ok=522  changed=23   unreachable=0    failed=0    skipped=982  rescued=0    ignored=1   

Среда 19 июня 2024  16:24:38 +0300 (0:00:00.392)       0:36:47.761 ************ 
=============================================================================== 
etcd : Gen_certs | Write etcd member/admin and kube_control_plane client certs to other etcd nodes --------------------------------------------------------------------------------------------------------------------------------- 94.95s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ------------------------------------------------------------------------------------------------------------------------------------------------------------- 75.10s
network_plugin/calico : Calico | Create calico manifests --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 42.05s
kubernetes/control-plane : Kubeadm | Check apiserver.crt SAN hosts ----------------------------------------------------------------------------------------------------------------------------------------------------------------- 31.48s
policy_controller/calico : Create calico-kube-controllers manifests ---------------------------------------------------------------------------------------------------------------------------------------------------------------- 29.73s
etcd : Gen_certs | Gather etcd member/admin and kube_control_plane client certs from first etcd node ------------------------------------------------------------------------------------------------------------------------------- 27.20s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 26.52s
kubernetes/node : Modprobe Kernel Module for IPVS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 24.65s
download : Download_container | Remove container image from cache ------------------------------------------------------------------------------------------------------------------------------------------------------------------ 22.09s
download : Extract_file | Unpacking archive ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 22.07s
kubernetes/preinstall : Preinstall | Restart systemd-resolved ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- 21.32s
download : Extract_file | Unpacking archive ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 20.80s
kubernetes/preinstall : Write Kubespray DNS settings to systemd-resolved ----------------------------------------------------------------------------------------------------------------------------------------------------------- 20.00s
container-engine/containerd : Containerd | Create registry directories ------------------------------------------------------------------------------------------------------------------------------------------------------------- 19.53s
kubernetes/control-plane : Backup old certs and keys ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 19.37s
container-engine/crictl : Extract_file | Unpacking archive ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 18.88s
kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH) ---------------------------------------------------------------------------------------------------------------------------------------------------------- 18.56s
bootstrap-os : Gather facts -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 17.01s
bootstrap-os : Assign inventory name to unconfigured hostnames (non-CoreOS, non-Flatcar, Suse and ClearLinux, non-Fedora) ---------------------------------------------------------------------------------------------------------- 16.57s
kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH) ---------------------------------------------------------------------------------------------------------------------------------------------------------- 16.07s

```