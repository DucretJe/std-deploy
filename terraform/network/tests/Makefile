.PHONY: all plan

all: test

plan:
	cd 01-network && \
	terraform init && \
	terraform validate && \
	terraform plan  && \
	echo "01-network: SHOULD BE OK"

test:
	cd 01-network && \
	terraform init && \
	terraform validate && \
	terraform apply --auto-approve && \
	cd .. && \
	python3 -m venv .venv && \
	. .venv/bin/activate && \
	pip install -r requirements.txt && \
	python3 test.py --region ${AWS_REGION} --vpc-id $$(cd 01-network && terraform output vpc_id | sed 's/"//g') && \
	cd 01-network && \
	terraform destroy --auto-approve && \
	echo "01-network: OK"

destroy:
	cd 01-network && \
	terraform destroy --auto-approve
