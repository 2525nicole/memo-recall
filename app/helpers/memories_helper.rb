# frozen_string_literal: true

module MemoriesHelper
  def determine_flash_messages(memory, category, new_category_created)
    if request_referer(memories_path)
      flash.now[:after_create] = t('notice.create.memory')
    else
      flash.now[:after_create_with_link] = view_context.link_to('思い出を記録しました。（思い出の一覧を見る）', memories_path)
      add_memory_to_page(memory, category, new_category_created)
    end
  end

  def exclude_memory_from_page(memory_category_id, memory)
    category = Category.find(memory_category_id)
    render turbo_stream: [
      turbo_stream.remove(memory),
      turbo_stream.update("memories-count-#{memory_category_id}", partial: 'category_memories/memories-count', locals: { category: category.reload }),
      turbo_stream.update('flash', partial: 'layouts/flash')
    ]
  end

  private

  def add_memory_to_page(memory, category, new_category_created)
    if request_referer(categories_path)
      render turbo_stream: add_to_category_page(memory, category, new_category_created) + [turbo_stream.update('flash', partial: 'layouts/flash')]
    elsif request_referer(root_path)
      [
        turbo_stream.replace('first-memory', partial: 'memory_with_more_link', locals: { memory: }),
        turbo_stream.remove('no-memories-message'),
        turbo_stream.update('flash', partial: 'layouts/flash')
      ]
    elsif memory.category_id && request_referer(category_memories_path(memory.category_id))
      render turbo_stream: (
        add_to_category_memories_page(memory, category) +
        [
          turbo_stream.remove('no-memories-message'),
          turbo_stream.update('flash', partial: 'layouts/flash')
        ]
      )
    else
      render_flash_message
    end
  end

  def add_to_category_page(memory, category, new_category_created)
    if new_category_created
      [
        turbo_stream.remove('no-categories-message'),
        turbo_stream.prepend('categories', partial: 'categories/category', locals: { category: })
      ]
    elsif memory.category_id
      [
        turbo_stream.update("memories-count-#{memory.category_id}", partial: 'category_memories/memories-count', locals: { category: })
      ]
    else
      []
    end
  end

  def add_to_category_memories_page(memory, category)
    [
      turbo_stream.prepend('memories', partial: 'memory', locals: { memory: }),
      turbo_stream.update("memories-count-#{memory.category_id}", partial: 'category_memories/memories-count', locals: { category: })
    ]
  end

  def render_flash_message
    render turbo_stream: [
      turbo_stream.update('flash', partial: 'layouts/flash')
    ]
  end

  def request_referer(path)
    request.referer && URI(request.referer).path == path
  end
end
