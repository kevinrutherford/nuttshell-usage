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

  def get(uri, expected_status=200)
    @api.send(:get, uri, nil, expected_status, @jwt)
  end

end

