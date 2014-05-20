class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :bubble_down_promotion


  def bubble_down_promotion
    @children = Group.all.where(:parent_id => group.id)
    unless @children.nil? 
      @children.each do |child| 
        unless child.permissions.where(:user_id => user.id, :group_id => child.id, :inherited => [false,nil])
          Permission.create(:user_id => user.id, :group_id => child.id, :inherited => true, :role => @role)
        end
      end
    end
  end

end
