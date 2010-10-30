class UnsavedSketch < ActiveRecord::Base

  # == Associations ==

  belongs_to :district

  # == Validations ==

  validates_presence_of :district
  validates_presence_of :token
  validates_uniqueness_of :token

  # == Callbacks ==

  before_save :set_geometry

  # === Scopes

  scope :recent, order("created_at DESC").limit(10)

  # == Class Methods ==
  # ...

  # == Special Instance Methods ==

  def to_param
    token
  end

  # == Instance Methods ==

  def get_geometry
    coordinates = Convert.svg_path_to_multi_polygon_coordinates(paths) do |p|
      Convert.screen_point_to_gis_point(p)
    end
    MultiPolygon.from_coordinates(coordinates)
  end

  def population
    QueryHelper.population('unsaved_sketches', id) if id
  end

  def set_geometry
    self.geometry = get_geometry
  end

end
