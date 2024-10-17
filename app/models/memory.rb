# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :content, presence: true, length: { maximum: 300 }

  paginates_per 20

  def self.ransackable_attributes(_auth_object = nil)
    ['id']
  end

  def valid_category?
    category.nil? || category&.valid?
  end
end
