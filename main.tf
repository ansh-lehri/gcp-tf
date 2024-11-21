locals {
  compute_instances = {
    for compute in var.compute_instances : compute.name => {
      boot_disk_size = compute.boot_disk_size
      image = compute.image
      machine_type = compute.machine_type
      network_tier = compute.network_tier
      zone = compute.zone
      subnetwork = module.subnet.subnet-id[compute.subnetwork]
      ssh_keys = compute.ssh_keys
    }
  }
}



terraform {
  backend "gcs" {
    bucket  = var.backend.name
    prefix  = var.backend.prefix
    credentials = var.credentials
  }
}


provider "google" {

    project = var.gcp_project
    region = var.gcp_region
    zone = var.gcp_zone
    credentials = var.credentials
}


module "vpc" {
  source = "./modules/vpc"
  vpc = var.vpc
  vpc_name = var.vpc.name
  delete_default_routes = var.vpc.delete_default_routes
}


module "subnet"{
  source = "./modules/subnet"
  subnets = var.subnets
  subnets_vpc_id = module.vpc.vpc-id
}


module "routes" {
  source = "./modules/routes"
  routes = var.routes
  vpc_id = module.vpc.vpc-id
}


module "firewall" {
  source = "./modules/firewall"
  firewalls = var.firewalls
  vpc_id = module.vpc.vpc-id
  
}


module "compute_instance" {
  source = "./modules/compute_instance"
  compute_instances = local.compute_instances
  depends_on = [ module.firewall, module.routes ]
}

module "bucket" {
  source = "./modules/buckets"
  bucket = var.bucket
  
}


module "mysql" {
  source = "./modules/sql"
  vpc_id = module.vpc.vpc-id
  mysql = var.mysql
  region = var.gcp_region
  depends_on = [ module.vpc ]
}
