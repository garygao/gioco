module Gioco
  class Core
    def self.get_resource(rid)
      RESOURCE_NAME.capitalize.constantize.find(rid)
    end

    def self.sync_resource_by_points(resource, points, type = false)

      if TYPES && type
        old_pontuation  = resource.points.sum(:value)
      else
        old_pontuation  = resource.points.to_i
      end
      new_pontuation = old_pontuation + points

      related_badges  = Badge.where( "points <= #{new_pontuation}" )

      Badge.transaction do
        if TYPES && type
          resource.points  << Point.create({ :type_id => type.id, :value => points })
        elsif POINTS
          resource.update_attribute( :points, new_pontuation )
        end
        related_badges.each do |badge|
          if old_pontuation < new_pontuation
            resource.badges << badge if !resource.badges.include?(badge)
          elsif badge.points > new_pontuation
            resource.levels.where( :badge_id => badge.id )[0].destroy
          end
        end
      end
    end
  end
end