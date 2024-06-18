# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :memories, dependent: :nullify

  validates :name, presence: true, length: { maximum: 24 }, uniqueness: { scope: :user_id }

  def self.ransackable_attributes(_auth_object = nil)
    ['created_at']
  end
end
