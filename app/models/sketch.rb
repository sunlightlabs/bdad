class Sketch < ActiveRecord::Base

  # == Associations ==

  belongs_to :district

  # == Validations ==

  validates_presence_of :district
  validates_presence_of :token
  validates_uniqueness_of :token

  # == Callbacks ==

  before_validation :ensure_token
  before_save :set_geometry

  # === Scopes

  scope :recent, order('created_at DESC').limit(10)
  scope :gallery, where(:gallery => true)

  # == Class Methods ==

  def self.make_token
    SecureRandom.hex(8) # 2 characters * 8 = 16 characters
  end

  def self.random(count)
    self.limit(count).order('random()') # random() is a Postgres function
  end

  # == Special Instance Methods ==

  def initialize(*options)
    super
    ensure_token
  end

  def to_param
    token
  end

  # == Instance Methods ==

  def ensure_token
    if token.blank?
      self.token = self.class.make_token
    end
  end

  def get_geometry
    coordinates = Convert.svg_path_to_multi_polygon_coordinates(paths) do |p|
      Convert.screen_point_to_gis_point(p)
    end
    MultiPolygon.from_coordinates(coordinates)
  end

  def population
    QueryHelper.population('sketches', id) if id
  end

  def set_geometry
    self.geometry = get_geometry
  end

end
