locals {
  bastion_container_definition_json = jsonencode([
    {
      name      = "${var.service}-${var.env}",
      image     = "${var.ecr_image_url}",
      essential = true,
      logConfiguration = {
        logDriver     = "awslogs",
        secretOptions = null,
        options = {
          awslogs-group         = "/ecs/${var.service}-${var.env}",
          awslogs-region        = "${data.aws_region.current.id}",
          awslogs-stream-prefix = "ecs"
        }
      },
      linuxParameters = {
        initProcessEnabled = true
      }
      command = [
        "tail", "-f", "/dev/null"
      ]
    }
  ])
}

output "bastion_container_definition_json" {
  value = local.bastion_container_definition_json
}

resource "aws_ecs_task_definition" "bastion" {
  family        = "${var.service}-${var.env}"
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  execution_role_arn    = aws_iam_role.bastion_task_exec_role.arn
  memory                = "512"
  cpu                   = "256"
  container_definitions = local.bastion_container_definition_json
}

resource "aws_ecs_service" "bastion" {
  name                   = "${var.service}-${var.env}"
  cluster                = var.ecs_cluster_id
  task_definition        = aws_ecs_task_definition.bastion.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true
  platform_version       = "1.4.0"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true

    security_groups = [
      aws_security_group.bastion.id,
    ]
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}
