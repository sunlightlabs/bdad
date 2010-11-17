class UnsavedSketch < ActiveRecord::Base

  # == Associations ==

  belongs_to :district

  # == Validations ==

  validates_presence_of :district
  validates_presence_of :token
  validates_uniqueness_of :token

  # == Callbacks ==

  after_save :set_geometry

  # === Scopes

  scope :recent, order("created_at DESC").limit(10)

  # == Class Methods ==
  # ...

  # == Special Instance Methods ==

  def to_param
    token
  end

  # == Instance Methods ==

  def polygons
    DatabaseHelper.polygons_from_paths(paths)
  end

  def population
    DatabaseHelper.query_population('unsaved_sketches', id) if id
  end

  def set_geometry
    DatabaseHelper.update_geometry('unsaved_sketches', id, polygons)
  end

end
