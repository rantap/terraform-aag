output "function_url" {
  description = "The URL of the deployed Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}
