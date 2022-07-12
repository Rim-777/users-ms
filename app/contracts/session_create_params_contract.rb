# frozen_string_literal: true

class SessionCreateParamsContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
