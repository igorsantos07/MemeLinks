case Padrino.env
  when :development then db = {name: 'memelinks_development', host: 'localhost', port: Mongo::Connection::DEFAULT_PORT}
  when :test        then db = {name: 'memelinks_test', host: 'localhost', port: Mongo::Connection::DEFAULT_PORT}
  when :production  then db = {name: 'memelinks_production', host: 'ds031107.mongolab.com', port: 31107}
end

Mongoid.database = Mongo::Connection.new(db['host'], db['port']).db(db['name'])

# You can also configure Mongoid this way
# Mongoid.configure do |config|
#   name = @settings["database"]
#   host = @settings["host"]
#   config.master = Mongo::Connection.new.db(name)
#   config.slaves = [
#     Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#     Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#   ]
# end
#
# More installation and setup notes are on http://mongoid.org/docs/
