class Lemma < ActiveRecord::Base
  belongs_to :product

  validates :cn_name, :en_name, :presence => true
end