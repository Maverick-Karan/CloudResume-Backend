import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor-counter')

def lambda_handler(event, context):
    response = table.get_item(Key={
            'ID':'1'
    })
    
    views = response['Item']['views']
    views = views + 1
    print(views)
    
    response = table.put_item(Item={
            'ID':'1',
            'views': views
    })

    return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body' : views
    }