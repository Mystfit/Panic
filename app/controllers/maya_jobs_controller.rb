class MayaJobsController < ApplicationController
  before_action :set_maya_job#, only: [:index, :show, :edit, :update, :destroy, :start]

  # GET /maya_jobs
  # GET /maya_jobs.json
  def index
  end

  # GET /maya_jobs/1
  # GET /maya_jobs/1.json
  def show
    @maya_job_tasks = MayaTask.all(:job_id => @maya_job.id)
  end

  # GET /maya_jobs/new
  def new
    @maya_job = MayaJob.new
  end

  # GET /maya_jobs/1/edit
  def edit
  end

  def start
    @maya_job.start
    respond_to do |format|
      format.html { redirect_to maya_jobs_url, notice: 'Maya job started.' }
      format.json { head :no_content }
    end
  end

  # POST /maya_jobs
  # POST /maya_jobs.json
  def create
    @maya_job = MayaJob.new(maya_job_params)
    @maya_job.createTasks

    respond_to do |format|
      if @maya_job.save
        format.html { redirect_to @maya_job, notice: 'Maya job was successfully created.' }
        format.json { render :show, status: :created, location: @maya_job }
      else
        format.html { render :new }
        format.json { render json: @maya_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maya_jobs/1
  # PATCH/PUT /maya_jobs/1.json
  def update
    respond_to do |format|
      if @maya_job.update_attributes(maya_job_params)
        format.html { redirect_to @maya_job, notice: 'Maya job was successfully updated.' }
        format.json { render :show, status: :ok, location: @maya_job }
      else
        format.html { render :edit }
        format.json { render json: @maya_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maya_jobs/1
  # DELETE /maya_jobs/1.json
  def destroy
    MayaTask.all(:job_id => @maya_job.id).each {|t| t.destroy}
    @maya_job.destroy
    respond_to do |format|
      format.html { redirect_to maya_jobs_url, notice: 'Maya job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maya_job
      @maya_jobs = MayaJob.all
      @maya_job = MayaJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maya_job_params
      params[:maya_job]
    end    
end
