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

```

## Resources

No resources.

## Modules

No modules.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
