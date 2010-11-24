namespace :db do

  desc "Drop sketches, unsaved_sketches"
  task :drop_sketch_tables => :environment do
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
