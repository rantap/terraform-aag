# Enable the necessary API services
resource "google_project_service" "firestore" {
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}

# Deploy the Firestore database
resource "google_firestore_database" "database" {
  name            = "${var.environment}-${var.project}-db"
  location_id     = var.region # Use the preferred location ID for Firestore
  project         = var.project_id
  type            = "FIRESTORE_NATIVE"
  deletion_policy = "DELETE"

  depends_on = [google_project_service.firestore] # Ensure the API is enabled before creation
}