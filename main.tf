module "vpc" {
  source = "./vpc"
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  secret_key_file = var.secret_key_file
  vpc_name = var.vpc_name
  default_zone = var.default_zone
  default_cidr = var.default_cidr
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=4d05fab828b1fcae16556a4d167134efca2fccf2"
  env_name       = "develop" 
  count = length(var.labels["owner"])
  network_id     = module.vpc.vpc_details.network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = module.vpc.vpc_details.subnet_ids
  instance_name  = "${var.labels["owner"][count.index]}-vm"
  #instance_count = length(var.labels["owner"])
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  
  labels = { 
    owner = var.labels["owner"][count.index]
    }

metadata = {
    user-data = templatefile("${path.module}/cloud-init.yml", {
      ssh_key = local.ssh_key
    })  }

}
