data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${local.name}-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.main.key_name
  iam_instance_profile   = local.create_iam ? aws_iam_instance_profile.ec2[0].name : var.instance_profile_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    aws_region    = var.aws_region
    app_repo_url  = var.app_repo_url
    db_host       = aws_db_instance.main.address
    db_port       = aws_db_instance.main.port
    db_name       = var.db_name
    db_secret_arn = aws_db_instance.main.master_user_secret[0].secret_arn

    ssh_extra_public_keys = var.ssh_extra_public_keys
  })
  user_data_replace_on_change = true

  tags = { Name = "${local.name}-app" }
}
