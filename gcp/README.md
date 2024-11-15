# Terraform for GCP

## Project Structure

```plaintext
project-root/
├── env/
│   ├── dev/                  # Dev environment files
│   │   ├── dev.tfbackend     # Backend config for dev state
│   │   └── dev.tfvars        # Dev-specific variables
│   ├── staging/              # Staging environment files
│   │   ├── staging.tfbackend # Backend config for staging state
│   │   └── staging.tfvars    # Staging-specific variables
│   └── prod/                 # Prod environment files
│       ├── prod.tfbackend    # Backend config for prod state
│       └── prod.tfvars       # Prod-specific variables
├── init/                     # Initial state bucket creation for remote state storage
│   └── main.tf               # Terraform config for state bucket
├── modules/                  # Reusable Terraform modules
│   ├── apigw/                # API Gateway module
│   ├── firestore/            # Firestore database module
│   └── functions/            # Cloud Functions module
├── main.tf                   # Main Terraform config file
├── provider.tf               # Provider configurations
├── terraform.tfvars          # Common variable values shared across all environments
├── .terraform.lock.hcl       # Locks provider versions to ensure consistent versions
└── variables.tf              # Common variable definitions
```

## Setup

[Set up GCP](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#prerequisites) -> [Authenticate to Google Cloud](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#prerequisites) -> define default values for your project in `terraform.tfvars`:

    project_id = "your-project-id"
    project    = "your-project-name"
    region     = "gcp-region"

Then define your environment backend configurations (seems like we can't use variables in backend configs):

    bucket = "your-state-bucket"
    prefix = "<environment>/tfstate"

## Usage

### Step 1: Initialize Remote State Backend

Navigate to the init directory and set up a cloud storage bucket for the remote state:

    cd init
    terraform init
    terraform apply -var-file=../terraform.tfvars

This creates a bucket to store Terraform state files for each environment.

### Step 2: Initialize the Environment

Move back to the root directory of the project:

    cd ..

Initialize Terraform for your desired environment (e.g., dev, staging, prod) by specifying the correct backend configuration:

    terraform init -reconfigure -backend-config=env/<environment>/<environment>.tfbackend

### Step 3: Apply Configuration

Apply environment-specific configurations by running:

    terraform apply -var-file=env/<environment>/<environment>.tfvars

Replace dev with staging or prod as necessary to target other environments.

## Destroy Environment

Destroy environment-specific configurations by running:

    terraform destroy -var-file=env/<environment>/<environment>.tfvars

Replace dev with staging or prod as necessary to target other environments.