variable "project_id" {
  type        = string
  description = "The ID of the project hosting the WIF pool and Service Account"
}

variable "repo" {
  type        = string
  description = "The GitHub repository to authorize, as user/repo (for example google/chrome or lvaylet/terraform-in-action)"
}
