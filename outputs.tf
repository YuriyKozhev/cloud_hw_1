output "instance_public_ip_address" {
  description = "The external IP address of the instance."
  value       = yandex_compute_instance.this.network_interface.0.nat_ip_address
} 
