class EvernoteData
  def self.request_token(consumer_key, consumer_secret, callback_url)

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
        :site => 'https://sandbox.evernote.com/',
        :request_token_path => "/oauth",
        :access_token_path => "/oauth",
        :authorize_path => "/OAuth.action"})


    consumer.get_request_token(:oauth_callback => callback_url)
  end

  def self.import(current_user, product_id, access_token, shard, notebook_name)
 
	  evernoteHost = "sandbox.evernote.com"
	  userStoreUrl = "https://#{evernoteHost}/edam/user"
	  noteStoreUrlBase = "https://#{evernoteHost}/edam/note/"

	  # noteStoreUrl = noteStoreUrlBase + access_token.params[:edam_shard]
	  noteStoreUrl = noteStoreUrlBase + shard

	  noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
	  noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
	  noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

	  notebooks = noteStore.listNotebooks(access_token.token)

	  notebooks.each do |notebook|
	  	p 222222222222222222222222222222222222222222222222
	  	p notebook
	  	p notebook.name
	  	p notebook_name
	  	p 111111111111111111111111111111111111111111111111
	  	if notebook.name == notebook_name
		    filter = Evernote::EDAM::NoteStore::NoteFilter.new
		    filter.notebookGuid = notebook.guid
		    limit = 1000
		    offset  =0
		    note_list = noteStore.findNotes access_token.token, filter, offset, limit 

		    note_list.notes.each do |note|
		    	content = noteStore.getNoteContent access_token.token, note.guid

		      WikiPage.create(
		        :creator_id => current_user.id, 
		        :product_id => product_id, 
		        :title => note.title,
		        :content => content
		      )
		    end
		  end

	  end

  end


end