# frozen_string_literal: true

module Validations
  class InvalidParams < StandardError; end

  def validate_with!(params, validation_contract)
    validation = validate_with(params, validation_contract)
    raise InvalidParams, validation.errors.to_h if validation.failure?

    validation
  end

  def validate_with(params, validation_contract)
    contract = validation_contract.new
    contract.call(params)
  end
end
