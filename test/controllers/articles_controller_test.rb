require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_index_url
    assert_response :success
  end

  test "should get search" do
    get articles_search_url
    assert_response :success
  end
end
