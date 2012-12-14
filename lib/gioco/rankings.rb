module Gioco
  class Ranking < Core

     def self.generate(by_what = nil)
      ranking = []
      where_statement = "1=1"

      if POINTS && TYPES
        case by_what
          when "today"
            where_statement = where_statement + " & points.created_at > #{Time.now.at_beginning_of_day}"
          when "this week"
            where_statement = where_statement + " & points.created_at > #{Time.now.at_beginning_of_week}"
          when "this month"
            where_statement = where_statement + " & points.created_at > #{Time.now.at_beginning_of_month}"
        end

        data = RESOURCE_NAME.capitalize.constantize
                .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*,
                         SUM(points.value) AS user_points")
                .joins(:points)
                .where(where_statement)
                .group("#{RESOURCE_NAME.capitalize.constantize.table_name}.id")
                .order("user_points DESC")

        ranking << {:ranking => data }

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
