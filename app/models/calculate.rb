class Calculate

  def self.range(bounds)
    {
      :x => bounds[:max_x] - bounds[:min_x],
      :y => bounds[:max_y] - bounds[:min_y],
    }
  end

  def self.center(bounds)
    {
      :x => (bounds[:max_x] + bounds[:min_x]) / 2.0,
      :y => (bounds[:max_y] + bounds[:min_y]) / 2.0,
    }
  end

end
