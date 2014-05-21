class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :bubble_down_promotion
  before_destroy :bubble_down_demotion

  
  def bubble_down_promotion
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Working, but needs hstore logic now
    role_value = { :moderator => 3, :editor => 2, :viewer => 1 }
    @parent_group_permission = group.permissions.where(:user => user).first
    @parent_group_role = @parent_group_permission.role
    group.subgroups.each do |subgroup| 
      @permission = subgroup.permissions.where(:user => user)
      @current_group_permission = @permission.first
      if @current_group_permission.nil?
        subgroup.permissions.create(:user=> user, :role => @parent_group_role)
      else
        @current_group_role = @current_group_permission.role
        unless role_value[@current_group_role.to_sym] > role_value[@parent_group_role.to_sym]
          @permission.destroy_all
          subgroup.permissions.create(:user=> user, :role => @parent_group_role)
        end
<<<<<<< HEAD
=======
    group.subgroups.each do |subgroup|
      unless subgroup.permissions.where(:user_id => user.id, :group_id => child.id)
        subgroup.permissions.create(:user => user, :role => @role)
>>>>>>> commit
=======
>>>>>>> Working, but needs hstore logic now
      end
    end
  end

<<<<<<< HEAD


=======
>>>>>>> Working, but needs hstore logic now
  def bubble_down_demotion
    role_value = { :moderator => 3, :editor => 2, :viewer => 1 }
    @parent_group_permission = group.permissions.where(:user => user).first
    @parent_group_role = @parent_group_permission.role.to_sym
    group.subgroups.each do |subgroup| 
      @permission = subgroup.permissions.where(:user => user)
      @current_group_permission = @permission.first
      next if @current_group_permission.nil?
      @current_group_role       = @current_group_permission.role.to_sym
      unless role_value[@current_group_role] > role_value[@parent_group_role]
        @permission.destroy_all 
      end
    end
  end
end

