# frozen_string_literal: true

module ApplicationLoader
  extend self

  def load_app!
    init_config
    init_db
    require_app
    init_app
  end

  private

  def init_config
    require_file 'config/initializers/config'
  end

  def init_db
    require_file('config/initializers/db')
  end

  def require_app
    require_dir('app/helpers')
    require_file('config/application')
    require_file('app/operations/base_operation')
    require_dir('app/models/mixins')
    require_dir('app')
  end

  def init_app
    require_dir('config/initializers')
  end

  def require_file(file_path)
    require global_path_to(file_path)
  end

  def require_dir(dir_path)
    Dir["#{global_path_to(dir_path)}/**/*.rb"].each { |f| require f }
  end

  def root
    File.expand_path('..', __dir__)
  end

  def global_path_to(dir_or_file)
    File.join(root, dir_or_file)
  end
end
