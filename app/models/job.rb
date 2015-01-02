class Job
    include MongoMapper::Document

    key :name, String
    key :status, String
    many :tasks

    def initialize(attributes={})
        super
        self.status = Task::IDLE
    end
end