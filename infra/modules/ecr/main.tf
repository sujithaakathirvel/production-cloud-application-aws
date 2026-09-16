resource "aws_ecr_repository" "app" {
  name = "cloud-task-manager"

  force_delete = true
}
