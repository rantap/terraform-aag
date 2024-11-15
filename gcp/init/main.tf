resource "google_storage_bucket" "tf-state-bucket" {
  name                        = "${var.project}-state-bucket"
  project                     = var.project_id
  location                    = var.region
  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}