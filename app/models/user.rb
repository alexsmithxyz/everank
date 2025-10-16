class User < ApplicationRecord
  include Clearance::User

  enum :role, { ordinary_user: 0, admin: 1 }, default: :ordinary_user, validate: true

  validates :password, length: { minimum: 8 }, unless: :skip_password_validation?
  validates :role, presence: true
end
