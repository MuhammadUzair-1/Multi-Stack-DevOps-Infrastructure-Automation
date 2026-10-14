# Terraform — Ironhack Voting App (Part 2)

This project provisions a VPC, one public subnet, two private subnets, routing, security groups, and three Amazon Linux 2023 EC2 instances in `eu-central-1`. It configures S3 remote state with S3-native locking (`use_lockfile = true`, Terraform 1.10+).

## 1. Prepare variables

From this `terraform` directory:

```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Check the key pair exists in Frankfurt, confirm the PEM file matches it, update your current public IP, and verify the AMI ID before applying.

## 2. Create the S3 state bucket first

```bash
cd bootstrap-state
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

Review the plan before approving. S3 bucket names must be globally unique. If AWS says this name is taken, change the bucket name in `bootstrap-state/main.tf` and `../backend.tf` to the same new name.

## 3. Set up remote state for the main stack

```bash
cd ..
terraform fmt
terraform init -migrate-state
```

If asked to copy your existing local state to S3, answer `yes`. Keep the bootstrap state's local files safe; that small stack manages the bucket itself.

## 4. Validate and plan

```bash
terraform validate
terraform plan
```

Review the proposed resources carefully. If the plan is expected, create the infrastructure with:

```bash
terraform apply
```

## Private-subnet internet access

`enable_nat_gateway = false` avoids NAT Gateway charges, but the private EC2 instances will not be able to access public package repositories or Docker Hub. If you need private instances to install packages and pull images directly, set `enable_nat_gateway = true`, then run `terraform plan` and review the added resources/costs before applying.

## What Terraform does and does not do

Terraform creates networking, routing, security groups, and the three EC2 instances. It does not install Docker or deploy Vote, Result, Redis, Worker, or PostgreSQL containers; that is handled in Part 3 using Ansible.
