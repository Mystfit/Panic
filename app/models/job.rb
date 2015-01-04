class Job
    include MongoMapper::Document

    key :user, String
    key :name, String
    key :status, String
    many :tasks
    timestamps!

    def initialize(attributes={})
        super
        self.status = Status::IDLE
    end

    def start
        MayaTask.all(:job_id => id).each {|t| t.createTicket}
        self.status = Status::RUNNING
        self.save
    end

    def createTasks
        raise NotImplementedError
    end

    def taskCompleted
        queuedTasks = Task.all(:job_id => id, :status => Status::QUEUED)
        self.status = Status::COMPLETE if queuedTasks.empty?
        self.save
    end

end