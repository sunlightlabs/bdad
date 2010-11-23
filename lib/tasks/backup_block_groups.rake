namespace :backup do

  desc "Backup block_groups"
  task :block_groups => :environment do
    db = Rails.application.config.database_configuration[Rails.env]
    command = "pg_dump -h #{db['host']} -U #{db['username']} -t bgs " +
      "#{db['database']} > #{Rails.root.join('backups', 'block_groups.sql')}"
    puts command
    `#{command}`
  end

end
