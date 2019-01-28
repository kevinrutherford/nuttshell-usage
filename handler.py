import os
import json
from slack import Slack

def main(event, context):
    slack = Slack(os.environ['SLACK_MESSAGE_URL'])
    slack.ok('Test OK')
    body = {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "input": event
    }
    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }
    return response

