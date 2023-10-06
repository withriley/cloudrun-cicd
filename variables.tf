variable "create_github_link" {
  type    = bool
  default = false
}
variable "github_repo_name" {
  type = string

}
variable "github_org_name" {
  type    = string
  default = null
}
variable "location" {
  type = string
}
variable "secret_id" {
  type        = string
  description = "The name of the secret that contains the Github token. Assumed to be within the same project."
  default     = null
}
variable "project_id" {
  type        = string
  description = "The Project ID where all resources are to be created by this module."
}
variable "github_remote_uri" {
  type        = string
  description = "The HTTPS URI of the Github Repo to link to Cloud Build (ie. the repo we want to build from). Must include the protocol and .git extension."
}
variable "github_connection_id" {
  type        = string
  description = "The ID of the Github connection to use. Required only when create_github_link is false. Expected format: projects/<project_id>/locations/<region>/connections/<connection_name>"
  default     = null
}
variable "main_branch_name" {
  type        = string
  description = "The name of the main branch of the Github repo. Defaults to 'main'."
  default     = "main"
}