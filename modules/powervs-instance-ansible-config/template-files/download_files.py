import os
import sys

import boto3


def download_pha_from_cos(cos, bucket_name, folder_name):
    # Download PAH file from COS
    try:
        my_bucket = cos.list_objects(Bucket="powerha-images", Prefix=folder_name + "/")
        for obj in my_bucket["Contents"]:
            key = obj["Key"]

            # created directories in local
            if not os.path.exists("./" + os.path.dirname(key)):
                os.makedirs("./" + os.path.dirname(key))
            cos.download_file(bucket_name, key, "./" + key)

            # Unzip and extract powerha tar file
            if not os.path.exists("./" + folder_name + "/pha/" + key.split("/")[1]):
                os.makedirs("./" + folder_name + "/pha/" + key.split("/")[1])
            os.system(
                f"gunzip -c {key} | tar -xvf -  -C ./{folder_name}/pha/"
                + key.split("/")[1]
            )

        print(f"File downloaded, unzip and extracted successfully to: {folder_name}")

    except Exception as e:
        print(f"Error downloading file: {e}")


def download_file_from_cos(cos, bucket_name, file_path):
    # Download file from COS
    try:
        cos.download_file(bucket_name, file_path, file_path)
        print(f"File downloaded successfully to: {file_path}")
    except Exception as e:
        print(f"Error downloading file: {e}")


if __name__ == "__main__":

    type = sys.argv[1]
    bucket_name = sys.argv[2]
    path = sys.argv[3]
    cos_endpoint = sys.argv[4]
    cos_access_key_id = sys.argv[5]
    cos_secret_access_key = sys.argv[6]
    cos = boto3.client(
        "s3",
        endpoint_url=cos_endpoint,
        aws_access_key_id=cos_access_key_id,
        aws_secret_access_key=cos_secret_access_key,
    )
    if type == "pha":
        download_pha_from_cos(cos, bucket_name, path)
    elif type == "file":
        download_file_from_cos(cos, bucket_name, path)
    else:
        print("Error downloading file")
