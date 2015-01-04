class MayaJob < Job
  include MongoMapper::Document

  key :width, Integer
  key :height, Integer
  key :startFrame, Integer
  key :endFrame, Integer
  key :projectFolder, String
  key :renderFolder, String
  key :scene, String

  def createTasks
  	for frame in startFrame..endFrame
        MayaTask.create(
          :job_id => id,
          :width => width,
          :height => height,
          :frame => frame,
          :projectFolder => projectFolder,
          :renderFolder => renderFolder,
          :scene => scene
        )
      end
    self.save
  end
end
