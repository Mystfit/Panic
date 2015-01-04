class Worker
  include MongoMapper::Document

  key :name, String
  key :status, String
  
  many :tasks
end
