json.array!(@maya_jobs) do |maya_job|
  json.extract! maya_job, :id
  json.url maya_job_url(maya_job, format: :json)
end
