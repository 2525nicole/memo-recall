class CategoryMemoriesController < ApplicationController
  before_action :set_category

  def index
    @memories = @category.memories
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end
end
