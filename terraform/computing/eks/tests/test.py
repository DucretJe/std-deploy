import argparse
import time

import boto3
import dns.resolver
import requests
from botocore.exceptions import ClientError


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
    parser.add_argument("--cluster-name", required=True, help="EKS cluster name")
    parser.add_argument("--worker-group-name", required=True, help="Worker group name")
    parser.add_argument("--test-service-url", required=True, help="Test service URL")
    return parser.parse_args()


class TestFailed(Exception):
    pass


def test_eks_cluster_exists(region_name, cluster_name):
    try:
        session = boto3.Session()
        eks_client = session.client("eks", region_name=region_name)
        response = eks_client.describe_cluster(name=cluster_name)
        assert (
            response["cluster"]["name"] == cluster_name
        ), f"EKS cluster {cluster_name} does not exist"
        print(f"EKS cluster {cluster_name} exists")
    except ClientError as e:
        raise TestFailed(f"Failed to test EKS cluster {cluster_name}: {e}")


def test_worker_group_exists(region_name, cluster_name, worker_group_name):
    try:
        session = boto3.Session()
        eks_client = session.client("eks", region_name=region_name)
        response = eks_client.describe_nodegroup(
            clusterName=cluster_name, nodegroupName=worker_group_name
        )
        assert (
            response["nodegroup"]["nodegroupName"] == worker_group_name
        ), f"Worker group {worker_group_name} does not exist"
        print(f"Worker group {worker_group_name} exists")
    except ClientError as e:
        raise TestFailed(f"Failed to test worker group {worker_group_name}: {e}")


def test_url_resolves(test_service_url, max_retries=60, retry_delay=20):
    if test_service_url.startswith("https://"):
        test_service_url = test_service_url[8:]

    print(f"Trying to resolve URL {test_service_url}")
    for attempt in range(1, max_retries + 1):
        try:
            answers = dns.resolver.query(test_service_url, "A")
            for rdata in answers:
                print(f"URL {test_service_url} resolves to IP {rdata.address}")
            break
        except dns.resolver.NXDOMAIN:
            if attempt == max_retries:
                raise Exception(f"Failed to resolve URL {test_service_url}")
            else:
                print(f"Attempt {attempt} failed. Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)


def test_test_service_response(test_service_url, max_retries=5, retry_delay=20):
    # Force test_service_url to start with http://
    if test_service_url.startswith("https://"):
        test_service_url = "http://" + test_service_url[8:]

    for attempt in range(1, max_retries + 1):
        try:
            response = requests.get(test_service_url, allow_redirects=True)
            assert (
                response.status_code == 200
            ), f"Test service returned a {response.status_code} status code"
            assert response.url.startswith(
                "https://"
            ), f"Test service did not redirect to HTTPS: {response.url}"
            assert (
                "It works!" in response.text
            ), f"Test service returned: {response.text}"
            print(
                "Test service returned a 200 status code, 'It works!', and redirected to HTTPS"
            )
            break
        except Exception as e:
            if attempt == max_retries:
                raise TestFailed(
                    f"Failed to test test service after {max_retries} attempts: {e}"
                )
            else:
                print(f"Attempt {attempt} failed. Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)


def run_test(test_func, test_args):
    try:
        test_func(*test_args)
    except TestFailed as e:
        print(f"ERROR: {e}")
        return False
    return True


if __name__ == "__main__":
    args = parse_args()

    test_cases = [
        (test_eks_cluster_exists, [args.region, args.cluster_name]),
        (
            test_worker_group_exists,
            [args.region, args.cluster_name, args.worker_group_name],
        ),
        (test_url_resolves, [args.test_service_url]),
        (test_test_service_response, [args.test_service_url]),
    ]

    has_errors = False
    for test_func, test_args in test_cases:
        if not run_test(test_func, test_args):
            has_errors = True

    if has_errors:
        exit(1)
