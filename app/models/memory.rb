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

  def assign_category(params, user)
    new_category_created = false
    category_errors = []

    if params[:new_category_name].present?
      category = user.categories.find_or_initialize_by(name: params[:new_category_name])
      new_category_created = category.new_record?

      unless category.valid?
        category.errors.full_messages.each do |message|
          category_errors << message
        end
      end
    elsif params[:category_id].present?
      category = user.categories.find(params[:category_id])
    end

    self.category = category if category
    [new_category_created, category, category_errors]
  end
end
