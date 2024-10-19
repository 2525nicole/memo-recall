# frozen_string_literal: true

module ApplicationHelper
  def container_padding_class
    if current_page?(tos_path) || current_page?(pp_path)
      'pt-10'
    elsif user_signed_in?
      'pt-14'
    else
      'pt-0'
    end
  end

  def default_meta_tags
    {
      site: 'Memo Recall',
      reverse: true,
      charset: 'utf-8',
      description: 'Memo Recallは、いつまでも覚えておきたい大事な思い出をいつでも簡単に記録できるサービスです。',
      keywords: '思い出, 記録',
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        type: 'website',
        description: :description,
        image: image_url('ogp.png'),
        url: 'https://memo-recall.fly.dev/'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@2525nicole2525'
      }
    }
  end

  def count_character(id, max_length)
    content_tag(:span, "現在 0/#{max_length} 文字入力しています", data: { 'character-counter-target': 'counter', 'counter-for': id })
  end
end
