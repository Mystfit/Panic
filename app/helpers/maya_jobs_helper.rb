module MayaJobsHelper
  def jobIsSelected(job)
    return 'email-item-selected' if ((@maya_job.id == job.id) if @maya_job)
  end

  def jobStatusClass(job)
    jobClass = ""
    jobClass = 'email-item-unread' if job.status == Status::RUNNING
    jobClass = 'email-item-complete' if job.status == Status::COMPLETE
    jobClass = 'email-item-failed' if job.status == Status::FAILED
    return jobClass
  end
end
