class EvernoteData
  def self.request_token(consumer_key, consumer_secret, callback_url)

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
        :site => 'https://sandbox.evernote.com/',
        :request_token_path => "/oauth",
        :access_token_path => "/oauth",
        :authorize_path => "/OAuth.action"})


    consumer.get_request_token(:oauth_callback => callback_url)
  end

  def self.import(current_user, product_id, access_token, shard, notebook_name, tag_names)
  	tag_names = tag_names.gsub(/\s+/, " ").split(/, /)
 
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

	  	if (notebook.name == notebook_name) || notebook_name.blank?
		    filter = Evernote::EDAM::NoteStore::NoteFilter.new
		    filter.notebookGuid = notebook.guid
		    limit = 1000
		    offset  =0
		    note_list = noteStore.findNotes access_token.token, filter, offset, limit 

		    note_list.notes.each do |note|
		    	content = noteStore.getNoteContent access_token.token, note.guid

		    	unless tag_names.length > 0
		    		p 555555555555555555555555555555555555555555555555555555555555555555555555
		    		WikiPage.create(
			        :creator_id => current_user.id, 
			        :product_id => product_id, 
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
		  end

	  end

  end


end