#!/usr/bin/env ruby
require 'sinatra'
require 'yaml'

set :bind, '0.0.0.0'
set :port, ENV['HTTP_PORT']

def self.route(*methods, path, &block)
  methods.each do |method|
    method.to_sym
    self.send method, path, &block
  end
end

route :get, :post, :delete, :patch, :put, :head, :options, '/' do
  content_type 'text/plain'

  if request.env['QUERY_STRING'] == ''
    request_path = "#{request.env['REQUEST_PATH']}"
  else
    request_path = "#{request.env['REQUEST_PATH']}?#{request.env['QUERY_STRING']}"
  end
  request_method = request.env['REQUEST_METHOD']
  http_version = request.env['HTTP_VERSION']

  headers = Hash.new
  header_keys = request.env.keys.select {|k| k[/^HTTP_.*$/] }.reject {|k| k == 'HTTP_VERSION'}
  header_keys.each do |key|
    tokens = key.split("_")[1..-1].map {|t| t.capitalize! }
    headers[key] = tokens.join("-")
  end

  header_keys = ['CONTENT_TYPE', 'CONTENT_LENGTH']
  header_keys.each do |key|
    tokens = key.split("_").map {|t| t.capitalize! }
    headers[key] = tokens.join("-")
  end

  return_value = Array.new
  return_value.push "#{request_method} #{request_path} #{http_version}"
  headers.each do |key, header|
    return_value.push "#{header}: #{request.env[key]}"
  end
  return_value.push ''

  return_value.join("\n")
end
