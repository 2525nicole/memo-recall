# frozen_string_literal: true

module MemoriesHelper
  def set_flash_and_update_page(memory, category)
    if referer_matches_path?(memories_path)
      set_flash_message(:after_create, t('notice.create.memory'))
    else
      set_flash_message(:after_create_with_link, view_context.link_to('思い出を記録しました。（思い出の一覧を見る）', memories_path))
      add_memory_to_page(memory, category)
    end
  end

  def exclude_memory_from_page(memory_category_id, memory)
    category = Category.find(memory_category_id)
    memories_count = category.memories.count

    turbo_streams = [
      turbo_stream.remove(memory),
      turbo_stream.update("memories-count-#{memory_category_id}", partial: 'category_memories/memories-count', locals: { category: category.reload }),
      turbo_stream.update('flash', partial: 'shared/flash')
    ]

    turbo_streams << turbo_stream.update('memories', partial: 'category_memories/no_category_memories_message') if memories_count.zero?

    render turbo_stream: turbo_streams
  end

  private

  def set_flash_message(type, message)
    flash.now[type] = message
  end

  def add_memory_to_page(memory, category)
    turbo_streams = []

    if referer_matches_path?(authenticated_root_path)
      turbo_streams += [
        turbo_stream.replace('first-memory', partial: 'memories/random/memory_with_more_link', locals: { memory: }),
        turbo_stream.remove('no-memories-message')
      ]
    elsif memory.category_id && referer_matches_path?(category_memories_path(memory.category_id))
      turbo_streams += [
        turbo_stream.prepend('memories', partial: 'memory', locals: { memory: }),
        turbo_stream.update("memories-count-#{memory.category_id}", partial: 'category_memories/memories-count', locals: { category: }),
        turbo_stream.remove('no-memories-message')
      ]
    end

    turbo_streams << turbo_stream.update('flash', partial: 'shared/flash')
    render turbo_stream: turbo_streams
  end

  def referer_matches_path?(path)
    request.referer && URI(request.referer).path == path
  end
end
