class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 1 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :username, uniqueness: true

  has_many :groups
  # We are going to want this a lot so lets make a shortcut
  has_one :root_group, -> { where :parent_id => [false, nil] }, foreign_key: :owner_id, class_name: 'Group'

  has_many :permissions
  has_many :responses

  has_many :moderates, -> { where role_rank: 0 }, class_name: 'Permission'
  has_many :edits, -> { where role_rank: 1 }, class_name: 'Permission'
  has_many :views, -> { where role_rank: 2 }, class_name: 'Permission'

  after_create :create_group

  def create_group
    Group.create(owner: self, name: self.username)
  end

end
