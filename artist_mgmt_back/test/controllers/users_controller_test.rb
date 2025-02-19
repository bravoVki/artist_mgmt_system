require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { address: @user.address, dob: @user.dob, email: @user.email, first_name: @user.first_name, gender: @user.gender, last_name: @user.last_name, password_digest: @user.password_digest, phone: @user.phone } }, as: :json
    end

    assert_response :created
  end

  test "should show user" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { address: @user.address, dob: @user.dob, email: @user.email, first_name: @user.first_name, gender: @user.gender, last_name: @user.last_name, password_digest: @user.password_digest, phone: @user.phone } }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
