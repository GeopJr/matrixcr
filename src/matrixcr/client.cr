require "uri"
require "./api"

module Matrix
  class Client
    Log = Matrix::Log.for("client")
    @backoff : Float64

    def initialize(@homeserver : String | Nil = "https://matrix.org",
                   @access_token : String | Nil = nil, @user : String | Nil = nil, @password : String | Nil = nil)
      raise ArgumentError.new("Missing authentication info") if @access_token.nil? && (@user.nil? || @password.nil?)
      @backoff = 3.0
      @homeserver = URI.parse(@homeserver.not_nil!).host
      @client = HTTP::Client.new(@homeserver.not_nil!)
      if @access_token.nil?
        body = {"type" => "m.login.password", "user" => "#{@user}", "password" => "#{@password}"}
        response = @client.post("/_matrix/client/r0/login", headers: HTTP::Headers{"User-Agent" => "matrixcr v#{Matrix::VERSION}"}, body: body.to_json)
        value = JSON.parse(response.body)
        raise ArgumentError.new(value["error"].to_s) if value["error"]?
        @access_token = value["access_token"].to_s
      end
    end

    private def sync(timeout : Int32 | Nil = 0, since : String | Nil = nil)
      params = Hash(String, String).new
      params["timeout"] = timeout.to_s
      params["since"] = since unless since.nil?
      response = @client.get("/_matrix/client/r0/sync?" + HTTP::Params.encode(params), headers: default_headers)
      return JSON.parse(response.body)
    end

    def run(@next_batch : String | Nil = nil)
      @alive = true
      while @alive
        begin
          response = sync(30000, @next_batch)
          @next_batch = response["next_batch"].to_s if response["next_batch"]?
        rescue ex
          # TODO: Add some sort of error log
          wait_for_resync
        end
      end
    end

    private def wait_for_resync
      # Wait before reconnecting so we don't spam Discord's servers.
      # TODO: Add some sort of debug log
      sleep @backoff.seconds
      # Calculate new backoff
      @backoff = 3.0 if @backoff < 3.0
      @backoff *= 1.5
      @backoff = 115 + (rand * 10) if @backoff > 120 # Cap the backoff at 120 seconds and then add some random jitter
      return true
    end

    private def default_headers(params : Hash(String, String)? = Hash(String, String).new)
      return HTTP::Headers{
        "Authorization" => "Bearer #{@access_token}",
        "User-Agent":      "matrixcr v#{Matrix::VERSION}",
      }.merge!(params)
    end
  end
end
