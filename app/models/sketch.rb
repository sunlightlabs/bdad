class Sketch < ActiveRecord::Base

  # == Associations ==

  belongs_to :district

  # == Validations ==

  validates_presence_of :district
  validates_presence_of :token
  validates_uniqueness_of :token

  # == Callbacks ==

  before_validation :ensure_token
  after_save :set_geometry

  # === Scopes

  scope :recent, order('created_at DESC').limit(50)
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

  def bounds
    b = district.bounds
    center    = Calculate.center(b)
    range     = Calculate.range(b)
    half_edge = [range[:x], range[:y]].max
    edge      = half_edge * 2
    {
      :min_x   => center[:x] - half_edge,
      :min_y   => center[:y] - half_edge,
      :max_x   => center[:x] + half_edge,
      :max_y   => center[:y] + half_edge,
    }
  end

  def ensure_token
    if token.blank?
      self.token = self.class.make_token
    end
  end

  def polygons
    DatabaseHelper.polygons_from_paths(paths)
  end

  def population
    DatabaseHelper.query_population('sketches', id) if id
  end

  def set_geometry
    DatabaseHelper.update_geometry('sketches', id, polygons)
  end

end
