.PHONY: all validate init plan

all: plan

plan:
	cd 01-network && \
	terraform init && \
	terraform validate && \
	terraform plan  && \
	echo "01-network: OK"
