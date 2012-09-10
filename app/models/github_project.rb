class GithubProject < ActiveRecord::Base
  belongs_to :product
  has_many :stories

  validates :product, :url, :presence => true
end
