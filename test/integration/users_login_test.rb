require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:yoshihisa)
  end

  test "無効なユーザーIDでログイン" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "有効なユーザーでログイン" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
  end
  
  test "「ログインを保持する」チェック付きログイン" do
    log_in_as(@user, remember_me: '1')
    #assert_not_empty cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test "「ログインを保持する」なしでログイン" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
