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
	terraform apply --auto-approve && \
	cd ../02-instances && \
	terraform init && \
	terraform validate && \
	terraform plan  && \
	cd ../01-network && \
	terraform destroy --auto-approve && \
	echo "02-instances: SHOULD BE OK"

test: check_env
	@cd 01-network && \
	terraform init && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd ../02-instances && \
	terraform init && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd .. && \
	python3 -m venv .venv && \
	. .venv/bin/activate && \
	pip install -r requirements.txt && \
	python3 test.py --region ${AWS_REGION} --launch-template-id $$(cd 02-instances && terraform output aws_launch_template_id | sed 's/"//g') \
	--autoscaling-group-id $$(cd 02-instances && terraform output aws_autoscaling_group_id | sed 's/"//g') \
	--url $$(cd 02-instances && terraform output aws_load_balancer_dns_name | sed 's/"//g') && \
	cd 02-instances && \
	terraform destroy --auto-approve && \
	cd ../01-network && \
	terraform destroy --auto-approve && \
	echo "02-instances: OK"

destroy:
	@cd 02-instances && \
	terraform init && \
	terraform destroy --auto-approve && \
	cd ../01-network && \
	terraform init && \
	terraform destroy --auto-approve
