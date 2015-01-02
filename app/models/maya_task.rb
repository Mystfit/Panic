
class MayaTask < Task
    key :width, Integer
    key :height, Integer
    key :frame, Integer
    key :projectFolder, String
    key :renderFolder, String
    key :scene, String

    def toCommand
        command = "Render"
        command << " -r mr -v 5"
        command << " -x " + width.to_s if width
        command << " -y " + height.to_s if height
        command << " -s " + frame.to_s if frame
        command << " -e " + frame.to_s if frame
        command << " -proj " + projectFolder if projectFolder
        command << " -rd " + renderFolder if renderFolder
        command << " " + projectFolder + "/scenes/" + scene
        return command
    end
end
