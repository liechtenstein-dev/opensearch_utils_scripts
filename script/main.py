#! /usr/bin/env python3
import boto3
import requests
from requests_aws4auth import AWS4Auth

def create_awsauth():
    session = boto3.Session()
    credentials = session.get_credentials()

    awsauth = AWS4Auth(
        credentials.access_key,
        credentials.secret_key,
        session.region_name,
        "es",
        session_token=credentials.token
    )

    return awsauth

def create_snapshot_url(host, repository, snapshot):
    path = f"/_snapshot/{repository}/{snapshot}"
    url = host + path
    return url

def create_snapshot_payload(indices, ignore_unavailable=True, include_global_state=False):
    payload = {
        "indices": indices,
        "ignore_unavailable": ignore_unavailable,
        "include_global_state": include_global_state
    }
    return payload

def create_snapshot(host, repository, snapshot, indices):
    awsauth = create_awsauth()
    url = create_snapshot_url(host, repository, snapshot)
    payload = create_snapshot_payload(indices)

    response = requests.put(
        url,
        auth=awsauth,
        json=payload
    )

    return response.text

host = "https://some-endpoint.amazonaws.com"
repository = "name-of-repository-opensearch"
snapshot = "name-of-snapshot-opensearch"
indices = "index1,index2,index3"

print(create_snapshot(host, repository, snapshot, indices))