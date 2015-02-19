require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
