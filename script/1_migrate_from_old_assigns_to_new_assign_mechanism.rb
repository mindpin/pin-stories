# -*- coding: utf-8 -*-
class IssueAssign < ActiveRecord::Base; end
class StoryAssign < ActiveRecord::Base; end
class MilestoneIssueAssign < ActiveRecord::Base; end

ActiveRecord::Base.transaction do
  [IssueAssign, StoryAssign, MilestoneIssueAssign].each do |old_model|

    if ActiveRecord::Base.connection.tables.include?(old_model.to_s.tableize)
      puts ">>>>>>>> 开始迁移#{old_model.to_s}到Assign"

      assignable_name = old_model.to_s.sub('Assign', '').underscore

      old_model.all.each do |old_assign|
        assign = UserAssign.create(:model_id   => old_assign.send("#{assignable_name}_id"),
                                   :model_type => assignable_name.classify,
                                   :user_id    => old_assign.user_id,
                                   :created_at => old_assign.created_at,
                                   :updated_at => old_assign.updated_at)

        raise UserAssign.errors.message.to_json if assign.errors.messages.any?
      end

      puts ">>>>>>>> 迁移完毕, 共#{old_model.count}行数据"
    end

  end

end
