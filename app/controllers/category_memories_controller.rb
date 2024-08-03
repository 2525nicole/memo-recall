# frozen_string_literal: true

class CategoryMemoriesController < ApplicationController
  before_action :set_category

  def index
    @q = @category.memories.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.blank?
    @memories = @q.result.page(params[:page]).per(20)
  end

  private

  def set_category
    @category = current_user.categories.find(params[:category_id])
  end
end
