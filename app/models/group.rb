class Group < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
	belongs_to :parent, :class_name => 'Group'
	has_many :forms, -> { order name: :asc }
	has_many :subgroups, -> { order name: :asc }, foreign_key: :parent_id, :class_name => 'Group'
  has_many :permissions
	has_many :users, through: :permissions
  has_many :moderator_permissions, -> { where role: 'moderator' }, :class_name => 'Permission'
  has_many :moderators, source: :user, through: :moderator_permissions
  has_many :editor_permissions, -> { where role: 'editor' }, :class_name => 'Permission'
  has_many :editors, source: :user, through: :editor_permissions


  after_create :create_permission

  def create_permission
    Permission.create(user: self.owner, group: self, role: 'moderator', inherited: false)
  end
end
