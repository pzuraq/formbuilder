class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :bubble_down_promotion


  def bubble_down_promotion
    group.subgroups.each do |subgroup|
      unless subgroup.permissions.where(:user_id => user.id, :group_id => child.id)
        subgroup.permissions.create(:user => user, :role => @role)
      end
    end
  end

end
