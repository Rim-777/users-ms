# frozen_string_literal: true

class UserSession < Sequel::Model
  plugin :uuid

  many_to_one :user

  include ::Validations

  def validate
    super
    validates :presence, :uuid
  end
end
