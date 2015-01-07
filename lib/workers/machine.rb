require 'sidekiq'
require 'etc'

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

        # Run task as a seperate user
        status = as_user "render" do |user|
            execute task
        end
        puts "Exit status 2: #{status}"

        if status == 0 
            task.complete 
        else 
            task.fail
        end

        @worker.status = Status::IDLE
        @worker.save
    end

    def as_user(user, &block)
      # Find the user in the password database.
      u = (user.is_a? Integer) ? Etc.getpwuid(user) : Etc.getpwnam(user)
     
      # Fork the child process. Process.fork will run a given block of code
      # in the child process.
      Process.fork do
        # We're in the child. Set the process's user ID.
        #Process.uid = u.uid
        Process::Sys.setuid(u.uid)
     
        # Invoke the caller's block of code.
        status = block.call(user)
      end
      Process.wait      ## if this hangs sidekiq from getting another job wer'e all set
      puts "Exit status 1: #{$?.exitstatus}"
      return $?.exitstatus
    end

    def execute(task)
        command = buildCommand(task)
        puts "Running command " + command + " as #{`whoami`}"
        IO.popen(command) { |line|
            progress = parseProgress(line)
            puts progress
        }
        # Return exit code
        return $?.to_i
    end

    ### Implemented by different worker types
    def parseProgress
        raise NotImplementedError
    end

    def buildCommand
        raise NotImplementedError
    end
end