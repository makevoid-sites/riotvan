path = File.expand_path "../", __FILE__

# require "#{path}/fivetastic"
# run Fivetastic

require "#{path}/riotvan"

use Rack::Static, urls: ["/views"], root: "#{path}/public/views"
run RiotVan