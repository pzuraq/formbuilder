class Group < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	has_many :forms
  has_many :permissions
	has_many :users, through: :permissions
  has_many :moderator_permissions, -> { where role: 'moderator' }, :class_name => 'Permission'
  has_many :moderators, source: :user, through: :moderator_permissions


  after_create :create_permission

  def create_permission
    Permission.create(user: self.user, group: self, role: 'moderator', inherited: false)
  end
end
