require 'digest/md5'
require 'mongo'
require 'mongo_queue'

class TicketQueue < Mongo::Queue

    def initialize
        @process_id = Digest::MD5.hexdigest("#{Socket.gethostname}-#{Process.pid}-#{Thread.current}")

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
        super(@process_id)
    end

    def complete(doc)
        super(doc, @process_id)
    end
end