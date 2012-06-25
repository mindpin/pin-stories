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


  # 这里我改了一些变量名，逻辑是不是还对，我没有进一步测试
  # songliang 2012-06-25
  def self.import(user, product, notebook_name, tag_names)
    tag_names = tag_names.gsub(/\s+/, " ").split(/, /)

    notebooks = self.get_notebooks_of(user)

    notebooks.each do |notebook|
      if (notebook.name == notebook_name) || notebook_name.blank?
        filter = Evernote::EDAM::NoteStore::NoteFilter.new
        filter.notebookGuid = notebook.guid
        limit  = 1000
        offset = 0
        note_list = noteStore.findNotes access_token.token, filter, offset, limit 

        note_list.notes.each do |note|
          content = noteStore.getNoteContent access_token.token, note.guid

          unless tag_names.length > 0
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

            node_tags = noteStore.getNoteTagNames access_token.token, note.guid
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