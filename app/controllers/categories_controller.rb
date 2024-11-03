# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @query = current_user.categories.ransack(params[:q])
    @query.sorts = 'id desc' if @query.sorts.blank?
    @categories = @query.result.page(params[:page])
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      set_flash_message(:notice, t('notice.create.category'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      set_flash_message(:notice, t('notice.update', model: Category.model_name.human))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if destroy_with_memories?
      ActiveRecord::Base.transaction do
        @category.memories.each(&:destroy!)
        @category.destroy!
      end
      redirect_to memories_path, notice: t('notice.destroy.category_with_memories') and return
    else
      @category.destroy!
      @category_count = current_user.categories.count
      set_flash_message(:notice, t('notice.destroy.category'))
    end
  rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Rollback
    flash.now[:alert] = t('notice.destroy_failed')
    response.set_header('Turbo-Frame', '_top')
    # 対象の Category または Category と Memories を表示したままにしておくため、update テンプレートを使用する
    render :update, status: :unprocessable_entity
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def destroy_with_memories?
    params[:with_memories] == 'true'
  end

  def set_flash_message(type, message)
    flash.now[type] = message
  end
end
