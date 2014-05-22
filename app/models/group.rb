class Group < ActiveRecord::Base

	belongs_to :owner, :class_name => 'User'
	belongs_to :parent, :class_name => 'Group'
	has_many :forms, -> { order name: :asc }
	has_many :subgroups, -> { order name: :asc }, foreign_key: :parent_id, :class_name => 'Group'

  has_many :permissions
	has_many :users, through: :permissions

  has_many :moderator_permissions, -> { where role_rank: 0 }, :class_name => 'Permission'
  has_many :moderators, source: :user, through: :moderator_permissions

  has_many :editor_permissions, -> { where role_rank: 1 }, :class_name => 'Permission'
  has_many :editors, source: :user, through: :editor_permissions

	before_create :set_supergroups

	def set_supergroups
		if parent
			group_index = parent.supergroups.max_by{ |k,v| v }.try(:last) || 0

			self.supergroups = parent.supergroups.merge({ "#{parent_id}" => group_index.to_i + 1 })
		else
			self.supergroups = {}
		end
	end
end
