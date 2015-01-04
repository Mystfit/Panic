require_dependency 'workers/ticket_queue'

class Task
    include MongoMapper::Document

    @@queue = TicketQueue.new("distributor")

    key :status, String
    belongs_to :job

    def initialize(attributes={})
        super
        self.status = Status::IDLE
        self.save
    end

    def toCommand
        raise NotImplementedError
    end

    def createTicket
        @@queue.insert({:taskId => id})
        self.status = Status::QUEUED
        self.save
    end

    def complete
        self.status = Status::COMPLETE
        self.save
        job.taskCompleted
    end

    def fail
        self.status = Status::FAILED
        self.save
        job.taskCompleted
    end
end
