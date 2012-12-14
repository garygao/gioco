module Gioco
  class Ranking < Core

     def self.generate()
      ranking = []
      where_statement = "1=1"

      if POINTS && TYPES
        Type.find(:all).each do |t|
          data = RESOURCE_NAME.capitalize.constantize
                  .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*, 
                           points.type_id, SUM(points.value) AS type_points")
                  .where("points.type_id = #{t.id}")
                  .joins(:points)
                  .group("type_id, #{RESOURCE_NAME}_id")
                  .order("type_points DESC")

          ranking << { :type => t, :ranking => data }
        
        end

      elsif POINTS && !TYPES
        ranking = RESOURCE_NAME.capitalize.constantize.where(where_statement).order("points DESC")

      elsif !POINTS && !TYPES
        ranking = RESOURCE_NAME.capitalize.constantize
                    .select("#{RESOURCE_NAME.capitalize.constantizetable_name}.*,
                             COUNT(levels.badge_id) AS number_of_levels")
                    .joins(:levels)
                    .where(where_statement)
                    .group("#{RESOURCE_NAME}_id")
                    .order("number_of_levels DESC")

      end

      ranking
    end
  end
end
