class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def roles
    [ :moderator, :editor, :viewer ]
  end

  def role
    roles(role_rank)
  end

  def role=(val)
    role_rank = roles.find_index(val)
  end

  after_save :override_lower_roles

  def override_lower_roles
    # Delete all permissions that are lower on the tree AND where role < the role
    # of the current node.
    Permission.where(
      user:  user,
      group: Group.select(:id).where("supergroups ? ':id'", { id: group.id })
    ).where("role_rank >= ':rank'", { rank: role_rank }).destroy_all
  end
end
