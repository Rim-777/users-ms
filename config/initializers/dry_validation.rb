# frozen_string_literal: true

Dry::Validation.register_macro(:format) do |macro:|
  if value&.!~ macro.args.first
    message = macro.args[1] || I18n.t(:invalid_format, scope: 'api.errors')
    key.failure(message)
  end
end