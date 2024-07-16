# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :memories, dependent: :nullify

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :user_id }

  paginates_per 15

  def self.ransackable_attributes(_auth_object = nil)
    ['id']
  end
end
