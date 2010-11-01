class AddSketchColumns < ActiveRecord::Migration
  def self.up
    add_column :sketches, :reviewed,    :boolean, :default => false
    add_column :sketches, :appropriate, :boolean, :default => false
    add_column :sketches, :gallery,     :boolean, :default => false
    add_index :sketches, :reviewed
    add_index :sketches, :appropriate
    add_index :sketches, :gallery
  end

  def self.down
    remove_column :sketches, :reviewed,    :boolean, :default => false
    remove_column :sketches, :appropriate, :boolean, :default => false
    remove_column :sketches, :gallery,     :boolean, :default => false
    remove_index :sketches, :reviewed
    remove_index :sketches, :appropriate
    remove_index :sketches, :gallery
  end
end
