class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 1 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :username, uniqueness: true
  after_create :create_group

  has_many :permissions
  has_many :groups, through: :permissions

  def create_group
    Group.create(owner: self, name: self.username)
  end
  
end
