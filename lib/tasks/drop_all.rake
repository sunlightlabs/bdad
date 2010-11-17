namespace :db do

  desc "Drop all tables"
  task :drop_all => :environment do
    verbosely_drop_table('districts')
    verbosely_drop_table('sketches')
    verbosely_drop_table('unsaved_sketches')
  end

  def verbosely_drop_table(name)
    @connection ||= ActiveRecord::Base.connection
    @connection.drop_table(name)
    puts "Dropped #{name}."
  rescue ActiveRecord::StatementInvalid => e
    puts "Already dropped #{name}."
  end
  
end
