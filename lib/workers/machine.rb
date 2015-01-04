require 'rubygems'
require_dependency 'workers/ticket_queue'
require_dependency 'workers/maya_task_runner'

class Machine
    attr_reader :queue

    def initialize
        #process_id = Digest::MD5.hexdigest("#{Socket.gethostname}-#{Process.pid}-#{Thread.current}")
        @worker = Worker.find_or_create_by_id(Socket.gethostname)
        @worker.status = Status::IDLE
        @worker.save
        @queue = TicketQueue.new("#{Socket.gethostname}-#{Process.pid}-#{Thread.current}")
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
            task.status = Status::RUNNING
            task.save

            status = MayaTaskRunner.new(task).execute
            if status == 0
                task.complete
                @queue.complete(doc)
            else
                task.fail
                @queue.error(doc, status)
            end
            puts "Finished task"
            @worker.status = Status::IDLE
            @worker.save
        end
    end
end

Machine.new.listen