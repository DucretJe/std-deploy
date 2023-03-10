REQUIRED_ENV_VARS = AWS_REGION AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID

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
	terraform init && \
	terraform validate && \
	terraform plan  && \
	echo "01-network: SHOULD BE OK"

test: check_env
	@cd 01-network && \
	terraform init && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd .. && \
	python3 -m venv .venv && \
	. .venv/bin/activate && \
	pip install -r requirements.txt && \
	python3 test.py --region ${AWS_REGION} --vpc-id $$(cd 01-network && terraform output vpc_id | sed 's/"//g') \
	--security-group-id $$(cd 01-network && terraform output sg_id | sed 's/"//g') \
	--subnet-ids $$(cd 01-network && terraform output subnet_ids | sed 's/\[//g; s/\]//g; s/\"//g; s/,//g') && \
	cd 01-network && \
	terraform destroy --auto-approve && \
	echo "01-network: OK"

destroy:
	@cd 01-network && \
	terraform destroy --auto-approve
