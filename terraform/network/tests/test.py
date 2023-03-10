import argparse

import boto3


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--region", required=True, help="AWS region")
    parser.add_argument("--vpc-id", required=True, help="VPC ID")
    parser.add_argument("--security-group-id", required=True, help="Security group ID")
    parser.add_argument(
        "--subnet-ids",
        required=True,
        nargs="+",
        help="List of subnet IDs",
    )
    return parser.parse_args()


class TestFailed(Exception):
    pass


def test_vpc_exists(region_name, vpc_id):
    try:
        session = boto3.Session()
        ec2_client = session.client("ec2", region_name=region_name)
        response = ec2_client.describe_vpcs(VpcIds=[vpc_id])
        assert len(response["Vpcs"]) == 1, f"VPC {vpc_id} does not exist"
        print(f"VPC {vpc_id} exists")
    except Exception as e:
        raise TestFailed(f"Failed to test VPC {vpc_id}: {e}")


def test_security_group_exists(region_name, security_group_id):
    try:
        session = boto3.Session()
        ec2_client = session.client("ec2", region_name=region_name)
        response = ec2_client.describe_security_groups(GroupIds=[security_group_id])
        assert (
            len(response["SecurityGroups"]) == 1
        ), f"Security group {security_group_id} does not exist"
        print(f"Security group {security_group_id} exists")
    except Exception as e:
        raise TestFailed(f"Failed to test security group {security_group_id}: {e}")


def test_subnets_exist(region_name, vpc_id, subnet_ids):
    try:
        session = boto3.Session()
        ec2_client = session.client("ec2", region_name=region_name)
        response = ec2_client.describe_subnets(SubnetIds=subnet_ids)
        subnet_ids_in_aws = [subnet["SubnetId"] for subnet in response["Subnets"]]
        assert len(subnet_ids) == len(subnet_ids_in_aws), "Not all subnets exist"
        print("All subnets exist")
    except Exception as e:
        raise TestFailed(f"Failed to test subnets: {e}")


if __name__ == "__main__":
    args = parse_args()

    test_cases = [
        (test_vpc_exists, [args.region, args.vpc_id]),
        (test_security_group_exists, [args.region, args.security_group_id]),
        (test_subnets_exist, [args.region, args.vpc_id, args.subnet_ids]),
    ]

    has_errors = False
    for test_func, test_args in test_cases:
        try:
            test_func(*test_args)
        except TestFailed as e:
            has_errors = True
            print(f"ERROR: {e}")
    if has_errors:
        exit(1)
