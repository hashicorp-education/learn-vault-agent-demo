//--------------------------------------------------------------------
// Vault client Instance

resource "aws_instance" "vault-client" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_demo_vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.learn-vault-agent.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vault-client.id

  tags = {
    Name     = "${var.environment_name}-vault-client"
    TTL      = var.hashibot_reaper_ttl
  }

  user_data = templatefile("${path.module}/templates/userdata-vault-client.tftpl", { tpl_vault_service_name = "vault-${var.environment_name}", tpl_vault_server_addr = aws_instance.vault-server[0].private_ip })

  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}
