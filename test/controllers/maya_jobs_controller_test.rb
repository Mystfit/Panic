require 'test_helper'

class MayaJobsControllerTest < ActionController::TestCase
  setup do
    @maya_job = maya_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maya_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maya_job" do
    assert_difference('MayaJob.count') do
      post :create, maya_job: {  }
    end

    assert_redirected_to maya_job_path(assigns(:maya_job))
  end

  test "should show maya_job" do
    get :show, id: @maya_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maya_job
    assert_response :success
  end

  test "should update maya_job" do
    patch :update, id: @maya_job, maya_job: {  }
    assert_redirected_to maya_job_path(assigns(:maya_job))
  end

  test "should destroy maya_job" do
    assert_difference('MayaJob.count', -1) do
      delete :destroy, id: @maya_job
    end

    assert_redirected_to maya_jobs_path
  end
end
