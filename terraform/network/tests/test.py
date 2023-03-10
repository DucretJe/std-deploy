import argparse

import boto3


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--region",
        required=True,
        help="AWS region"
    )
    parser.add_argument(
        "--vpc-id",
        required=True,
        help="VPC ID"
    )
    parser.add_argument(
        "--security-group-id",
        required=True,
        help="Security group ID"
    )
    parser.add_argument(
        "--subnet-ids",
        required=True,
        nargs="+",
        help="List of subnet IDs",
    )
    return parser.parse_args()


def test_vpc_exists(region_name, vpc_id):
    # Create a Boto3 session
    session = boto3.Session()

    # Specify the AWS region you want to check
    ec2_client = session.client("ec2", region_name=region_name)

    # Use the method describe_vpcs to get the VPC information
    try:
        response = ec2_client.describe_vpcs(VpcIds=[vpc_id])
    except ec2_client.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "InvalidVpcID.NotFound":
            # If the VPC does not exist, the test fails
            print(f"VPC {vpc_id} does not exist")
            assert False, f"VPC {vpc_id} does not exist"
        else:
            # If an error other than "VPC not found" occurs, the test fails
            print(f"An error occurred: {e}")
            assert False, f"An error occurred: {e}"

    # If the response contains a VPC, the test passes
    print(f"VPC {vpc_id} exists")
    assert len(response["Vpcs"]) == 1, f"VPC {vpc_id} does not exist"


def test_security_group_exists(region_name, security_group_id):
    # Create a Boto3 session
    session = boto3.Session()

    # Specify the AWS region you want to check
    ec2_client = session.client("ec2", region_name=region_name)

    # Initiate the response variable
    response = None

    # Use the method describe_security_groups to get the security group information
    try:
        response = ec2_client.describe_security_groups(GroupIds=[security_group_id])
    except ec2_client.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "InvalidGroupId.NotFound":
            # If the security group does not exist, the test fails
            print(f"Security group {security_group_id} does not exist")
            assert (
                len(response["SecurityGroups"]) == 1
            ), f"Security group {security_group_id} does not exist"
        else:
            # If an error other than "Security group not found" occurs, the test fails
            print(f"An error occurred: {e}")
            assert False, f"An error occurred: {e}"

    # If the response contains a security group, the test passes
    print(f"Security group {security_group_id} exists")
    assert (
        len(response["SecurityGroups"]) == 1
    ), f"Security group {security_group_id} does not exist"

def test_subnets_exist(region_name, vpc_id, subnet_ids):
    # Create a Boto3 session
    session = boto3.Session()

    # Specify the AWS region you want to check
    ec2_client = session.client("ec2", region_name=region_name)

    # Use the method describe_subnets to get the subnet information
    try:
        response = ec2_client.describe_subnets(SubnetIds=subnet_ids)
    except ec2_client.exceptions.ClientError as e:
        # If an error occurs, the test fails
        print(f"An error occurred: {e}")
        assert False, f"An error occurred: {e}"

    # Get the IDs of the subnets
    subnet_ids_in_aws = [subnet["SubnetId"] for subnet in response["Subnets"]]

    # Check if each subnet ID is in the local list of subnet IDs
    for subnet_id in subnet_ids:
        if subnet_id not in subnet_ids_in_aws:
            # If a subnet ID is not found, the test fails
            print(f"Subnet with ID {subnet_id} does not exist")
            assert False, f"Subnet with ID {subnet_id} does not exist"

    # If all subnet IDs are found, the test passes
    print(f"All subnets exist")
    assert len(subnet_ids) == len(subnet_ids_in_aws), f"Not all subnets exist"



if __name__ == "__main__":
    args = parse_args()
    test_vpc_exists(region_name=args.region, vpc_id=args.vpc_id)
    test_security_group_exists(
        region_name=args.region, security_group_id=args.security_group_id
    )
    test_subnets_exist(region_name=args.region, vpc_id=args.vpc_id, subnet_ids=args.subnet_ids)
