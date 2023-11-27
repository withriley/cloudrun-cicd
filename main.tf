data "google_project" "project" {
    project_id = var.project_id
}

locals {
  // construct the repo connection id if we are not creating a new connection
  connection_id = var.create_github_connection ? null : "projects/${var.project_id}/locations/${var.location}/connections/${var.github_connection_name}"
  // The next two locals get the name of the Github repo - we could probably use regex to do this but this is easier to read
  repo_split     = split("/", var.github_remote_uri) // Split the remote URI into an array
  repo_name   = replace(element(local.repo_split, length(local.repo_split) - 1), ".git", "") // Get the last element of the split array and remove .git (to get the name of the repo)
}

// Grab the secret containing the personal access token and grant permissions to the Service Agent (only if we create the connection)
data "google_secret_manager_secret" "default" {
  count     = var.create_github_connection ? 1 : 0
  project   = var.project_id
  secret_id = var.secret_id
}

data "google_secret_manager_secret_version" "default" {
  count   = var.create_github_connection ? 1 : 0
  project = var.project_id
  secret  = data.google_secret_manager_secret.default[0].secret_id
}

data "google_iam_policy" "default" {
  count = var.create_github_connection ? 1 : 0
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "default" {
  count       = var.create_github_connection ? 1 : 0
  project     = var.project_id
  secret_id   = data.google_secret_manager_secret.default[0].secret_id
  policy_data = data.google_iam_policy.default[0].policy_data
}

// Create the GitHub connection
resource "google_cloudbuildv2_connection" "default" {
  count    = var.create_github_connection ? 1 : 0
  location = var.location
  name     = var.github_org_name

  github_config {
    app_installation_id = "34197778"
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.default[0].id
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.default[0]]
}

// Link Github Repo 
resource "google_cloudbuildv2_repository" "default" {
  name              = local.repo_name
  location          = var.location
  project           = var.project_id
  parent_connection = var.create_github_connection ? google_cloudbuildv2_connection.default[0].id : local.connection_id
  remote_uri        = var.github_remote_uri
}

// Create the three Cloud Build triggers 
resource "google_cloudbuild_trigger" "branch" {
  location = var.location
  project  = var.project_id

  name        = "${local.repo_name}-branch"
  description = "Builds and pushes the ${local.repo_name} service to Cloud Run with 0% traffic when a branch is pushed (that is not ${var.main_branch_name})."

  repository_event_config {
    repository = google_cloudbuildv2_repository.default.id
    push {
      branch = "[^(?!.*${var.main_branch_name})].*"
    }
  }

  filename = "cloudbuild/branch-cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "main" {
  location = var.location
  project  = var.project_id

  name        = "${local.repo_name}-main"
  description = "Builds and pushes the ${local.repo_name} service to Cloud Run with 10% traffic when a branch is merged to ${var.main_branch_name}."

  repository_event_config {
    repository = google_cloudbuildv2_repository.default.id
    push {
      branch = var.main_branch_name
    }
  }
  filename = "cloudbuild/main-cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "tag" {
  location = var.location
  project  = var.project_id

  name        = "${local.repo_name}-tag"
  description = "Builds and pushes the ${local.repo_name} service to Cloud Run with 100% traffic when a tag is created."

  repository_event_config {
    repository = google_cloudbuildv2_repository.default.id
    push {
      tag = ".*"
    }
  }
  filename = "cloudbuild/tag-cloudbuild.yaml"
}