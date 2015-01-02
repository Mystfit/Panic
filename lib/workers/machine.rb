require 'rubygems'
require_dependency 'workers/ticket_queue'
require_dependency 'workers/maya_task_runner'

class Machine
    attr_reader :queue

    def initialize
        @queue = TicketQueue.new
        # db = Mongo::Connection.new('localhost')
        # config = {
        #     :timeout => 90,
        #     :attempts => 2,
        #     :database => "panic_development", # Set this from rails config
        #     :collection => "task_tickets"
        # }
        # @queue = Mongo::Queue.new(db, config)
        # @process_id = Digest::MD5.hexdigest("#{Socket.gethostname}-#{Process.pid}-#{Thread.current}")
    end

    def listen
        puts "Starting Panic worker"
        loop do
            sleep(5) if pollTasks.nil?
        end
    end

    def pollTasks
        doc = @queue.lock_next
        if doc
            task = Task.find(doc["taskId"])
            task.status = Task::RUNNING
            task.save

            status = MayaTaskRunner.new(task).execute
            if status == 0
                task.status = Task::COMPLETE
                @queue.complete(doc)
            else
                task.status = Task::ERROR
                @queue.error(doc, status)
            end
            puts "Finished task"
            task.save
        end
    end
end

Machine.new.listen