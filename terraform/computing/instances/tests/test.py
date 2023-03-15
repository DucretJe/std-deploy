import argparse
import time

import boto3
import requests

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--region", required=True, help="AWS region")
    parser.add_argument(
        "--launch-template-id", required=True, help="Launch Template ID"
    )
    parser.add_argument(
        "--autoscaling-group-id", required=True, help="Auto Scaling Group ID"
    )
    parser.add_argument("--url", required=True, help="URL to check")
    return parser.parse_args()


class TestFailed(Exception):
    pass


def test_launch_template_exists(region_name, launch_template_id):
    try:
        session = boto3.Session()
        ec2_client = session.client("ec2", region_name=region_name)

        response = ec2_client.describe_launch_templates(
            LaunchTemplateIds=[launch_template_id]
        )
    except ec2_client.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "InvalidLaunchTemplateId.NotFound":
            raise TestFailed(
                f"Launch template with ID {launch_template_id} does not exist"
            )
        else:
            raise TestFailed(f"An error occurred: {e}")

    assert (
        len(response["LaunchTemplates"]) == 1
    ), f"Launch template with ID {launch_template_id} does not exist"


def test_autoscaling_group_exists(region_name, autoscaling_group_id):
    try:
        session = boto3.Session()
        autoscaling_client = session.client("autoscaling", region_name=region_name)

        response = autoscaling_client.describe_auto_scaling_groups(
            AutoScalingGroupNames=[autoscaling_group_id]
        )
    except autoscaling_client.exceptions.ClientError as e:
        raise TestFailed(f"An error occurred: {e}")

    assert (
        len(response["AutoScalingGroups"]) == 1
    ), f"Auto Scaling Group with ID {autoscaling_group_id} does not exist"


def test_url_status_code(url, retries=10, delay=5):
    for attempt in range(retries):
        try:
            response = requests.get(f"http://{url}:80")
            if response.status_code == 200:
                break
        except requests.exceptions.RequestException as e:
            pass

        if attempt == retries - 1:
            raise TestFailed(
                f"Failed to make request to http://{url}:80 after {retries} retries"
            )

        time.sleep(delay)


def run_test(test_func, test_args):
    try:
        test_func(*test_args)
        print(f"{test_func.__name__} passed")
    except TestFailed as e:
        print(f"ERROR: {e}")
        return False
    return True


if __name__ == "__main__":
    args = parse_args()

    test_cases = [
        (test_launch_template_exists, [args.region, args.launch_template_id]),
        (test_autoscaling_group_exists, [args.region, args.autoscaling_group_id]),
        (test_url_status_code, [args.url]),
    ]

    has_errors = False
    for test_func, test_args in test_cases:
        if not run_test(test_func, test_args):
            has_errors = True

    if has_errors:
        print("Some tests have failed.")
    else:
        print("All tests have passed.")
