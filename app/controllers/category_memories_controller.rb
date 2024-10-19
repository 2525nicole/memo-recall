# frozen_string_literal: true

class CategoryMemoriesController < ApplicationController
  before_action :set_category

  def index
    @query = @category.memories.ransack(params[:q])
    @query.sorts = 'id desc' if @query.sorts.blank?
    @memories = @query.result.page(params[:page]).per(20)
  end

  private

  def set_category
    @category = current_user.categories.find(params[:category_id])
  end
end
