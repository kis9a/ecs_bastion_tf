resource "aws_cloudwatch_log_group" "bastion" {
  name = "/ecs/${var.service}-${var.env}"
}
