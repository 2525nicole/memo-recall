# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :set_memory, only: %i[edit update destroy]
  before_action :set_categories, only: %i[new edit]

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
    if @memory.save
      redirect_to memories_path, notice: t('notice.create.memory')
    else
      set_categories
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @memory.update(memory_params)
      redirect_to memories_path, notice: t('notice.update', model: Memory.model_name.human)
    else
      set_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memory.destroy
    redirect_to memories_path, notice: t('notice.destroy.memory')
  end

  private

  def set_memory
    @memory = current_user.memories.find(params[:id])
  end

  def set_categories
    @categories = current_user.categories.all
  end

  def memory_params
    params.require(:memory).permit(:content, :category_id)
  end
end
