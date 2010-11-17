SKETCH_KEYS = %w(
  title
  byline
  district_id
  token
  paths
  created_at
  updated_at
  reviewed
  appropriate
  gallery
)
# Note that I removed:
#   geometry

namespace :backup do

  desc "Backup sketches"
  task :sketches => :environment do
    filename = Rails.root.join('backups', 'paths.yml')
    File.open(filename, 'w') do |f|
      output = Sketch.all.map do |sketch|
        hash = {}
        SKETCH_KEYS.each do |key|
          hash[key] = sketch[key]
        end
        hash
      end
      YAML.dump(output, f)
    end
  end

end
