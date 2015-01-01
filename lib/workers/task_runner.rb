class TaskRunner
    def initialize(task)
        @task = task
    end

    def runningTask
        return @task
    end

    def parseProgress
        raise NotImplementedError
    end

    def execute
        command = buildCommand()
        puts "Running command " + command
        IO.popen(command) { |line|
            progress = parseProgress(line)
            puts progress
        }
        # Return exit code
        $?.to_i
    end
end