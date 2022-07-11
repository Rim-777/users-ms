# frozen_string_literal: true

class UserUpdateParamsContract < Dry::Validation::Contract
  params do
    required(:data).hash do
      required(:attributes).hash do
        optional(:email).filled(:string)
        optional(:password).filled(:string)
        optional(:first_name).filled(:string)
        optional(:last_name).filled(:string)
      end
    end
  end
end
