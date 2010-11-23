namespace :restore do

  desc "Restore block_groups"
  task :block_groups => :environment do
    db = Rails.application.config.database_configuration[Rails.env]
    command = "psql -h #{db['host']} -U #{db['username']} " +
      "#{db['database']} < #{Rails.root.join('backups', 'block_groups.sql')}"
    puts command
    `#{command}`
  end

end
