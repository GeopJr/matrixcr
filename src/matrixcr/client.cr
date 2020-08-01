require "json"
require "uri"
require "http/client"

module Matrix
  class Client
    Log = Matrix::Log.for("client")

    def initialize(@homeserver : String | Nil = "https://matrix.org",
                   @access_token : String | Nil = nil, @user : String | Nil = nil, @password : String | Nil = nil)
      raise ArgumentError.new("Missing authentication info") if @access_token.nil? && (@user.nil? || @password.nil?)
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

    private def default_headers(params : Hash(String, String)? = Hash(String, String).new)
      return HTTP::Headers{
        "Authorization" => "Bearer #{@access_token}",
        "User-Agent":      "matrixcr v#{Matrix::VERSION}",
      }.merge!(params)
    end
  end
end
