# frozen_string_literal: true

class MemoriesController < ApplicationController
  include MemoriesHelper

  before_action :set_memory, only: %i[edit update destroy]
  before_action :set_categories, only: %i[new create edit update]
  before_action :initialize_category_errors, only: %i[new create edit update]

  def index
    @query = current_user.memories.ransack(params[:q])
    @query.sorts = 'id desc' if @query.sorts.blank?
    @memories = @query.result.page(params[:page])
  end

  def new
    @memory = Memory.new
  end

  def edit; end

  def create
    success = false

    ActiveRecord::Base.transaction do
      @memory = current_user.memories.build(memory_params.except(:new_category_name))

      @category, @category_errors = @memory.assign_category(memory_params, current_user)

      raise ActiveRecord::Rollback unless @memory.valid? && @memory.valid_category?

      @memory.save!
      set_flash_and_update_page(@memory, @category)
      success = true
    end

    return if success

    set_categories
    render :new, status: :unprocessable_entity
  end

  def update
    old_category_id = @memory.category_id
    success = false

    ActiveRecord::Base.transaction do
      @memory.assign_attributes(memory_params.except(:new_category_name))

      @category, @category_errors = @memory.assign_category(memory_params, current_user)

      raise ActiveRecord::Rollback unless @memory.valid? && @memory.valid_category?

      @memory.save!
      handle_update_flash_and_render(old_category_id)

      success = true
    end

    return if success

    set_categories
    render :edit, status: :unprocessable_entity
  end

  def destroy
    memory_category_id = @memory.category&.id

    @memory.destroy
    @memories_count = current_user.memories.count
    flash.now[:after_destroy] = t('notice.destroy.memory')

    return unless memory_category_id && referer_matches_path?(category_memories_path(memory_category_id))

    exclude_memory_from_page(memory_category_id, @memory)
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
    params.require(:memory).permit(:content, :category_id, :new_category_name)
  end

  def handle_update_flash_and_render(old_category_id)
    flash.now.notice = t('notice.update', model: Memory.model_name.human)
    return unless old_category_id && old_category_id != @memory.category_id && referer_matches_path?(category_memories_path(old_category_id))

    exclude_memory_from_page(old_category_id, @memory)
  end
end
