class QueryHelper

  # Notes:
  #   bgs           ... block groups
  #   bgs.the_point ... the centroid of a block group
  def self.population(table, record_id)
    query = "SELECT sum(bgs.pop) " +
    "FROM (SELECT geometry FROM #{table} WHERE id = #{record_id}) " +
    "AS item, bgs " +
    "WHERE ST_Contains(item.geometry, bgs.the_point);"
    result = ActiveRecord::Base.connection.execute(query)
    result[0]['sum'].to_i
  end

end