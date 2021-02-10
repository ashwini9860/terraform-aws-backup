variable "backup_name" {}
variable "schedule" {}
variable "cold_storage_after" {}
variable "delete_after" {}
variable "backup_selection_list" {
 type        = list(string)
        default     = null

}
