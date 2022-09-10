import boto3
from botocore import exceptions
from botocore.exceptions import ClientError
import logging
from dotenv import load_dotenv
from os import getenv


s3client = boto3.client(
    's3'
)


def criar_bucket(nome):
    try:
        s3client.create_bucket(Bucket=nome)
    except ClientError as e:
        logging.error(e)
        return False
    return True

criar_bucket('louise-s3-bucket-bootcamp-how')
