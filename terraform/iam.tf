locals {
  create_iam = var.instance_profile_name == null
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  count = local.create_iam ? 1 : 0

  name               = "${local.name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "read_db_secret" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_db_instance.main.master_user_secret[0].secret_arn]
  }
}

resource "aws_iam_role_policy" "read_db_secret" {
  count = local.create_iam ? 1 : 0

  name   = "read-db-secret"
  role   = aws_iam_role.ec2[0].id
  policy = data.aws_iam_policy_document.read_db_secret.json
}

resource "aws_iam_instance_profile" "ec2" {
  count = local.create_iam ? 1 : 0

  name = "${local.name}-ec2-profile"
  role = aws_iam_role.ec2[0].name
}
