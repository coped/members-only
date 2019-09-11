require 'test_helper'

class PostsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:steve)
  end

  test "index as non-member" do
    get root_path
    assert_template 'posts/index'
    Post.includes(:user).all.each do |post|
      user = User.find(post.user_id)
      assert_select "div.author", { text: "By: #{user.name}", count: 0 }
    end
    assert_select 'a[href=?]', login_path, text: "Log in"
  end
  
  test "index as member" do
    post login_path params: { session: { email: @user.email,
                                         password: "foobar" } }
    follow_redirect!
    assert_template 'posts/index'
    Post.includes(:user).all.each do |post|
      user = User.find(post.user_id)
      assert_select "div.author", { text: "By: #{user.name}", count: 1 }
    end
    assert_select 'a[href=?]', new_post_path, text: "Make new post"
    assert_select 'a[href=?]', logout_path, text: "Log out"
  end
end