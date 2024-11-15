# Enable required APIs
resource "google_project_service" "cloudfunctions" {
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "random_id" "default" {
  byte_length = 8
}

# Unique storage bucket for the function's source code
resource "google_storage_bucket" "function_bucket" {
  name                        = "${random_id.default.hex}-function-bucket"
  location                    = var.region
  uniform_bucket_level_access = true
}

# Zip the function code and exclude unnecessary files
data "archive_file" "function_code" {
  type        = "zip"
  source_dir  = "${path.module}/function_code/"
  output_path = "${path.module}/function_code/function_code.zip"
  excludes    = ["**/*.zip"]
}

# Generate a hash of the zip file
data "local_file" "function_zip_hash" {
  filename   = data.archive_file.function_code.output_path
  depends_on = [data.archive_file.function_code]
}

# Store the hash in metadata to track changes
locals {
  function_code_hash = filebase64sha256(data.archive_file.function_code.output_path)
}

# Upload the function code to the storage bucket
resource "google_storage_bucket_object" "function_archive" {
  name   = "function_code.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_code.output_path
}

# Deploy the Cloud function
resource "google_cloudfunctions2_function" "function" {
  name        = "${var.environment}-${var.project}-function"
  location    = var.region
  description = "Google Cloud Function with HTTP trigger"
  depends_on  = [google_project_service.cloudfunctions, google_project_service.run]

  build_config {
    runtime     = "python311"
    entry_point = "main" # Function’s entry point in code
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 120
    environment_variables = {
      FIRESTORE_PROJECT  = var.project_id
      FUNCTION_CODE_HASH = local.function_code_hash
    }
  }
}

# Make the function publicly accessible
resource "google_cloud_run_service_iam_member" "public_invoker" {
  location = google_cloudfunctions2_function.function.location
  service  = google_cloudfunctions2_function.function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}