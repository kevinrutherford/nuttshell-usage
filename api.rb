# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

require 'faraday'
require 'faraday_middleware'
require 'json'
require 'colorized_string'

class AcceptanceTestError < StandardError
end

class Api

  def initialize(hostname, silent)
    @silent = silent
    puts ColorizedString["Connecting to #{hostname}"].yellow unless @silent
    @connection = Faraday.new(url: hostname) do |faraday|
      faraday.options[:timeout] = 2
      faraday.response :json, :content_type => /\bjson$/, :parser_options => { :symbolize_names => true }
      faraday.response :mashify
      faraday.adapter Faraday.default_adapter
    end
  end

  def send(method, uri, body, expected_status, jwt)
    payload = body ? body.to_json : nil
    for i in 1..5
      print ColorizedString["    #{method.to_s.upcase}"].yellow unless @silent
      print ColorizedString[" #{uri} ... "].white unless @silent
      response = @connection.send(method, uri, payload) do |request|
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] = "Bearer #{jwt}"
      end
      if response.status == expected_status
        puts ColorizedString["#{response.status}"].green unless @silent
        return response.body
      elsif response.status != 502 && response.status != 503
        print ColorizedString[response.status.to_s].red unless @silent
        puts ColorizedString[" #{response.body.to_s[0...200]}"].cyan unless @silent
        raise AcceptanceTestError
      end
      sleep 0.3
    end
    raise AcceptanceTestError
  end

end

