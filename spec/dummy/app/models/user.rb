class User < ActiveRecord::Base
  has_many :articles, inverse_of: :user
  has_many :comments, inverse_of: :user

  has_cache
end
