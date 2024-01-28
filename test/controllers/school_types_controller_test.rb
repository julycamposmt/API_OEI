require 'test_helper'

class SchoolTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school_type = school_types(:one)
  end

  test "should get index" do
    get school_types_url, as: :json
    assert_response :success
  end

  test "should create school_type" do
    assert_difference('SchoolType.count') do
      post school_types_url, params: { school_type: { school_id: @school_type.school_id, type_id: @school_type.type_id } }, as: :json
    end

    assert_response 201
  end

  test "should show school_type" do
    get school_type_url(@school_type), as: :json
    assert_response :success
  end

  test "should update school_type" do
    patch school_type_url(@school_type), params: { school_type: { school_id: @school_type.school_id, type_id: @school_type.type_id } }, as: :json
    assert_response 200
  end

  test "should destroy school_type" do
    assert_difference('SchoolType.count', -1) do
      delete school_type_url(@school_type), as: :json
    end

    assert_response 204
  end
end
