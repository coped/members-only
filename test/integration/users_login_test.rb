require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:steve)
  end

  test "rejects non-existing user" do
    post login_path, params: { session: { email: "",
                                          password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select 'span.is-warning'
    assert_nil session[:user_id]
  end

  test "successfully logs existing user in" do
    post login_path, params: { session: {email: @user.email,
                                         password: 'foobar' } }
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_select 'span.is-success'
    assert_equal session[:user_id], @user.id
  end
end
