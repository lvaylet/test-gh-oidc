output "pool_name" {
  description = "Pool name"
  value       = module.gh_oidc.pool_name
}

output "provider_name" {
  description = "Provider name"
  value       = module.gh_oidc.provider_name
}

output "sa_email" {
  description = "Cloud Build Service Account email"
  value       = google_service_account.sa.email
}
