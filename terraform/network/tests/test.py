import argparse

import boto3


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--region", required=True, help="AWS region")
    parser.add_argument("--vpc-id", required=True, help="VPC ID")
    parser.add_argument("--security-group-id", required=True, help="Security group ID")
    return parser.parse_args()


def test_vpc_exists(region_name, vpc_id):
    # Créez une session Boto3
    session = boto3.Session()

    # Spécifiez la région AWS que vous souhaitez vérifier
    ec2_client = session.client("ec2", region_name=region_name)

    # Utilisez la méthode describe_vpcs pour récupérer les informations du VPC
    try:
        response = ec2_client.describe_vpcs(VpcIds=[vpc_id])
    except ec2_client.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "InvalidVpcID.NotFound":
            # Si le VPC n'existe pas, le test échoue
            print(f"VPC {vpc_id} does not exist")
            assert False, f"VPC {vpc_id} does not exist"
        else:
            # Si une erreur autre que "VPC not found" se produit, le test échoue
            print(f"An error occurred: {e}")
            assert False, f"An error occurred: {e}"

    # Si la réponse contient un VPC, le test réussit
    print(f"VPC {vpc_id} exists")
    assert len(response["Vpcs"]) == 1, f"VPC {vpc_id} does not exist"


def test_security_group_exists(region_name, security_group_id):
    # Créez une session Boto3
    session = boto3.Session()

    # Spécifiez la région AWS que vous souhaitez vérifier
    ec2_client = session.client("ec2", region_name=region_name)

    # Utilisez la méthode describe_security_groups pour récupérer les informations du groupe de sécurité
    try:
        response = ec2_client.describe_security_groups(GroupIds=[security_group_id])
    except ec2_client.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "InvalidGroupId.NotFound":
            # Si le groupe de sécurité n'existe pas, le test échoue
            print(f"Security group {security_group_id} does not exist")
            assert False, f"Security group {security_group_id} does not exist"
        else:
            # Si une erreur autre que "Group not found" se produit, le test échoue
            print(f"An error occurred: {e}")
            assert False, f"An error occurred: {e}"

    # Si la réponse contient un groupe de sécurité, le test réussit
    print(f"Security group {security_group_id} exists")
    assert len(response["SecurityGroups"]) == 1, f"Security group {security_group_id} does not exist"


if __name__ == "__main__":
    args = parse_args()
    test_vpc_exists(region_name=args.region, vpc_id=args.vpc_id)
    test_security_group_exists(region_name=args.region, security_group_id=args.security_group_id)
