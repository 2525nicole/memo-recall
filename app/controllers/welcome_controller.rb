# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def pp; end

  def tos; end

  def help; end

end
