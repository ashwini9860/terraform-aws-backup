#######Providers#############
provider "aws" {
  region     = var.AWS_REGION_NAME
}


#############get aws account id########
data "aws_caller_identity" "current" {}

###########Import backup module for ebs backup#####
module "ebs_root_backup" {
        source = "../../"
        backup_name = "${var.backup_name}-EBS-Backup"
        schedule = "cron(0 22 * * ? *)"
        cold_storage_after = "7"
        delete_after = "365"
        backup_selection_list = [ "arn:aws:ec2:${var.AWS_REGION_NAME}:${data.aws_caller_identity.current.account_id}:volume/${var.volume_id}" ]

}

