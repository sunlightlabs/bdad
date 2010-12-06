class AddEditableColumnToSketches < ActiveRecord::Migration
  def self.up
    add_column :sketches, :editable, :boolean, :default => true
  end

  def self.down
    remove_column :sketches, :editable
  end
end
