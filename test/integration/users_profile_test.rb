require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other = users(:mallory)
    @other1 = users(:archer)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    assert_difference '@user.following_ids.count', 1 do
       @user.follow(@other1)
    end
    assert_difference '@user.followers.count', 1 do
      @other.follow(@user)
    end
    get user_path(@user)
    assert_match /2strongfollowing/, response.body.tr("\n", '').tr('</\ ">','')
    assert_match /3strongfollowers/, response.body.tr("\n", '').tr('</\ ">','')
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
   end
  end


