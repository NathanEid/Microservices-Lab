import boto3
import json

sqs_client = boto3.client('sqs')
s3 = boto3.client('s3')

sqs_resource = boto3.resource('sqs')
queue = sqs_resource.get_queue_by_name(QueueName='first_sqs')
queue_url = queue.url

while True:
    response = sqs_client.receive_message(QueueUrl=queue_url, MaxNumberOfMessages=1)
    messages = response.get('Messages', [])
    if not messages:
        continue
    message = messages[0]
    body = json.loads(message['Body'])
    receipt_handle = message['ReceiptHandle']
    message_body = json.loads(body["Message"])
    record = message_body["Records"][0]
    bucket_name = record["s3"]["bucket"]["name"]
    file_name = record["s3"]["object"]["key"]
    s3.download_file(bucket_name, file_name, f'/home/nathan/microservices/{file_name}')
    print(f'File: {file_name} Downloaded from the Backup S3 Bucket')

    sqs_client.delete_message(QueueUrl=queue_url, ReceiptHandle=receipt_handle)
    print(f'Message Deleted')
    
    with open(f'{file_name}', 'r') as f:
        data = f.read()
        data = data.replace(',', '\n')

    with open(f'{file_name}', 'w') as f:
        f.write(data)

    print(f'File: {file_name} Edited')
    s3.upload_file(file_name, 'second-s3-95724', file_name )
    print(f'File: {file_name} Uploaded to the Backup S3 Bucket')
    print("Watting...")

