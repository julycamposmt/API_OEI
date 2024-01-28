require 'test_helper'

class EditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edition = editions(:one)
  end

  test "should get index" do
    get editions_url, as: :json
    assert_response :success
  end

  test "should create edition" do
    assert_difference('Edition.count') do
      post editions_url, params: { edition: { course_id: @edition.course_id, date: @edition.date } }, as: :json
    end

    assert_response 201
  end

  test "should show edition" do
    get edition_url(@edition), as: :json
    assert_response :success
  end

  test "should update edition" do
    patch edition_url(@edition), params: { edition: { course_id: @edition.course_id, date: @edition.date } }, as: :json
    assert_response 200
  end

  test "should destroy edition" do
    assert_difference('Edition.count', -1) do
      delete edition_url(@edition), as: :json
    end

    assert_response 204
  end
end
