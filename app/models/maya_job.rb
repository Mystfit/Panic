class MayaJob < Job
  include MongoMapper::Document

  key :width, Integer
  key :height, Integer
  key :startFrame, Integer
  key :endFrame, Integer
  key :projectFolder, String
  key :renderFolder, String
  key :scene, String

end
