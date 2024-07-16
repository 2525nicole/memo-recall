# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :content, presence: true, length: { maximum: 400 }

  paginates_per 15

  def self.ransackable_attributes(_auth_object = nil)
    ['id']
  end
end
