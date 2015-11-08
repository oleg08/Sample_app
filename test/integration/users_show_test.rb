require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "should not show inactivated user" do
    log_in_as(@admin)
    get user_path(@non_admin)
    assert_template 'users/show'
    @non_admin.toggle!(:activated)
    get user_path(@non_admin)
    assert_response :redirect
  end

end
