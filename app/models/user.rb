class User < ApplicationRecord

  enum role: { regular: 0, manager: 10 }

  validates_presence_of :name, :login, :password_digest
  validates_uniqueness_of :login

  has_secure_password

end
