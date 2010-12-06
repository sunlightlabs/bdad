Bdad::Application.config.admin_credentials = YAML::load_file(
  Rails.root.join('config', 'admin.yml'))