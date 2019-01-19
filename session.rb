# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

require 'colorized_string'

class Session

  def initialize(api, jwt)
    @api = api
    @jwt = jwt
  end

  def phase(title)
    puts
    puts ColorizedString[title].light_cyan
  end

  def get(uri, expected_status=200)
    @api.send(:get, uri, nil, expected_status, @jwt)
  end

  def patch(uri, body, expected_status=200)
    @api.send(:patch, uri, body, expected_status, @jwt)
  end

  def post(uri, body, expected_status=200)
    @api.send(:post, uri, body, expected_status, @jwt)
  end

  def put(uri, body, expected_status=200)
    @api.send(:put, uri, body, expected_status, @jwt)
  end

  def wait_for(uri, required_status=200)
    response = nil
    last_error = nil
    for i in 1..5
      begin
        response = get(uri, required_status)
        return response
      rescue AcceptanceTestError => e
        last_error = e
        sleep 0.3
      end
    end
    raise last_error if last_error
    response
  end

  def wait_until(request)
    for i in 1..5
      response = get(request)
      return response if yield response
      sleep 0.3
    end
    raise AcceptanceTestError
  end

end

