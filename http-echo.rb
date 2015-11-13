#!/usr/bin/env ruby

body = ""
flag = true
while flag
  line = gets
  body << line
  flag = false if line.strip.empty?
end

puts 'HTTP/1.0 200 OK'
puts 'Content-Type: text/plain'
puts "Content-Length: #{body.length}"
puts ''

puts body
