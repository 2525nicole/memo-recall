class Category < ApplicationRecord
  belongs_to :user
  has_many :memories, dependent: :nullify
end
