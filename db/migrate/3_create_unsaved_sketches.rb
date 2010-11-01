class CreateUnsavedSketches < ActiveRecord::Migration
  def self.up
    create_table :unsaved_sketches do |t|
      t.integer       :district_id
      t.text          :paths,       :default => ''
      t.string        :token
      t.multi_polygon :geometry
      t.timestamps
    end
    add_index :unsaved_sketches, :district_id
    add_index :unsaved_sketches, :token
    add_index :unsaved_sketches, :updated_at
  end

  def self.down
    begin
      drop_table :unsaved_sketches
    rescue ActiveRecord::StatementInvalid => e
      puts "   -> unsaved_sketches does not exist"
    end
  end
end
