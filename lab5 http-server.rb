require 'socket'
require 'rack'
require 'rack/utils'
load 'script1.rb'

server = TCPServer.new('0.0.0.0', 3000)

class App

  def initialize
    @machine = CashMachine.new
  end

	def call(env)
		req = Rack::Request.new(env)
		
		case req.path
    when '/deposit'
      value = req.query_string.split('=')[1].to_f.floor(2)
      @machine.deposit(value)? err = '': err = "Error! You input wrong number (#{value}). Change value for take deposit & try again"
			[200, {'Content-Type' => 'text/html'}, ["Your deposit: #{@machine.get_deposit} Your balance is: #{@machine.money}\n#{err}"]]
    when '/withdraw'
      value = req.query_string.split('=')[1].to_f.floor(2)
      @machine.withdraw(value)? err = '': err = "Error! You input wrong number (#{value}). Change value for take withdraw & try again"
      [200, {'Content-Type' => 'text/html'}, ["Your balance is: #{@machine.money}\n#{err}"]]
    when '/balance'
			[200, {'Content-Type' => 'text/html'}, ["Your balance now: #{@machine.money}"]]
		else
			[404, {'Content-Type' => 'text/html'}, ["Not found\nreq.path = #{req.path}"]]
		end
	end
end

app = App.new

while connection = server.accept
  request = connection.gets
  method, full_path = request.split(' ')
  path, query = full_path.split('?')
  
  status, headers, body = app.call({
    'REQUEST_METHOD' => method,
    'PATH_INFO' => path,
    'QUERY_STRING' => query
  })
 
  connection.print("HTTP/1.1 #{status}\r\n")

  headers.each { |key, value|  connection.print("#{key}: #{value}\r\n") }

  connection.print "\r\n"

  body.each { |part| connection.print(part) }

  connection.close
end
