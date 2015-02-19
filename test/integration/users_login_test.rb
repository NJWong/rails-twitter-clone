require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:nick)
  end
  
  test "login with invalid information" do
    # visit the login path
    get login_path
    # verify that the new sessions for renders properly
    assert_template 'sessions/new'
    # post to the sessions path with an invalid params hash
    post login_path, session: { email: "", password: "" }
    # verify that the new sessions form get re-rendered and that a flash message appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    # visit another page (such as the home page)
    get root_path
    # verify that the flash message doesn't appear on the new page
    assert flash.empty?  
  end
  
  test "login with valid information followed by logout" do
    # visit the login path
    get login_path
    # post valid information to the sessions path
    post login_path, session: { email: @user.email, password: 'password' }
    # verify that the user is logged in
    assert is_logged_in?
    # verify we are redirected to the right target
    assert_redirected_to @user
    # visit the target page and verify the page renders correctly
    follow_redirect!
    assert_template 'users/show'
    # verify that the login link disappears
    assert_select "a[href=?]", login_path, count: 0
    # verify that a logout link appears
    assert_select "a[href=?]", logout_path
    # verify that a profile link appears
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end
  
  test 'login without remembering' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
