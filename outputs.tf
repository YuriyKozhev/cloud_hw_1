output "instance_public_ip_address" {
  description = "The external IP address of the instance."
  value       = yandex_compute_instance.this.network_interface.0.nat_ip_address
} 

output "mysql_host" {
  description = "The Fully Qualified Domain Name for MySql"
  value = yandex_mdb_mysql_cluster.this.host[0].fqdn
}

output "redis_host" {
  description = "The Fully Qualified Domain Name for Redis"
  value = yandex_mdb_redis_cluster.this.host[0].fqdn
}
