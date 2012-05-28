path = File.expand_path "../", __FILE__
require "#{path}/deepzoom"
image_creator = ImageCreator.new

# Custom settings
image_creator.tile_size = 508
image_creator.tile_overlap = 2
image_creator.tile_format = "png"
image_creator.image_quality = 1
image_creator.copy_metadata = true

# convert
image_creator.create("fanwall.jpg", "image.dzi")