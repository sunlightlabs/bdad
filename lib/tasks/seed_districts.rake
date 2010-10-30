namespace :db do

  namespace :seed do
    desc "Seed districts data"
    task :districts => :environment do
      District110.all.each do |d110|
        combined_code = District.make_combined_code(d110.state, d110.cd)
        district = District.where(:combined_code => combined_code).first
        unless district
          District.create!({
            :state_code    => d110.state,
            :district_code => d110.cd,
            :geometry      => d110.the_geom,
          })
        end
      end
    end
  end

end
