resource "google_sql_database_instance" "mysql_instance" {
  name             = var.mysql.instance_name
  database_version = var.mysql.db_version
  region           = var.region
  settings {
    tier = var.mysql.instance_tier
    ip_configuration{
      ipv4_enabled = false
      private_network = var.vpc_id
    }
  }
}

resource "google_sql_database" "users_db" {
  name     = var.mysql.db.name
  instance = google_sql_database_instance.mysql_instance.name
}