# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

require 'dotenv'
Dotenv.load('./.env')
require 'colorized_string'
require_relative './api'
require_relative './session'

class Server
  class << self
    def connect(silent: false)
      username = ENV['SUPERUSER_EMAIL']
      password = ENV['SUPERUSER_PASSWORD']
      Server.new(hostname, username, password, silent)
    end

    def hostname
      ENV['API_HOST'] || "http://#{find_api_container_ip}"
    end

    private

    def find_api_container_ip
      `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nuttshell_api_1`.chomp
    end

  end

  def login
    begin
      response = @api.send(:post, '/login', {
        emailAddress: @username,
        password: @password
      }, 200, nil)
      @session = Session.new(@api, response[:jwt])
      yield @session
      puts
    rescue AcceptanceTestError
      puts
      exit 1
    rescue StandardError => e
      puts
      puts ColorizedString[e.message].red
      puts
      puts e.backtrace
      puts
      exit 1
    end
  end

  private

  def initialize(hostname, username, password, silent)
    @api = Api.new(hostname, silent)
    @username = username
    @password = password
  end

end

