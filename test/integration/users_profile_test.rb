require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other = users(:mallory)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    assert_match  /2\\n\n\s+following/, response.body
    assert_difference @user.following_ids.count.to_s, 1 do
      get following_ids
    end
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
   end
  end


