
variable "project_id" {
  type        = string
  description = "The project id to create WIF pool and example SA"
}

variable "repo" {
  type        = string
  description = "The GitHub repository to authorize, as user/repo (for example google/chrome or lvaylet/terraform-in-action)"
}
