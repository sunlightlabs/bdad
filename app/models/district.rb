class District < ActiveRecord::Base

  # == Associations ==

  has_many :sketches

  # == Validations ==

  validates_presence_of :state_code
  validates_presence_of :district_code
  validates_presence_of :combined_code
  validates_uniqueness_of :combined_code

  # == Callbacks ==

  before_validation :ensure_combined_code

  # == Class Methods ==

  # 2 digits for state + 2 digits for district. For example, "3301":
  #   33 = New Hampshire
  #   01 = 1st District
  # (from http://www.cs.princeton.edu/introcs/data/codes.csv)
  def self.make_combined_code(state_code, district_code)
    unless state_code && district_code
      raise "state_code and district_code are needed"
    end
    "%02i%02i" % [state_code.to_i, district_code.to_i]
  end

  def self.find_random
    District.find(:first, :offset => rand(District.count))
  end

  # == Instance Methods==

  def ensure_combined_code
    if combined_code.blank?
      self.combined_code = self.class.make_combined_code(
        state_code, district_code)
    end
  end

  def population
    QueryHelper.population('districts', id) if id
  end

end
