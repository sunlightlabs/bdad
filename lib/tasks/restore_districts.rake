namespace :restore do

  desc "Restore districts"
  task :districts => :environment do
    db = Rails.application.config.database_configuration[Rails.env]
    command = "psql -h #{db['host']} -U #{db['username']} " +
      "#{db['database']} < #{Rails.root.join('backups', 'districts.sql')}"
    puts command
    `#{command}`
  end

end
