# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :content, presence: true

  paginates_per 10

  def self.ransackable_attributes(_auth_object = nil)
    ['id']
  end
end
