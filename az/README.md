# Terraform for Azure

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
├── init/                     # Initial state creation for remote state storage
│   └── main.tf               # Terraform config for state storage
├── modules/                  # Reusable Terraform modules
│   ├── apim/                 # API Management module
│   ├── cosmosdb/             # Cosmos DB database module
│   └── functions/            # Functions module
├── main.tf                   # Main Terraform config file
├── provider.tf               # Provider configurations
├── terraform.tfvars          # Common variable values shared across all environments
├── .terraform.lock.hcl       # Locks provider versions to ensure consistent versions
└── variables.tf              # Common variable definitions
```

## Setup

[Authenticate to Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli) and define default values for your project in `terraform.tfvars`:

    project  = "your-project-name"
    location = "az-region"

Then define your environment backend configurations (seems like we can't use variables in backend configs):

    resource_group_name   = "your-state-rg"
    storage_account_name  = "your-state-storage-account"
    container_name        = "tfstate"
    key                   = "<environment>/terraform.tfstate"

## Usage

### Step 1: Initialize Remote State Backend

Navigate to the init directory and set up a storage for the remote state:

    cd init
    terraform init
    terraform apply -var-file=../terraform.tfvars

This creates a storage to store Terraform state files for each environment.

### Step 2: Initialize the Environment

Move back to the root directory of the project:

    cd ..

Initialize Terraform for your desired environment (e.g., dev, staging, prod) by specifying the correct backend configuration:

    terraform init -reconfigure -backend-config=env/<environment>/<environment>.tfbackend

### Step 3: Apply Configuration

Apply environment-specific configurations by running:

    terraform apply -var-file=env/<environment>/<environment>.tfvars

## Destroy Environment

Destroy environment-specific configurations by running:

    terraform destroy -var-file=env/<environment>/<environment>.tfvars
