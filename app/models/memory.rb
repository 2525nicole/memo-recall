# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :content, presence: true, length: { maximum: 300 }
  validate :validate_associated_category

  before_validation :assign_category

  attr_accessor :new_category_name

  paginates_per 20

  def self.ransackable_attributes(_auth_object = nil)
    ['id']
  end

  def assign_category
    return if new_category_name.blank?

    self.category = user.categories.find_or_initialize_by(name: new_category_name)
  end

  def validate_associated_category
    return if category.nil? || category.valid?

    category.errors.full_messages.each do |message|
      errors.add(:base, message)
    end
  end
end
