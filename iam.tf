resource "aws_iam_role" "ecs_task" {
  name = "${var.service}-${var.env}-ecs-task"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "bastion_task_exec_role" {
  name = "${var.service}-${var.env}-task-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_exec" {
  name = "${var.service}-${var.env}-ecs-task"
  role = aws_iam_role.ecs_task.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
  ] })
}

resource "aws_iam_role_policy_attachment" "bastion_task_exec_role" {
  role       = aws_iam_role.bastion_task_exec_role.name
  policy_arn = data.aws_iam_policy.ecs_task_exec.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_logs" {
  role       = aws_iam_role.bastion_task_exec_role.name
  policy_arn = data.aws_iam_policy.cloudwatch.arn
}
