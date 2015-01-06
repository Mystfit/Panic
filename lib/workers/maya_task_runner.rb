require 'workers/machine'

class MayaTaskRunner < Machine
    def buildCommand(task)
        command = "/Applications/Autodesk/maya2014/Maya.app/Contents/bin/" + task.toCommand
    end

    def parseProgress(line)
        if line.include? "%"
            splitLine = line.chomp.split
            progress = splitline[5][0..-1].to_f.round
        end
    end
end