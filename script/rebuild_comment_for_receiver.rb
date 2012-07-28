Story.all.each do |story|
  story.creator_id = 1
  story.save
end

Comment.all.each do |comment|
  begin
    if comment.receiver.blank?
      comment.set_receiver_on_create
      comment.save
    end
  rescue Exception => ex
    p "comment #{comment.id} 添加 receiver 出错"
  end
end