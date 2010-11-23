namespace :backup do

  desc "Backup districts"
  task :districts => :environment do
    db = Rails.application.config.database_configuration[Rails.env]
    command = "pg_dump -h #{db['host']} -U #{db['username']} -t districts -a " +
      "#{db['database']} > #{Rails.root.join('backups', 'districts.sql')}"
    puts command
    `#{command}`
  end

end
