# frozen_string_literal: true

module ApplicationHelper
  def container_padding_class
    user_signed_in? ? 'pt-14' : 'pt-0'
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
        url: 'http://localhost:3000/'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@2525nicole2525'
      }
    }
  end
end
