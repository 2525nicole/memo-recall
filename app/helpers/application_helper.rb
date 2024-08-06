# frozen_string_literal: true

module ApplicationHelper
  def container_padding_class
    user_signed_in? ? 'pt-14' : 'pt-0'
  end
end
