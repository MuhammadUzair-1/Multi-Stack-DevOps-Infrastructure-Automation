# Create this bucket first by running Terraform in ./bootstrap-state.
# If you change the bucket name there, update it here too.
terraform {
  backend "s3" {
    bucket       = "ironhack-uzair-terraform-state-2026-1855224743"
    key          = "ironhack-voting-app/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
