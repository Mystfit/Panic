class Task
  include MongoMapper::Document

  belongs_to :job

  def toCommand
  	raise NotImplementedError
  end
end
