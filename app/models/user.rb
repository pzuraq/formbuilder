class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :username, uniqueness: true
  after_create :create_group

  def create_group
    Group.create(user: self, name: self.username+"'s group")
  end
  
end
