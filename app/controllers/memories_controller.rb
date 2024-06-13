# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :set_memory, only: %i[edit update destroy]

  def random
    @memory = Memory.order("RANDOM()").first
  end

  def index
    @memories = Memory.all
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
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @memory.update(memory_params)
      redirect_to memories_path, notice: t('notice.update', model: memory)
    else
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

  def memory_params
    params.require(:memory).permit(:name, :user_id, :category_id)
  end
end
