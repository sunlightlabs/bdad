class AddQualityAndHilarityColumnsToSketches < ActiveRecord::Migration
  def self.up
    add_column :sketches, :quality, :integer
    add_column :sketches, :hilarity, :integer
  end

  def self.down
    remove_column :sketches, :quality
    remove_column :sketches, :hilarity
  end
end
