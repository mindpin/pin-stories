# -*- coding: utf-8 -*-
class MilestoneIssue < ActiveRecord::Base
  belongs_to :usecase
end
Issue.record_timestamps = false

ActiveRecord::Base.transaction do
  milestone_issues = MilestoneIssue.all
  count = milestone_issues.count

  milestone_issues.each_with_index do |milestone_issue, index|
    p "正在处理 #{index+1}/count"
    
    next if milestone_issue.usecase.blank?

    Issue.create(
      :creator_id          => milestone_issue.creator_id,
      :usecase_id          => milestone_issue.usecase_id,
      :milestone_report_id => milestone_issue.check_report_id,
      :product_id          => milestone_issue.usecase.product,
      :content             => milestone_issue.content,
      :state               => milestone_issue.state,
      :created_at          => milestone_issue.created_at,
      :updated_at          => milestone_issue.updated_at
    )

  end
  p "SUCCESS!!!"
end