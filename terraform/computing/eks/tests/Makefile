REQUIRED_ENV_VARS = AWS_REGION AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID TF_VAR_cloudflare_apitoken

.PHONY: all plan

all: test

check_env:
	@echo "Checking required environment variables are set..."
	@$(foreach var,$(REQUIRED_ENV_VARS), \
		$(if $(value $(var)), , $(error $(var) is undefined)) \
	)
	@echo "All required environment variables are set"

plan: check_env
	@cd 01-network && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd ../02-cluster && \
	terraform init -upgrade && \
	terraform validate && \
	terraform plan && \
	cd ../01-network && \
	terraform destroy --auto-approve && \
	echo "02-cluster: SHOULD BE OK, can't test deployment without spawning cluster"

test: check_env
	@cd 01-network && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd ../02-cluster && \
	terraform init -upgrade && \
	terraform validate && \
	terraform plan -out=plan  && \
	terraform show -json plan > ../plan.json && \
	rm plan && \
	terraform apply --auto-approve && \
	cd ../03-deployment && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd .. && \
	python3 -m venv .venv && \
	. .venv/bin/activate && \
	pip install -r requirements.txt && \
	python3 test.py --region ${AWS_REGION}  \
	--vpc-id $$(cd 01-network && terraform output vpc_id | sed 's/"//g') \
	--security-group-id $$(cd 01-network && terraform output sg_id | sed 's/"//g') \
	--subnet-ids $$(cd 01-network && terraform output public_subnet_ids | sed 's/"//g') \
	--cluster-name $$(cd 02-cluster && terraform output name | sed 's/"//g' ) \
	--worker-group-name $$(cd 02-cluster && terraform output name | sed 's/"//g' ) \
	--test-service-url $$(cd 03-deployment && terraform output url | sed 's/"//g' ) && \
	cd 03-deployment && \
	terraform destroy --auto-approve && \
	cd ../02-cluster && \
	terraform destroy --auto-approve && \
	cd ../01-network && \
	terraform destroy --auto-approve && \
	echo "02-cluster and 03-deployment: OK"

destroy:
	@cd 03-deployment && \
	terraform init -upgrade && \
	terraform destroy --auto-approve && \
	cd ../02-cluster && \
	terraform init -upgrade && \
	terraform destroy --auto-approve && \
	cd ../01-network && \
	terraform init -upgrade && \
	terraform destroy --auto-approve
