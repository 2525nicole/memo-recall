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
    if params[:new_category_name].present?
      category = user.categories.find_or_initialize_by(name: params[:new_category_name])
      category.valid?
    elsif params[:category_id].present?
      category = user.categories.find(params[:category_id])
    end
    self.category = category if category
    category
  end
end
