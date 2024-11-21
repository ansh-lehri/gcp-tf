vpc = {
  name = "atlys-vpc"
  private_service_access = {
    create = true
    name = "atlys-connect"
    subnet = "10.10.0.0"
    mask = "24"
  }
  delete_default_routes = true
  create_automated_subnets = false
  vpc_routing_mode = "REGIONAL"
}

subnets = [
  {
      name = "atlys-sn-01"
      primary_cidr_range = "10.0.1.0/24"
      region = "asia-south1"
      secondary_cidr_ranges = [ {
        cidr = "10.0.2.0/24"
        name = "atlys-sn-01-01"
      }
    ]
      private_ip_google_access = false
  },
  {
      name = "atlys-sn-02"
      primary_cidr_range = "10.0.4.0/24"
      region = "asia-south1"
      secondary_cidr_ranges = [ {
          cidr = "10.0.5.0/24"
          name = "test-sn-02-01"
      }
    ]
    private_ip_google_access = false
  },
  {
      name = "atlys-sn-03"
      primary_cidr_range = "10.0.6.0/24"
      region = "asia-south1"
      secondary_cidr_ranges = [ {
          cidr = "10.0.7.0/24"
          name = "test-sn-02-01"
      }
    ]
    private_ip_google_access = true
  }
]

routes = [
  {
    destination_cidr = "0.0.0.0/0"
    internet_gateway_name = "default-internet-gateway"
    name = "atlys-ig-route"
    priority = 1000
    tags = []
    vpc_name = "atlys-vpc"
  },
  {
    destination_cidr = "10.1.0.0/16"
    internet_gateway_name = ""
    name = "atlys-internal-route"
    priority = 0
    tags = []
    vpc_name = "atlys-vpc"
  }
]

firewalls = [
  {
    allow_rules = [ {
      ports = []
      protocol = "icmp"
    } ]
    deny_rules = []
    name = "default-icmp"
    fname = "default_icmp"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    vpc_name = "atlys-vpc"
  },
  {
    allow_rules = [ 
      {
        protocol = "tcp"
        ports = ["0-65535"]
      },
      {
        protocol = "udp"
        ports = ["0-65535"]
      }
    ]
    deny_rules = []
    name = "default-internal"
    fname = "default_allow_internal"
    priority = 1000
    source_ranges = ["10.0.0.0/24"]
    vpc_name = "atlys-vpc"
  },
  {
    allow_rules = [ {
      ports = ["22"]
      protocol = "tcp"
    } ]
    deny_rules = []
    name = "default-ssh"
    fname = "default_ssh"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    vpc_name = "atlys-vpc"
  },
  {
    allow_rules = [ {
      ports = ["3000"]
      protocol = "tcp"
    } ]
    deny_rules = []
    name = "api-server"
    fname = "api-server"
    priority = 0
    source_ranges = ["0.0.0.0/0"]
    vpc_name = "atlys-vpc"
  }
]

compute_instances = [
  {
  boot_disk_size = 10
  image = "debian-cloud/debian-11"
  machine_type = "e2-micro"
  name = "atlys-pub"
  network_tier = "STANDARD"
  subnetwork = "atlys-sn-01"
  zone = "asia-south1-a"
  ssh_keys = {
    "ansh" = "~/.ssh/id_rsa.pub"
    }
  },
  {
    boot_disk_size = 10
    image = "debian-cloud/debian-11"
    machine_type = "e2-micro"
    name = "atlys-pvt"
    network_tier = "STANDARD"
    subnetwork = "atlys-sn-03"
    zone = "asia-south1-a"
    ssh_keys = {
      "ansh" = "~/.ssh/id_rsa.pub"
    }
  }
]

bucket = {
  name = "atlys-bucket-101"
  location = "asia-south1"
  cors = [
    {
      origin = ["*"]
      method = ["*"]
    }
  ]
  website = {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }
}

mysql = {
  instance_name = "mysql-instance-2"
  db_version = "MYSQL_8_0"
  instance_tier = "db-f1-micro"
  db = {
    name = "atlys"
  }
}