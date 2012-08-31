class IssueAssign < ActiveRecord::Base; end
class StoryAssign < ActiveRecord::Base; end

class CreatePolymorphicAssign < ActiveRecord::Migration
  def change
    create_table :assigns do |t|
      t.integer :model_id
      t.string  :model_type
      t.integer :user_id
      t.timestamps
    end

    [IssueAssign, StoryAssign].each do |old_model|
      say_with_time "Migrating #{old_model.to_s} to Assign" do
        assignable_name = old_model.to_s.sub('Assign', '').downcase

        old_model.all.each do |old_assign|
          Assign.create :model_id   => old_assign.send("#{assignable_name}_id"),
                        :model_type => assignable_name.capitalize,
                        :user_id    => old_assign.user_id,
                        :created_at => old_assign.created_at,
                        :updated_at => old_assign.updated_at
        end

        old_model.count
      end

    end

  end

end
