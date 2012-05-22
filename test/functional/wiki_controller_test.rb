require 'test_helper'

class WikiControllerTest < ActionController::TestCase

=begin
  test "should post create" do
    assert_difference('WikiPage.count') do
      post(:create, :wiki_page => {:title => 'test12222', :content => 'content12222'})
    end
    # assert_redirected_to "/wiki/#{assigns(:wiki_page)}"
    # assert_response :success
  end
=end
  test "should page rollback" do
    get(:page_rollback, {:audit_id => 1, :auditable_id => 1})
    ActiveRecord::Base.connection.execute("update audits set user_id = 1")
  end
  
  test "should rollback" do
    get(:rollback, {:audit_id => 2})
    ActiveRecord::Base.connection.execute("update audits set user_id = 1")
  end


end
