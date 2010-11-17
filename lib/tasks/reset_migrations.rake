namespace :db do

  desc "Dangerous! Drops schema_migrations table"
  task :reset_migrations => :environment do
    verbosely_drop_table('schema_migrations')
  end

  def verbosely_drop_table(name)
    @connection ||= ActiveRecord::Base.connection
    @connection.drop_table(name)
    puts "Dropped #{name}."
  rescue ActiveRecord::StatementInvalid => e
    puts "Already dropped #{name}."
  end
  
end
