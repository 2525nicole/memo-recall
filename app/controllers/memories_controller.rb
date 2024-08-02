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
    @memory = current_user.memories.build(memory_params.except(:new_category_name))
    new_category_created = save_category_of_memory

    if @memory.valid? && valid_category?
      @memory.save
      determine_flash_messages(new_category_created)
    else
      set_categories
      render :new, status: :unprocessable_entity
    end
  end

def update
  old_category_id = @memory.category_id
  @memory.assign_attributes(memory_params.except(:new_category_name))
 save_category_of_memory

  if @memory.valid? && valid_category?
    @memory.save

    if old_category_id && old_category_id != @memory.category_id && request_referer(category_memories_path(old_category_id))
      flash.now.notice = t('notice.update', model: Memory.model_name.human)

      exclude_memory_from_page(old_category_id)
    else
      flash.now.notice = t('notice.update', model: Memory.model_name.human)
    end

  else
    set_categories
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    if @memory.category
      memory_category_id = @memory.category.id
    end

    @memory.destroy
    if @memory.category && request_referer(category_memories_path(memory_category_id))
      flash.now[:after_destroy] = t('notice.destroy.memory')

      exclude_memory_from_page(memory_category_id)
    else
      flash.now[:after_destroy] = t('notice.destroy.memory')
    end
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

  def save_category_of_memory
    new_category_created = false
    if params[:memory][:new_category_name].present?
      @category = current_user.categories.find_or_initialize_by(name: params[:memory][:new_category_name])
      new_category_created = @category.new_record?
      unless @category.save
        @category.errors.full_messages.each { |msg| @category_errors << msg }
      end
    elsif params[:memory][:category_id].present?
      @category = current_user.categories.find(params[:memory][:category_id])
    end
    @memory.category = @category if @category
    new_category_created
  end

  def valid_category?
    @memory.category.nil? || @memory.category&.valid?
  end

  def determine_flash_messages(new_category_created)
    if request_referer(memories_path)
      flash.now[:after_create] = t('notice.create.memory')
    else
      flash.now[:after_create_with_link] = view_context.link_to('思い出を記録しました。（思い出の一覧を見る）', memories_path)
      add_memory_to_page(new_category_created)
    end
  end

  def add_memory_to_page(new_category_created)
    if request_referer(categories_path)
      if new_category_created
        render turbo_stream: [
          turbo_stream.remove('no-categories-message'),
          turbo_stream.prepend('categories', partial: 'categories/category', locals: { category: @category }),
          turbo_stream.update('flash', partial: 'layouts/flash')
        ]
      elsif @memory.category_id
        render turbo_stream: [
          turbo_stream.update("memories-count-#{@memory.category_id}", partial: 'category_memories/memories-count', locals: { category: @category }),
          turbo_stream.update('flash', partial: 'layouts/flash')
        ]
      end
    elsif @memory.category_id && request_referer(category_memories_path(@memory.category_id))
      render turbo_stream: [
        turbo_stream.prepend('memories', partial: 'memory', locals: { memory: @memory }),
        turbo_stream.update("memories-count-#{@memory.category_id}", partial: 'category_memories/memories-count', locals: { category: @category }),
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    else
      render turbo_stream: [
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    end
  end  

  def exclude_memory_from_page(memory_category_id)
    category = Category.find(memory_category_id)
    render turbo_stream: [
      turbo_stream.remove(@memory),
      turbo_stream.update("memories-count-#{memory_category_id}", partial: 'category_memories/memories-count', locals: { category: category.reload }),
      turbo_stream.update('flash', partial: 'layouts/flash')
    ]
  end

  def request_referer(path)
    request.referer && URI(request.referer).path == path
  end
end
