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
  description = "Boot disk image id. If not provided, it defaults to Ubuntu 22.04 LTS image id"
  type        = string
} 
