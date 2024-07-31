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
    memory_attributes = memory_params.except(:new_category_name)
    @memory = current_user.memories.build(memory_attributes)
    new_category_created = false

    if params[:memory][:new_category_name].present?
      new_category_created = validate_and_set_category
    elsif params[:memory][:category_id].present?
      set_existing_category
    end

    if @memory.valid? && valid_category?
      @memory.save
      @category = @memory.category
      display_appropriate_flash_messages(new_category_created)
    else
      set_categories
      render :new, status: :unprocessable_entity
    end
  end

  def update
    old_category_id = @memory.category_id
    if params[:memory][:new_category_name].present?
      validate_and_set_category
    elsif params[:memory][:category_id].present?
      set_existing_category
    end

    @memory.assign_attributes(memory_params.except(:new_category_name))
    @memory.category = @category if @category.present?

    if @memory.valid? && valid_category?
      @memory.save

      if old_category_id && old_category_id != @memory.category_id && request.referer.include?(category_memories_path(old_category_id))
        flash.now.notice = t('notice.update', model: Memory.model_name.human)

        render_update_response(old_category_id)
      else
        flash.now.notice = t('notice.update', model: Memory.model_name.human)
      end

    else
      set_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    memory_category_id = @memory.category.id
    @memory.destroy
    if request.referer.include?(category_memories_path(memory_category_id))
      flash.now[:after_destroy] = t('notice.destroy.memory')

      render_destroy_response(memory_category_id)
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

  def validate_and_set_category
    @category = current_user.categories.find_or_initialize_by(name: params[:memory][:new_category_name])
    is_new_record = @category.new_record?
    if @category.save
      @memory.category = @category
    else
      @category.errors.full_messages.each { |msg| @category_errors << msg }
    end
    is_new_record
  end

  def set_existing_category
    @memory.category = current_user.categories.find(params[:memory][:category_id])
  end

  def valid_category?
    @memory.category.nil? || @memory.category&.valid?
  end

  def display_appropriate_flash_messages(new_category_created)
    if request.referer.include?(categories_path)
      flash.now[:after_create_with_link] = view_context.link_to('思い出を記録しました。（思い出の一覧を見る）', memories_path)
      render_create_response(new_category_created)
    else
      flash.now[:after_create] = t('notice.create.memory')
    end
  end

  def render_create_response(new_category_created) # 思い出一覧ページ以外にいる時のレンダー処理
    if new_category_created # 新しいカテゴリーが登録された時、カテゴリー一覧ページに追加される
      render turbo_stream: [
        turbo_stream.remove('no-categories-message'), # 思い出経由で1つ目のカテゴリーが登録された時の書き方確認する
        turbo_stream.prepend('categories', partial: 'categories/category', locals: { category: @category }),
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    elsif @memory.category_id.nil? # カテゴリーの紐付けがない思い出はflashだけが表示される
      render turbo_stream: [
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    elsif request.referer.include?(category_memories_path(@memory.category_id)) # 紐づけたカテゴリーの、カテゴリー別思い出一覧ページにいる時
      render turbo_stream: [
        turbo_stream.prepend("memories-page-#{@memory.category_id}", partial: 'memory', locals: { memory: @memory }),
        turbo_stream.update("memories-count-#{@memory.category_id}", partial: 'category_memories/memories-count', locals: { category: @category }),
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    else # その他
      render turbo_stream: [
        turbo_stream.update("memories-count-#{@memory.category_id}", partial: 'category_memories/memories-count', locals: { category: @category }),
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    end
  end

  def render_update_response(old_category_id)
    old_category = Category.find(old_category_id)
    render turbo_stream: [
      turbo_stream.remove(@memory), # OK
      turbo_stream.update("memories-count-#{old_category_id}", partial: 'category_memories/memories-count', locals: { category: old_category.reload }),
      turbo_stream.update('flash', partial: 'layouts/flash')
    ]
  end

  def render_destroy_response(memory_category_id)
    category = Category.find(memory_category_id)
    render turbo_stream: [
      turbo_stream.remove(@memory),
      turbo_stream.update("memories-count-#{memory_category_id}", partial: 'category_memories/memories-count', locals: { category: category.reload }),
      turbo_stream.update('flash', partial: 'layouts/flash')
    ]
  end
end
