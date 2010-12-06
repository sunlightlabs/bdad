Bdad::Application.config.analytics_key = YAML::load_file(
  Rails.root.join('config', 'analytics.yml'))['key']
