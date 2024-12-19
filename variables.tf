variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created."
  type        = string
}

variable "zone" {
  description = "(Optional) - Yandex Cloud Zone for provisoned resources."
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "Boot disk image id."
  type        = string
} 

variable "ssh_key" {
  description = "Public SSH key to connect to VM"
  type        = string
}

variable "user_name" {
  description = "User name to create for VM"
  type        = string
  default     = "crawler"
}

variable "db_user_name" {
  description = "User name to create for DB"
  type        = string
  default     = "crawler"
}

variable "db_user_pass" {
  description = "User password to create for DB"
  type        = string
}

variable "db_name" {
  description = "DB name"
  type        = string
  default     = "bookspider"
}

variable "db_table_name" {
  description = "Table name to create in DB"
  type        = string
  default     = "books"
}

variable "redis_pass" {
  description = "Password for Redis"
  type        = string
}

variable "workers_count" {
  description = "Number of workers to create"
  type        = number
  default     = 3
}
