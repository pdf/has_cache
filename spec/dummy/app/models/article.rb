class Article < ActiveRecord::Base
  belongs_to :user, inverse_of: :articles
  has_many :comments, inverse_of: :article

  has_cache
end
