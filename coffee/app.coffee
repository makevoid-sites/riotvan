g = window
$("body").bind "sass_loadeds", ->
  # g.fivetastic.dev_mode() # comment this in production
  $("body").unbind "page_loaded"
  gal_resize()
  gal_anim()  

# require_api = (api) ->
#   $.get "/fivetastic/api/lastfm.coffee", (coffee) ->
#     eval CoffeeScript.compile(coffee)
#     
# # APIS: fb, lastfm, delicious, twitter
# require_api "lastfm"


cur_idx = 0

gal_anim = ->
  setTimeout ->
    images = _($("#img_gal img")).map (el) -> el
    cond = cur_idx >= images.length-1
    next_idx = if cond then 0 else cur_idx+1
    $(images[cur_idx]).css "opacity", 0
    $(images[next_idx]).css "opacity", 1
    # console.log "hiding #{cur_idx}, showing #{next_idx}"
    cur_idx = if cond then 0 else cur_idx + 1

    gal_anim()
  , 5000


gal_resize = ->
  height = $("#img_gal").width() / 4 * 2.5
  $("#img_gal").height height



$(window).on "resize", ->
  gal_resize()


console.log "app coffee loaded"