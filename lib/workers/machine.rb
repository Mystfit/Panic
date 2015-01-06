require 'sidekiq'

class Machine
    include Sidekiq::Worker

    def initialize
        @worker = Worker.find_or_create_by_id(Socket.gethostname)
        @worker.status = Status::IDLE
        @worker.save
    end

    def perform(taskId)
        task = Task.find(taskId)
        task.status = Status::RUNNING
        task.save

        status = execute(task)
        if status == 0
            task.complete
        else
            task.fail
        end
        puts "Finished task"
        @worker.status = Status::IDLE
        @worker.save
    end

    def execute(task)
        command = buildCommand(task)
        puts "Running command " + command
        IO.popen(command) { |line|
            progress = parseProgress(line)
            puts progress
        }
        # Return exit code
        $?.to_i
    end

    ### Implemented by different worker types
    def parseProgress
        raise NotImplementedError
    end

    def buildCommand
        raise NotImplementedError
    end
end