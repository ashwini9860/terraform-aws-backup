####################
resource "aws_backup_vault" "backup_vault" {
  name        = "${var.backup_name}"
}

resource "aws_backup_plan" "backup_plan" {
  name = "${var.backup_name}_plan"
  rule {
    rule_name         = "${var.backup_name}"
    target_vault_name = "${aws_backup_vault.backup_vault.name}"
    schedule          = var.schedule
    lifecycle {
      cold_storage_after = var.cold_storage_after
      delete_after = var.delete_after
    }
  }
}

resource "aws_iam_role" "Backup_IAM_role" {
  name               = "Backup_IAM_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "Backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = "${aws_iam_role.Backup_IAM_role.name}"
}

resource "aws_backup_selection" "Backup_selection" {
  iam_role_arn = "${aws_iam_role.Backup_IAM_role.arn}"
  name         = "${var.backup_name}"
  plan_id      = "${aws_backup_plan.backup_plan.id}"
  resources =   var.backup_selection_list

}
