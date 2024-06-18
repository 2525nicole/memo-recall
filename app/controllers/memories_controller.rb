# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :set_memory, only: %i[edit update destroy]
  before_action :set_categories, only: %i[new edit]

  def random
    @memory = Memory.order('RANDOM()').first
  end

  def index
    @q = Memory.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.blank?

    @memories = @q.result(distinct: true)
  end

  def new
    @memory = Memory.new
  end

  def edit; end

  def create
    @memory = Memory.new(memory_params)
    @memory.user = current_user
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
    @memory = Memory.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def memory_params
    params.require(:memory).permit(:content, :category_id)
  end
end
