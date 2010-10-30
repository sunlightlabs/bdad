class Convert

  # Convert:
  #   "M2 3L4 5L6 7ZM5 0L4 3L3 2Z"
  #
  # To:
  #   [
  #     [[[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [2.0, 3.0]]],
  #     [[[5.0, 0.0], [4.0, 3.0], [3.0, 2.0], [5.0, 0.0]]]
  #   ]
  #
  # Important:
  #   * If you pass a block, it will transform each point.
  #     The point is passed as an array: [x, y].
  #   * Each polygon boundary is converted to a closed loop.
  #
  # Notes:
  #   * This does not detect errors in a pathstring.
  #   * It would be better to split on 'M' first.
  def self.svg_path_to_multi_polygon_coordinates(path, &block)
    p = path.split(/[Zz]/)
    # ["M2 3L4 5L6 7", "M5 0L4 3L3 2"] 
    
    p = p.map { |x| x.split(/[ML]/).select{ |y| y != '' } }
    # [["2 3", "4 5", "6 7"], ["5 0", "4 3", "3 2"]]

    p = p.map { |x| x.map { |y| y.split(' ').map{ |z| z.to_f } } }
    # [
    #   [[2.0, 3.0], [4.0, 5.0], [6.0, 7.0]],
    #   [[5.0, 0.0], [4.0, 3.0], [3.0, 2.0]]
    # ]
    
    # Optionally transform each point.
    p = p.map { |x| x.map { |point| block.call(point) } } if block

    # Close the loop
    p = p.map { |x| x << x[0] }
    # [
    #   [[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [2.0, 3.0]],
    #   [[5.0, 0.0], [4.0, 3.0], [3.0, 2.0], [5.0, 0.0]]
    # ]
    
    # The return value will be a list of polygons. Each polygon consists of a
    # list of paths. For our case, a polygon only has one path, since it has
    # no internal features.
    p.map { |x| [x] }
    # [
    #   [[[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [2.0, 3.0]]],
    #   [[[5.0, 0.0], [4.0, 3.0], [3.0, 2.0], [5.0, 0.0]]]
    # ]
  end

  OPTIONS = {
    :scale      => 0.00015651005959419845,
    :x_offset   => 579281.5732728788,
    :y_offset   => -6861939.218334042,
    :max_height => 1500.0000000000002,
    :max_width  => 650.3790323772871,
    :invert_x   => false,
    :invert_y   => true,
  }

  # Convert a screen point to a map point.
  def self.screen_point_to_gis_point(point)
    x = if OPTIONS[:invert_x]
      -(point[0] - OPTIONS[:max_width]) / OPTIONS[:scale]
    else
      (point[0] / OPTIONS[:scale]) - OPTIONS[:x_offset]
    end
    y = if OPTIONS[:invert_y]
      -(point[1] - OPTIONS[:max_height]) / OPTIONS[:scale]
    else
      (point[1] / OPTIONS[:scale]) / OPTIONS[:y_offset]
    end
    [x, y]
  end

end
