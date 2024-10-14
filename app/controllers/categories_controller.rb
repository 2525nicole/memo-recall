# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @q = current_user.categories.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.blank?
    @categories = @q.result.page(params[:page])
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash.now.notice = t('notice.create.category')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      flash.now.notice = t('notice.update', model: Category.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:with_memories] == 'true'
      @category.memories.destroy_all
      @category.destroy
      redirect_to memories_path, notice: t('notice.destroy.category_with_memories')
    else
      @category.destroy
      @category_count = current_user.categories.count
      flash.now.notice = t('notice.destroy.category')
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
