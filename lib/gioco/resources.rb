module Gioco
  class Resources < Core
    def self.change_points( rid, points, tid = false )
      resource          = get_resource( rid )
      type              = ( tid ) ? Type.find(tid) : false
      sync_resource_by_points(resource, points, type)
    end
  end
end