module "cloudrun-cicd" {
  source                   = "github.com/withriley/cloudrun-cicd"
  create_github_connection = false
  github_remote_uri        = "https://github.com/petergriffin/epic_app.git"
  github_connection_name   = "repo_conn_name"
  project_id               = "production"
  location                 = "us-central1"
}