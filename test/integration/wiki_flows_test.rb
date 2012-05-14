require 'test_helper'

class WikiFlowsTest < ActionDispatch::IntegrationTest
  
  fixtures :users

  test "whole_wiki" do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE wiki_pages")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE audits")
    
    get "/"
    assert_response :success
 
    post_via_redirect "/", :username => users(:linux).name, :password => users(:linux).password
    assert_equal '/', path
 
    assert_difference('WikiPage.count') do
      wiki_page = WikiPage.new
      wiki_page.creator_id = 1
      wiki_page.title = 'title1'
      wiki_page.content = 'content1'
      wiki_page.save
    end
    
    assert_difference('WikiPage.count') do
      wiki_page = WikiPage.new
      wiki_page.creator_id = 1
      wiki_page.title = 'title2'
      wiki_page.content = 'content2'
      wiki_page.save
    end
    
    
    wiki_page = WikiPage.find(1)
    wiki_page.creator_id = 1
    wiki_page.title = 'title11'
    wiki_page.content = 'content11'
    wiki_page.save
    
    wiki_page = WikiPage.find(2)
    wiki_page.creator_id = 1
    wiki_page.title = 'title22'
    wiki_page.content = 'content22'
    wiki_page.save
    
    wiki_page = WikiPage.find(1)
    wiki_page.destroy
    
    ActiveRecord::Base.connection.execute("update audits set user_id = 1")
    
    # assert_redirected_to "/wiki/#{assigns(:wiki_page)}"
    # assert_response :success
  end
  
  
end
