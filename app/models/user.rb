# frozen_string_literal: true

class User < Sequel::Model
  plugin :association_dependencies
  plugin :secure_password, cost: 12, include_validations: false

  NAME_FORMAT = /^[A-z]+$/

  one_to_many :sessions, class: UserSession
  add_association_dependencies sessions: :delete

  include ::Validations

  def validate
    super
    validates :presence, :email
    validates :presence, :password if new?
    validates_format(NAME_FORMAT, :first_name, message: I18n.t(:format, scope: 'model.errors.user_name')) if first_name
    validates_format(NAME_FORMAT, :last_name, message: I18n.t(:format, scope: 'model.errors.user_name')) if last_name
    validates_format(RegExp::EMAIL_FORMAT, :email, message: I18n.t(:format, scope: 'model.errors.email')) if email
  end
end
