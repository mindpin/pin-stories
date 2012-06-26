class EvernoteData

  EVERNOTE_HOST       = "sandbox.evernote.com"
  USER_STORE_URL      = "https://#{EVERNOTE_HOST}/edam/user/"
  NOTE_STORE_URL_BASE = "https://#{EVERNOTE_HOST}/edam/note/"

  def self.get_request_token(callback_url)

    # 这两个全局变量定义在 application.rb 里

    consumer_key    = $EVERNOTE_CONSUMER_KEY
    consumer_secret = $EVERNOTE_CONSUMER_SECRET

    raise '你需要在代码里声明 CONSUMER_KEY 和 CONSUMER_SECRET' if consumer_key.blank? || consumer_key.blank?

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
      :site               => 'https://sandbox.evernote.com',
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

  def self.has_title_existed?(product_id, title)
    WikiPage.where(:product_id => product_id, :title => title).exists?
  end

  def self.get_confirmed_notebooks(user, product, notebook_names, tag_names)
    access_token = user.get_evernote_access_token
    note_store = get_note_store(access_token)

    notebooks = self.get_notebooks_of(user)
    
    confirmed_notebooks = []
    
    notebooks.each do |notebook|
      if notebook_names.include?(notebook.name)
        filter = Evernote::EDAM::NoteStore::NoteFilter.new
        filter.notebookGuid = notebook.guid
        limit  = 1000
        offset = 0
        note_list = note_store.findNotes access_token.token, filter, offset, limit 

        note_list.notes.each do |note|
          content = note_store.getNoteContent access_token.token, note.guid

          if tag_names.nil?
            confirmed_notebook_row = Hash.new
            confirmed_notebook_row[:creator] = user
            confirmed_notebook_row[:product] = product
            confirmed_notebook_row[:title] = note.title
            confirmed_notebook_row[:content] = content

            confirmed_notebooks << confirmed_notebook_row
          else
            node_tags = note_store.getNoteTagNames access_token.token, note.guid
            
            if node_tags.length > 0
              
              node_tags.each do |node_tag|
                if tag_names.include?(node_tag)
                  confirmed_notebook_row = Hash.new
                  confirmed_notebook_row[:creator] = user
                  confirmed_notebook_row[:product] = product
                  confirmed_notebook_row[:title] = note.title
                  confirmed_notebook_row[:content] = content

                  confirmed_notebooks << confirmed_notebook_row
                end
              end

            # end of tag_names.nil
            end
          
          # end of note_list.notes.each
          end

        # end of notebook_names.include?
        end

      # end of notebooks each
      end

    end

    confirmed_notebooks

  end

  



  def self.import(user, product, notebook_names, tag_names)
    access_token = user.get_evernote_access_token
    note_store = get_note_store(access_token)

    notebooks = self.get_notebooks_of(user)

    notebooks.each do |notebook|
      if notebook_names.include?(notebook.name)
        filter = Evernote::EDAM::NoteStore::NoteFilter.new
        filter.notebookGuid = notebook.guid
        limit  = 1000
        offset = 0
        note_list = note_store.findNotes access_token.token, filter, offset, limit 

        note_list.notes.each do |note|
          content = note_store.getNoteContent access_token.token, note.guid

          if tag_names.nil?
            p 555555555555555555555555555555555555555555555555555555555555555555555555
            WikiPage.create(
              :creator => user, 
              :product => product, 
              :title => note.title,
              :content => content
            )
          else
            p 66666666666666666666666666666666666666666666666666666666
            p tag_names

            node_tags = note_store.getNoteTagNames access_token.token, note.guid
            p node_tags
            p 77777777777777777777777777777777777777777777777777777777777777777
            
            if node_tags.length > 0
              
              node_tags.each do |node_tag|
                p 888888888888888888888888888888888888888888888888
                if tag_names.include?(node_tag)
                  p 999999999999999999999999999999999999999999999999999999
                  WikiPage.create(
                    :creator => user, 
                    :product => product, 
                    :title => note.title,
                    :content => content
                  )
                end
              end

            end
            
          end

          
        end
      end

    end

  end


end