data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "ecs_task_exec" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
