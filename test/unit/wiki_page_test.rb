require 'test_helper'

class WikiPageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  fixtures :wiki_pages

  test "save_wiki_page" do
    post = WikiPage.new
    assert !post.save
  end
end
