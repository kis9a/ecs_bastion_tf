variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ecr_image_url" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}
