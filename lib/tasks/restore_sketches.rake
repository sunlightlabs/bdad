namespace :restore do

  desc "Restore sketches"
  task :sketches => :environment do
    filename = Rails.root.join('backups', 'sketches.yml')
    rows = YAML::load_file(filename)
    count = 0
    rows.each do |row|
      sketch = Sketch.new
      row.each do |key, value|
        sketch[key] = value
      end
      sketch.save!
      count += 1
    end
    puts "Restored #{count} sketches."
  end

end
