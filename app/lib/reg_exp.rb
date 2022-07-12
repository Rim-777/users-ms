# frozen_string_literal: true

module RegExp
  extend self

  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  BEARER_TOKEN = %r{\ABearer (?<token>.+)\z}
end
