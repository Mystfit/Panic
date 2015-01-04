require 'digest/md5'
require 'mongo'
require 'mongo_queue'

class TicketQueue < Mongo::Queue

    def initialize(name)
        @name = name
        db = Mongo::Connection.new('localhost')
        config = {
            :timeout => 90,
            :attempts => 2,
            :database => "panic_development", # Set this from rails config
            :collection => "task_tickets"
        }
        super(db, config)
    end

    def lock_next
        super(@name)
    end

    def complete(doc)
        super(doc, @name)
    end
end