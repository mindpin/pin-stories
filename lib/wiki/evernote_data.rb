class EvernoteData

  EVERNOTE_HOST       = "www.evernote.com"
  USER_STORE_URL      = "https://#{EVERNOTE_HOST}/edam/user/"
  NOTE_STORE_URL_BASE = "https://#{EVERNOTE_HOST}/edam/note/"

  def self.get_request_token(callback_url)

    # 这两个全局变量定义在 application.rb 里

    consumer_key    = $EVERNOTE_CONSUMER_KEY
    consumer_secret = $EVERNOTE_CONSUMER_SECRET

    raise '你需要在代码里声明 CONSUMER_KEY 和 CONSUMER_SECRET' if consumer_key.blank? || consumer_key.blank?

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
      :site               => 'https://www.evernote.com',
      :request_token_path => '/oauth',
      :access_token_path  => '/oauth',
      :authorize_path     => '/OAuth.action'
    })

    consumer.get_request_token(:oauth_callback => callback_url)
  end

  def self.get_note_store(access_token)
    edam_shard = access_token.params[:edam_shard]

    note_store_url = NOTE_STORE_URL_BASE + edam_shard

    note_store_transport = Thrift::HTTPClientTransport.new(note_store_url)
    note_store_protocol = Thrift::BinaryProtocol.new(note_store_transport)
    note_store = Evernote::EDAM::NoteStore::NoteStore::Client.new(note_store_protocol)
  end

  def self.get_notebooks_of(user)
    access_token = user.get_evernote_access_token
    return self.get_note_store(access_token).listNotebooks(access_token.token)
  end

  def self.get_tags_of(user)
    access_token = user.get_evernote_access_token
    return self.get_note_store(access_token).listTags(access_token.token)
  end

  # 判断是否已经在指定product下有相同title的wiki_page
  def self.has_title_existed?(product_id, title)
    WikiPage.where(:product_id => product_id, :title => title).exists?
  end

  # 根据传入的条件查找指定的笔记条目
  # 如果 notebook_guids, tag_guids 传入值为 'all' 则不去做对应的过滤
  # 否则，按数组内guid过滤
  def self.get_selected_notes(user, notebook_guids, tag_guids)
    access_token = user.get_evernote_access_token
    note_store = self.get_note_store(access_token)

    if 'all' == notebook_guids
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      filter.tagGuids = tag_guids if 'all' != tag_guids

      note_list = note_store.findNotes access_token.token, filter, 0, 1000

      return note_list.notes
    else
      notes = []

      notebook_guids.each do |notebook_guid|
        filter = Evernote::EDAM::NoteStore::NoteFilter.new
        filter.tagGuids = tag_guids if 'all' != tag_guids
        filter.notebookGuid = notebook_guid

        note_list = note_store.findNotes access_token.token, filter, 0, 1000

        notes = notes + note_list.notes
      end

      return notes
    end
  end

  def self.get_note_content_by_guid(user, guid)
    access_token = user.get_evernote_access_token
    return self.get_note_store(access_token).getNoteContent access_token.token, guid
  end

  # def self.get_confirmed_notebooks(user, product, notebook_guids, tag_guids)

    
  #   confirmed_notebooks = []
    
  #   notebooks.each do |notebook|
  #     if notebook_names.include?(notebook.name)
  #       filter = Evernote::EDAM::NoteStore::NoteFilter.new
  #       filter.notebookGuid = notebook.guid
  #       limit  = 1000
  #       offset = 0
  #       note_list = note_store.findNotes access_token.token, filter, offset, limit 

  #       note_list.notes.each do |note|
  #         content = note_store.getNoteContent access_token.token, note.guid

  #         if tag_names.nil?
  #           confirmed_notebook_row = Hash.new
  #           confirmed_notebook_row[:creator] = user
  #           confirmed_notebook_row[:product] = product
  #           confirmed_notebook_row[:title] = note.title
  #           confirmed_notebook_row[:content] = content

  #           confirmed_notebooks << confirmed_notebook_row
  #         else
  #           node_tags = note_store.getNoteTagNames access_token.token, note.guid
            
  #           if node_tags.length > 0
              
  #             node_tags.each do |node_tag|
  #               if tag_names.include?(node_tag)
  #                 confirmed_notebook_row = Hash.new
  #                 confirmed_notebook_row[:creator] = user
  #                 confirmed_notebook_row[:product] = product
  #                 confirmed_notebook_row[:title] = note.title
  #                 confirmed_notebook_row[:content] = content

  #                 confirmed_notebooks << confirmed_notebook_row
  #               end
  #             end

  #           # end of tag_names.nil
  #           end
  #         # end of note_list.notes.each
  #         end
  #       # end of notebook_names.include?
  #       end
  #     # end of notebooks each
  #     end
  #   end
  #   confirmed_notebooks
  # end

end