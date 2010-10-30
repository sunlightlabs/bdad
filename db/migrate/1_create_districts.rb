class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.string   :state_name,    :limit => 30
      t.string   :district_code, :limit => 2
      t.string   :state_code,    :limit => 2
      t.string   :combined_code, :limit => 4
      t.geometry :geometry
      t.timestamps
    end
    add_index :districts, :combined_code
  end

  def self.down
    begin
      drop_table :districts
    rescue ActiveRecord::StatementInvalid => e
      puts "   -> districts does not exist"
    end
  end
end
