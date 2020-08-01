require "json"
require "http/client"
require "./mappings/api"

module Matrix
  module API
    Log = Matrix::Log.for("api")

    def whoami
      response = @client.get("/_matrix/client/r0/account/whoami", headers: default_headers)
      return Whoami.from_json(response.body)
    end
  end
end
