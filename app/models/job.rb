class Job
    include MongoMapper::Document

    key :user, String
    key :name, String
    key :status, String
    many :tasks
    timestamps!

    def initialize(attributes={})
        super
        self.status = Task::IDLE
    end

    def start
        MayaTask.all(:job_id => id).each {|t| t.createTicket}
        self.status = Task::RUNNING
        self.save
    end

    def createTasks
        raise NotImplementedError
    end

    def taskCompleted
        queuedTasks = Task.all(:job_id => id, :status => Task::QUEUED)
        self.status = Task::COMPLETE if queuedTasks.empty?
        self.save
    end

end