![TFSec Security Checks](https://github.com/withriley/template-terraform-module/actions/workflows/main.yml/badge.svg)
![terraform-docs](https://github.com/withriley/template-terraform-module/actions/workflows/terraform-docs.yml/badge.svg)

# Cloud Run CI/CD Module

This module creates the required Cloud Build jobs to implement a deployment pipeline for Cloud Run that implements a progression of code from developer branches to production with automated canary testing and percentage-based traffic management.

It is entirely based on the example provided by Google [here](https://cloud.google.com/architecture/implementing-cloud-run-canary-deployments-git-branches-cloud-build).

## Usage Instructions :sparkles:

1. Copy the the `cloudbuild` directory to the root of your repository.
2. Change the substitutions in each of the Cloud Build YAML files in the `cloudbuild` directory in your repository to set the region and the name of your Cloud Run service.
3. Push the changes to your repository.
4. Call this Terraform module and provide the required variables (and any optional variables) then apply the changes.

## Notes

- The Github repository connection MUST be in the same region as the repository link (which therefore implicitly requires the triggers are in the same region as the repository)

<!-- BEGIN_TF_DOCS -->


## Example

```hcl
module "cloudrun-cicd" {
  source               = "github.com/withriley/cloudrun-cicd"

  create_github_link   = false
  github_remote_uri    = "https://github.com/petergriffin/epic_app.git"
  github_repo_name     = "epic_app"
  github_connection_id = "projects/production/locations/us-central1/connections/repo_conn_name"
  project_id           = "production"
  location             = "us-central1"
}
```

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.branch](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.tag](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuildv2_connection.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_connection) | resource |
| [google_cloudbuildv2_repository.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository) | resource |
| [google_secret_manager_secret_iam_policy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_policy) | resource |
| [google_iam_policy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_secret_manager_secret.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret) | data source |
| [google_secret_manager_secret_version.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_github_connection"></a> [create\_github\_connection](#input\_create\_github\_connection) | Boolean to determine whether or not to create a new Github connection. If false, you must provide the github\_connection\_id variable. | `bool` | `false` | no |
| <a name="input_github_connection_id"></a> [github\_connection\_id](#input\_github\_connection\_id) | The ID of the Github connection to use. Required only when create\_github\_link is false. Expected format: projects/<project\_id>/locations/<region>/connections/<connection\_name> | `string` | `null` | no |
| <a name="input_github_org_name"></a> [github\_org\_name](#input\_github\_org\_name) | The name of your Github organization/user. Required only when create\_github\_link is true. | `string` | `null` | no |
| <a name="input_github_remote_uri"></a> [github\_remote\_uri](#input\_github\_remote\_uri) | The HTTPS URI of the Github Repo to link to Cloud Build (ie. the repo we want to build from). Must include the protocol and .git extension. | `string` | n/a | yes |
| <a name="input_github_repo_name"></a> [github\_repo\_name](#input\_github\_repo\_name) | The name of the Github repo you want to link to Cloud Build. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location to deploy the resources to. | `string` | n/a | yes |
| <a name="input_main_branch_name"></a> [main\_branch\_name](#input\_main\_branch\_name) | The name of the main branch of the Github repo. Defaults to 'main'. | `string` | `"main"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Project ID where all resources are to be created by this module. | `string` | n/a | yes |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | The name of the secret that contains the Github token. Assumed to be within the same project. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
