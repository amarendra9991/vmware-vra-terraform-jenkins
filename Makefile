# We use bashisms so this ensures stuff works as expected
SHELL := /bin/bash -l
TERRAFORM_FOLDER := .

# Format the terraform code
terraform-fmt:
	terraform fmt ${TERRAFORM_FOLDER}

# Perform a terraform init
terraform-init:
	cd ${TERRAFORM_FOLDER} && \
	terraform init -backend-config=backend/${TARGET_ENV}.conf -input=false
	terraform get -update ${TERRAFORM_FOLDER}

# Perform a validation of the terraform files
terraform-validate:
	cd ${TERRAFORM_FOLDER} && \
	terraform validate

# Produce the terraform plan
terraform-plan:
	cd ${TERRAFORM_FOLDER} && \
	terraform plan -var-file=vars/${TARGET_ENV}.tfvars \
	-input=false -out=tfplan

# Apply the terraform plan
terraform-apply:
	cd ${TERRAFORM_FOLDER} && \
	terraform apply -input=false -auto-approve tfplan

# Produce the terraform plan to destroy the infrastructure
terraform-plan-destroy:
	cd ${TERRAFORM_FOLDER} && \
	terraform plan -destroy -var-file=vars/${TARGET_ENV}.tfvars \
	-input=false -out=tfplan

# Destroy the infrastructure provisioned
terraform-destroy:
	cd ${TERRAFORM_FOLDER} && \
	terraform destroy -input=false -auto-approve -refresh=false \
	-var-file=vars/${TARGET_ENV}.tfvars

# Clear the terraform temporary files
clean:
	rm -rf terraform*