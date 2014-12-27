#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"

puts "./script pad " if not ARGV
padurl = ARGV[0]
uri = URI(padurl)
padname = padurl.split("/").last

TOKEN="t.1"#token=t.1

CLIENTREADY=JSON(
  {
    "component"=>"pad",
    "type"=>"CLIENT_READY",
    "padId"=>padname,
    "sessionID"=>"null",
    "password"=>"null",
    "token"=>TOKEN,
    "protocolVersion"=>2
  }
)

#connect and get a cookie
res = Net::HTTP.get_response(uri)
COOKIE = res['Set-Cookie'].split(';').select{|p|p.match(/^express_sid/)}.first

#connect to the xhr interface
xhr = URI("#{uri.scheme}://#{uri.hostname}:#{uri.port}/socket.io/1")
req = Net::HTTP::Get.new(xhr.request_uri)
req['Cookie'] = COOKIE
res = Net::HTTP.start(xhr.hostname,xhr.port) {|http|
  http.request(req)
}
XHREND = URI("#{xhr}/xhr-polling/#{res.body.split(":").first}")
req = Net::HTTP::Get.new(XHREND.request_uri)
req['Cookie'] = "#{COOKIE}; token=#{TOKEN}"
res = Net::HTTP.start(XHREND.hostname,XHREND.port) {|http|
  http.request(req)
}

#tell ep we are ready
http = Net::HTTP.new(XHREND.host,XHREND.port)
req = Net::HTTP::Post.new(XHREND.request_uri)
req['Cookie'] = "#{COOKIE}; token=#{TOKEN}"
req.body = "4:::#{CLIENTREADY}"
res=http.request(req)

#get our author name
#and the initial text which we need to build our CLEARPAD changeset
req = Net::HTTP::Get.new(XHREND.request_uri)
req['Cookie'] = "#{COOKIE}; token=#{TOKEN}"
res = Net::HTTP.start(XHREND.hostname,XHREND.port) {|http|
  http.request(req)
}
AUTHOR = res.body.match(/userId":"([^"]+)/)[1]
initialtext = JSON.parse(res.body.split(':::')[1].match(/(.*}})(.[0-9]+.4$)?/)[1])['data']['collab_client_vars']['initialAttributedText']['text']

size=initialtext.size.to_s(36)
drop=(initialtext.size-1).to_s(36)
lines=initialtext.scan("\n").size-1 #last char is always \n
CLEARPADCS="Z:#{size}<#{drop}|#{lines+30}-#{drop}$"
puts CLEARPADCS

CLEARPAD="4:::{\"type\":\"COLLABROOM\",\"component\":\"pad\",\"data\":{\"type\":\"USER_CHANGES\",\"baseRev\":2000,\"changeset\":\"#{CLEARPADCS}\",\"apool\":{\"numToAttrib\":{},\"nextNum\":0}}}"
http = Net::HTTP.new(XHREND.host,XHREND.port)
req = Net::HTTP::Post.new(XHREND.request_uri)
req['Cookie'] = "#{COOKIE}; token=#{TOKEN}"
req.body = CLEARPAD
res=http.request(req)

req = Net::HTTP::Get.new(XHREND.request_uri)
req['Cookie'] = "#{COOKIE}; token=#{TOKEN}"
res = Net::HTTP.start(XHREND.hostname,XHREND.port) {|http|
  http.request(req)
}
