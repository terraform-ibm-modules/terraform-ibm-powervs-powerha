import glob
import os
import shutil
import sys

import boto3

DIR_PATH = os.path.dirname(os.path.realpath(__file__))


class CustomError(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


def validate_filesets(cluster_type, folder_path):
    file_sets = license_file_sets = []
    if cluster_type.lower() == "pha_standard":
        file_sets = glob.glob(f"{folder_path}/**/cluster.doc*", recursive=True)
        if len(file_sets):
            print("PowerHA filesets are found.")
        else:
            raise CustomError("Error: PowerHA filesets are not found.")

    elif cluster_type.lower() == "pha_glvm":
        file_sets = glob.glob(f"{folder_path}/**/cluster.xd.glvm*", recursive=True)
        license_file_sets = glob.glob(
            f"{folder_path}/**/cluster.xd.license*", recursive=True
        )
        if len(file_sets) and len(license_file_sets):
            print("Mandatory GLVM filesets are found.")
        elif not len(file_sets):
            raise CustomError(
                "Error: Mandatory GLVM filesets are not found. Include cluster.xd.glvm filesets along with PowerHA filesets in COS folder."
            )
        else:
            raise CustomError(
                "Error: Mandatory GLVM filesets are not found. Include cluster.xd.license filesets along with PowerHA filesets in COS folder."
            )

    # Delete folder after validation
    shutil.rmtree(f"{folder_path}")


def download_pha_from_cos(cos, bucket_name, folder_name, cluster_type):
    # Download PowerHA file from COS
    try:
        my_bucket = cos.list_objects(Bucket=bucket_name, Prefix=folder_name + "/")
        list_of_file = [
            item["Key"]
            for item in my_bucket["Contents"]
            if item["Key"].endswith((".tar", ".tar.gz"))
        ]
        for key in list_of_file:
            # created directories in local
            dir = os.path.join(DIR_PATH, os.path.dirname(key))
            file = os.path.join(DIR_PATH, key)
            if not os.path.exists(dir):
                os.makedirs(dir)
            cos.download_file(bucket_name, key, file)
            # Unzip and extract PowerHA tar file
            if key.endswith(".tar.gz"):
                os.system(f"gunzip -c {file} | tar -xvf - -C /{dir}")
            else:
                os.system(f"tar -xvf {file} -C /{dir}")

        print(
            f"PowerHA filesets downloaded, unzip and extracted successfully to: {folder_name} folder."
        )

    except Exception:
        raise CustomError(
            "Error: Unable to download the PowerHA filesets, Please check COS Details."
        )

    if cluster_type.lower() in ["pha_standard", "pha_glvm"]:
        validate_filesets(cluster_type, os.path.join(DIR_PATH, folder_name))


def download_file_from_cos(cos, bucket_name, file_path):
    # Download file from COS
    try:
        cos.download_file(bucket_name, file_path, file_path)
        print(f"File downloaded successfully to: {file_path}")
    except Exception:
        raise CustomError("Error: Downloading file.")


if __name__ == "__main__":

    solution_type = sys.argv[1]  # Supported ["pha_glvm", "pha_standard", "pha", "file"]
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
    if solution_type.startswith("pha"):
        download_pha_from_cos(cos, bucket_name, path, solution_type)
    elif solution_type == "file":
        download_file_from_cos(cos, bucket_name, path)
    else:
        raise CustomError(
            "Error: downloading file, It support solution type : [pha_glvm, pha_standard, pha, file]."
        )
