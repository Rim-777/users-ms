class UserCreateParamsContract < Dry::Validation::Contract
  params do
    required(:data).hash do
      required(:attributes).hash do
        required(:email).filled(:string)
        required(:password).filled(:string)
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
      end
    end
  end

  rule(%i[data attributes email]).validate(format: RegExp::EMAIL_FORMAT)
end
