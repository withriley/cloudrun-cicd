variable "create_github_connection" {
  type    = bool
  default = false
  description = "Boolean to determine whether or not to create a new Github connection. If false, you must provide the github_connection_id variable."
}
variable "github_org_name" {
  type    = string
  default = null
  description = "The name of your Github organization/user. Required only when create_github_link is true."
}
variable "location" {
  type = string
  description = "The location to deploy the resources to."
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
variable "github_connection_name" {
  type        = string
  description = "The name of the Github connection to use (only the name is required not the full ID). Required only when create_github_link is false."
  default     = null
}
variable "main_branch_name" {
  type        = string
  description = "The name of the main branch of the Github repo. Defaults to 'main'."
  default     = "main"
}