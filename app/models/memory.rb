# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :content, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    ['created_at']
  end
end
