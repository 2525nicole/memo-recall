# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :set_memory, only: %i[edit update destroy]
  before_action :set_categories, only: %i[new create edit update]
  before_action :initialize_category_errors, only: %i[new create edit update]

  def random
    @memory = current_user.memories.order('RANDOM()').first
  end

  def index
    @q = current_user.memories.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.blank?
    @memories = @q.result.page(params[:page])
  end

  def new
    @memory = Memory.new
  end

  def edit; end

  def create
    @memory = current_user.memories.build(memory_params)

    if params[:memory][:new_category_name].present?
      validate_and_set_category
    elsif params[:memory][:category_id].present?
      set_existing_category
    end

    if @memory.valid? && valid_category?
      @memory.save
      display_appropriate_flash_messages
    else
      set_categories
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:memory][:new_category_name].present?
      validate_and_set_category
    elsif params[:memory][:category_id].present?
      set_existing_category
    end

    @memory.assign_attributes(memory_params)
    @memory.category = @category if @category.present?

    if @memory.valid? && valid_category?
      @memory.save
      flash.now.notice = t('notice.update', model: Memory.model_name.human)
    else
      set_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memory.destroy
    flash.now[:after_destroy] = t('notice.destroy.memory')
  end

  private

  def set_memory
    @memory = current_user.memories.find(params[:id])
  end

  def set_categories
    @categories = current_user.categories.all
  end

  def initialize_category_errors
    @category_errors = []
  end

  def memory_params
    params.require(:memory).permit(:content, :category_id)
  end

  def validate_and_set_category
    @category = current_user.categories.find_or_initialize_by(name: params[:memory][:new_category_name])
    @category.errors.full_messages.each { |msg| @category_errors << msg } unless @category.valid?
    @memory.category = @category
  end

  def set_existing_category
    @memory.category = current_user.categories.find(params[:memory][:category_id])
  end

  def valid_category?
    @memory.category.nil? || @memory.category&.valid?
  end

  def display_appropriate_flash_messages
    if request.referer.include?(memories_path)
      flash.now[:after_create] = t('notice.create.memory')
    else
      flash.now[:after_create_with_link] = view_context.link_to('思い出を記録しました。（思い出の一覧を見る）', memories_path) unless request.referer.include?(memories_path)
    end
  end
end
