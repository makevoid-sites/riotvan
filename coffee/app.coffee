g = window
$("body").on "sass_loadeds", ->
  # g.fivetastic.dev_mode() # comment this in production
  $("body").off "page_loaded"
  gal_resize()
  gal_anim()
  
  # megafix
  render_md()
  setTimeout ->
    render_md()
  , 200
  
  $("body").on "page_js_loaded", ->
    gal_resize()
    render_md()

    resize_issuu()
    if $(".issuu").length > 0
      $(window).on "resize", ->
        resize_issuu()
    
  # resize issuu
  setTimeout ->
    resize_issuu()
  , 200
  
  if $(".issuu").length > 0
    $(window).on "resize", ->
      resize_issuu()
  
resize_issuu = ->
  if $(".issuu").length > 0
    console.log "isssa"
    top_margin = 20
    page_margin = 15
    height = $("header").height() + top_margin + page_margin*2
    iss_height = $(window).height() - height
    # console.log iss_height
    $(".issuu, .issuu embed").height iss_height
  
# require_api = (api) ->
#   $.get "/fivetastic/api/lastfm.coffee", (coffee) ->
#     eval CoffeeScript.compile(coffee)
#     
# # APIS: fb, lastfm, delicious, twitter
# require_api "lastfm"

render_md = ->
  _($(".md")).each (elem) ->
    el = $(elem)
    unless el.data("rendered")
      md = el.html()
      htm = exports.toHTML md
      # console.log md
      # console.log htm
      el.html htm
      el.data "rendered", true

restore_gal = ->
  $("#img_gal img").css "opacity", 0
  $("#img_gal img:first-child").css "opacity", 1



titles = ["Riot Van #10 is out!", "Foto dal festival internazionale del film a Roma 2011!", "Bam bam bam bam bam bam bam baaam!", "Dee Dee &amp; Brandon of DUM DUM GIRLS &amp; CROCODILES"]

cur_idx = 0

gal_anim = ->
  time = 5000
  # time = 1000
  $(".caption").html titles[cur_idx]
  setTimeout ->
    images = _($("#img_gal img")).map (el) -> el
    cond = cur_idx >= images.length-1
    next_idx = if cond then 0 else cur_idx+1
    $(images[cur_idx]).css "opacity", 0
    $(images[next_idx]).css "opacity", 1
    # console.log "hiding #{cur_idx}, showing #{next_idx}"
    cur_idx = if cond then 0 else cur_idx + 1

    gal_anim()
  , time


gal_resize = ->
  height = $("#img_gal").width() / 4 * 2.5
  $("#img_gal").height height



$(window).on "resize", ->
  gal_resize()


console.log "app coffee loaded"