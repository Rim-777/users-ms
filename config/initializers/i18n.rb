# frozen_string_literal: true

I18n.load_path += Dir[Application.root.concat('/config/locales/**/*.yml')]
I18n.available_locales = %I[en ru]
I18n.default_locale = :en
