# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

import requests
import time
from journey_test_error import JourneyTestError

class Api:

    def __init__(self, hostname, busy_wait, busy_retries, log):
        self.log = log
        self.hostname = hostname
        self.busy_wait = busy_wait
        self.busy_retries = busy_retries
        self.log.write('Connecting to {}\n'.format(hostname))

    def send(self, method, uri, body, expected_status, jwt):
        send = getattr(requests, method)
        endpoint = self.hostname + uri
        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer {}'.format(jwt)
        }
        for attempt in range(self.busy_retries):
            self.log.write('  {} {}... '.format(method.upper(), uri))
            r = send(endpoint, headers = headers, json = body)
            self.log.write('{}\n'.format(str(r.status_code)))
            if r.status_code == expected_status:
                return r.json()
            elif r.status_code != 502 and r.status_code != 503:
                self.log.write('  Response: {}\n'.format(r.text))
                err = 'ERROR: Unexpected status code from API call. Expected {} but was {}\n'.format(expected_status, r.status_code)
                raise JourneyTestError(err)
            time.sleep(self.busy_wait)
        raise JourneyTestError('Service not ready after {} retries\n'.format(self.busy_retries))

