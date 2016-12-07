require 'json'
require 'rack'
require 'rack/server'

OK = 200
ACCEPTED = 202
BAD_REQUEST = 400

APPLICATION_JSON = { "Content-Type" => "application/json" }
TEXT_PLAIN = { "Content-Type" => "text/plain" }

TOKEN_RESPONSE = { "access" => { "token" => { "id" => "1337AF" } } }
  
class DevServerApp

  def self.call(env)
    req = Rack::Request.new env
    return [OK, TEXT_PLAIN, [req.inspect]] if req.get?
    if req.post?
      return [OK, APPLICATION_JSON, [TOKEN_RESPONSE.to_json]] if DevServerApp.is_token_req?(req)
      return [ACCEPTED, TEXT_PLAIN, [req.body.string]]
    end
    return [BAD_REQUEST, TEXT_PLAIN, ['Unsupported request.']]
  end

  def self.is_token_req?(req)
    req.env["PATH_INFO"] == "/v2.0/tokens"
  end

end

Rack::Server.start :app => DevServerApp
