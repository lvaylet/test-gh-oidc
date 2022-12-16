resource "google_service_account" "sa" {
  project    = var.project_id
  account_id = "cloud-builder"
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  for_each = toset([
    "roles/viewer",
    "roles/cloudbuild.builds.builder",
  ])
  role   = each.key
  member = "serviceAccount:${google_service_account.sa.email}"
}

# IMPORTANT Changes to Org Policies can take up to 30 seconds to kick in. Run `terraform apply` again if required.
resource "google_project_organization_policy" "workload_identity_pool_provider_policy" {
  project    = var.project_id
  constraint = "constraints/iam.workloadIdentityPoolProviders"

  list_policy {
    allow {
      all = true  # TODO values = [module.gh_oidc.provider_id] for least privilege?
    }
  }
}

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = "github-identity-pool"
  provider_id = "github-identity-provider"
  sa_mapping = {
    (google_service_account.sa.account_id) = {
      sa_name   = google_service_account.sa.name
      attribute = "attribute.repository/${var.repo}"
    }
  }
}

resource "google_project_service" "project" {
    project = var.project_id
    for_each = toset([
        "iamcredentials.googleapis.com",
        "artifactregistry.googleapis.com",
        "cloudbuild.googleapis.com",
    ])
    service = each.key
    disable_dependent_services = true
}

resource "google_artifact_registry_repository" "docker" {
  location      = "europe-west9"
  repository_id = "docker"
  format        = "DOCKER"
}
