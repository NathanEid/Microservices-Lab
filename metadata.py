import boto3
import csv

sqs_resource = boto3.resource('sqs')
sqs_client = boto3.client('sqs')
s3 = boto3.resource('s3')
queue = sqs_resource.get_queue_by_name(QueueName='second_sqs')

while True:
    response = sqs_client.receive_message(QueueUrl=queue.url, MaxNumberOfMessages=1)
    messages = response.get('Messages', [])
    if not messages:
        continue
    message = messages[0]
    receipt_handle = message['ReceiptHandle']
    with open('metadata.csv', 'w') as csv_file:  
        writer = csv.writer(csv_file)
        for key, value in response.items():
            writer.writerow([key, value])

    sqs_client.delete_message(QueueUrl=queue.url, ReceiptHandle=receipt_handle)
    print("The Metadata File .csv is Downloaded and Message Deleted")
    print("Watting...")

