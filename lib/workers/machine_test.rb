require_dependency 'workers/machine'

# Job test case
machine = Machine.new
machine.queue.cleanup! # remove expired locks

taskA = MayaTask.create(
        :width => 1280,
        :height => 720,
        :frame => 4,
        :projectFolder => "/Users/mystfit/Desktop/testRenders",
        :renderFolder => "/Users/mystfit/Desktop/renders",
        :scene => "testScene.ma"
    )
taskB = MayaTask.create(
        :width => 1280,
        :height => 720,
        :frame => 5,
        :projectFolder => "/Users/mystfit/Desktop/testRenders",
        :renderFolder => "/Users/mystfit/Desktop/renders",
        :scene => "testScene.ma"
    )
job = Job.create(:name => "ByronTestJob", :tasks => [taskA, taskB])

machine.queue.insert({:taskId => taskA.id})
machine.queue.insert({:taskId => taskB.id})

machine.listen