require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	def setup
		#this setup actually takes from the users.yml (fixture) hence lowercased 'users'
		@user = users(:michael)
	end

	test "failed login attempt" do
		get login_path
		assert_template 'sessions/new'
		post login_path, session: {email: "failed@failed", password: "foo"}
		assert_template 'sessions/new'
		assert_not flash.empty?
		get root_path
		assert flash.empty?
	end

	test "login with valid information follow by logout" do
		get login_path
		#password isn't actually a valid parameter of the user, because in the table it 
		#holds as 'password_digest', hence instead we use a default password for testing
		post login_path, session: {email:  @user.email, password: 'password'}
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", user_path(@user)
		assert_select "a[href=?]", logout_path

		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_path
#second logout test
		delete logout_path
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", user_path(@user), count: 0
		assert_select "a[href=?]", logout_path, count: 0
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_nil cookies['remember_token']
	end

	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_token']
	end
end
