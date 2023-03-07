.PHONY: all validate init plan

all: plan

plan:
	cd 01-network && \
	terraform validate && \
	terraform init && \
	terraform plan  && \
	echo "01-network: OK"
