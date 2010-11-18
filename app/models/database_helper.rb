class DatabaseHelper

  def self.polygons_from_paths(paths)
    list = Convert.svg_path_to_list_of_polygon_coordinates(paths) do |p|
      Convert.screen_point_to_gis_point(p)
    end
    list.map { |coords| Polygon.from_coordinates(coords) }
  end

  # Notes:
  #   bgs           ... block groups
  #   bgs.the_point ... the centroid of a block group
  def self.query_population(table, record_id)
    query = "SELECT sum(bgs.pop) " +
    "FROM (SELECT geometry FROM #{table} WHERE id = #{record_id}) " +
    "AS item, bgs " +
    "WHERE ST_Contains(item.geometry, bgs.the_point);"
    result = ActiveRecord::Base.connection.execute(query)
    result[0]['sum'].to_i
  end

  # polygons : a Ruby array of GeoRuby Polygon objects
  def self.update_geometry(table, record_id, polygons)
    command = "UPDATE #{table} " +
    "SET geometry = (" +
      "SELECT ST_Union(ARRAY[" +
        polygons.map { |polygon|
          "ST_Buffer(ST_GeomFromText('#{polygon.as_wkt}'), 0)"
        }.join(", ") +
      "])" +
    ") WHERE id = #{record_id};"
    ActiveRecord::Base.connection.execute(command)
  end

  # SELECT
  #   ST_Union(
  #     ARRAY[
  #       ST_buffer(ST_GeomFromText('POLYGON((x y,...))'), 0),
  #       ST_buffer(ST_GeomFromText('POLYGON((x y,...))'), 0),
  #       ST_buffer(ST_GeomFromText('POLYGON((x y,...))'), 0)
  #     ]
  #   );

end
