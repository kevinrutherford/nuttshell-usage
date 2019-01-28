# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

import requests

class Slack:

    def __init__(self, url):
        self.url = url

    def ok(self, message):
        r = requests.post(self.url, json={
            'mrkdwn': True,
            'attachments': [{
                'color': 'good',
                'pretext': 'Nuttshell API test heartbeat',
                'text': '```{}```'.format(message)
                }]
        })
        if r.status_code != requests.codes.ok:
            print('POST to Slack channel: exit status {}, response {}'.format(r.status_code, r.text))

    def error(self, message):
        r = requests.post(self.url, json={
            'mrkdwn': True,
            'attachments': [{
                'color': 'danger',
                'pretext': 'Nuttshell API test error',
                'text': '```{}```'.format(message)
                }]
        })
        if r.status_code != requests.codes.ok:
            print('POST to Slack channel: exit status {}, response {}'.format(r.status_code, r.text))

