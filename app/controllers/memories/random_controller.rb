# frozen_string_literal: true

class Memories::RandomController < ApplicationController
  def show
    @memory = current_user.memories.order('RANDOM()').first
  end
end
