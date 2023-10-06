module "cloudrun-cicd" {
  source               = "github.com/withriley/cloudrun-cicd"

  create_github_link   = false
  github_remote_uri    = "https://github.com/petergriffin/epic_app.git"
  github_repo_name     = "epic_app"
  github_connection_id = "projects/production/locations/us-central1/connections/repo_conn_name"
  project_id           = "production"
  location             = "us-central1"
}