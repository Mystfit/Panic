require_dependency 'workers/ticket_queue'

class Task
    include MongoMapper::Document

    @@queue = TicketQueue.new

    # Status codes for tasks
    IDLE = "idle"
    QUEUED = "queued"
    RUNNING = "running"
    PAUSED = "paused"
    FAILED = "failed"
    COMPLETE = "complete"

    key :status, String
    belongs_to :job

    def initialize(attributes={})
        super
        self.status = IDLE
    end

    def toCommand
        raise NotImplementedError
    end

    def createTicket
        @@queue.insert({:taskId => id})
        self.status = QUEUED
    end
end
