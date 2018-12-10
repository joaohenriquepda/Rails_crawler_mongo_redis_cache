# frozen_string_literal: true

# Class User
class User
  include Mongoid::Document

  # Include this class in your class
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String

  # Instead of password, create a password digest field
  field :password_digest
  has_secure_password
end
