g = window
$("body").bind "sass_loadeds", ->
  # g.fivetastic.dev_mode() # comment this in production
  $("body").unbind "page_loaded"
  gal_resize()
  

# require_api = (api) ->
#   $.get "/fivetastic/api/lastfm.coffee", (coffee) ->
#     eval CoffeeScript.compile(coffee)
#     
# # APIS: fb, lastfm, delicious, twitter
# require_api "lastfm"

gal_resize = ->
  height = $("#img_gal").width() / 4 * 2.5
  $("#img_gal").height height


$(window).on "resize", ->
  gal_resize()


console.log "app coffee loaded"