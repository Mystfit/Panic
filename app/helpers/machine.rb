require 'digest/md5'
require 'rubygems'
require 'mongo'
require 'mongo_queue'
require_dependency 'workers/maya_Task_runner'

class Machine
    attr_reader :queue

    def initialize
        db = Mongo::Connection.new('localhost')
        config = {
            :timeout => 90,
            :attempts => 2,
            :database => "panic_development", # Set this from rails config
            :collection => "task_tickets"
        }
        @queue = Mongo::Queue.new(db, config)
        @process_id = Digest::MD5.hexdigest("#{Socket.gethostname}-#{Process.pid}-#{Thread.current}")
    end

    def listen
        #
        puts "Starting Panic worker"
        
        loop do
            pollTasks
            sleep(5)
        end
    end

    def pollTasks
        doc = @queue.lock_next(@process_id)
        if doc
            status = MayaTaskRunner.new(Task.find(doc["taskId"])).execute
            if status == 0
                @queue.complete(doc, @process_id)
            else
                @queue.error(doc, status)
            end
            puts "Finished task"
        end
    end
end