g = window

# lightbox

lightbox = ->
  $(".lightbox").remove()
  $("html").prepend("<div class='lightbox'></div><div class='clear'></div>")
  
  for time in [0, 200, 500, 1000, 2000, 6000]
    setTimeout ->
      lightbox.resize()
    , time
    
  $(window).on "resize", ->
    lightbox.resize()

lightbox.show = (url) ->
  $(".lightbox").on "click", ->
    lightbox.close()
  
  $(".lightbox").append("<img src='#{url}' />")
  
  $(".lightbox img").on "load", ->
    $(".lightbox").css({ display: "block" })
    width = lightbox.image_width()
    $(".lightbox img").css({ width: width })
  
lightbox.resize = ->
  height = $("html").height()
  wheight = $(window).height()
  height = Math.max height, wheight
  $(".lightbox").height height

lightbox.close = ->
  $(".lightbox").hide()
  
lightbox.image_width = ->
  page_height = $(window).height() - parseInt($(".lightbox img").css("marginTop"))*2
  width = $(".lightbox img").width()
  height = $(".lightbox img").height()
  ratio = width / height
  height = Math.min page_height, height
  height * ratio

# picasa

write_picasa_images = (text) ->
  matches = text.match /\[picasa_(\d+)\]/g
  if matches
    for match in matches
      album_id = match.match(/\[picasa_(\d+)\]/)[1]
      picasa_init album_id
    regex = new RegExp( "\\[picasa_("+album_id+")\\]" )
    text = text.replace regex, "<div class='picasa_gallery' data-album_id='$1'></div>"
  text
    
  
picasa_init = (album_id) ->
  url = "http://picasaweb.google.com/data/feed/api/user/redazioneriotvan@gmail.com/albumid/#{album_id}?alt=json&fields=entry(title,gphoto:numphotos,media:group(media:content,media:thumbnail))&imgmax=1280&callback=?"
  thumb_size = 1 # 1/2/3
  
  $.getJSON url, (data) ->
    photos = data.feed.entry
    gal = $(".picasa_gallery")
    
    for photo in photos
      group = photo.media$group
      thumb_url = group.media$thumbnail[thumb_size].url
      url = group.media$content[0].url
      gal.append "<img src='#{thumb_url}' data-url='#{url}' />"
    
    lightbox()
    # url = "http://lh4.ggpht.com/-Cg8xAgpmZe4/T13-o6qTUFI/AAAAAAAAAkY/D4b1CFEIq5o/IMG_5881.JPG"
    #lightbox.show(url)
    
    $(".picasa_gallery img").on "click", ->
      url = $(this).data("url")
      lightbox()
      lightbox.show(url)
      
      
    
# fb

fb_init = ->
  if typeof(FB) == "object"
    FB.init
      appId: "333539793359620"
      channelUrl: "http://riotvan.net/channel.html"
      status: true
      cookie: true
      xfbml: true
  else
    setTimeout ->
      fb_init()
    , 300
    
g.fb_init = fb_init    
    
fb_setup = ->
  ((d) ->
    js = undefined
    id = "facebook-jssdk"
    ref = d.getElementsByTagName("script")[0]
    return  if d.getElementById(id)
    js = d.createElement("script")
    js.id = id
    js.async = true
    js.src = "//connect.facebook.net/en_US/all.js"
    ref.parentNode.insertBefore js, ref
  ) document


$("body").on "sass_loadeds", ->
  # g.fivetastic.dev_mode() # comment this in production
  $("body").off "page_loaded"
  gal_resize()
  set_home_height()
  fb_setup()
  
  # megafix
  
  $("body").on "page_js_loaded", ->
    track_page()
    gal_build()
    $("#content").css({ opacity: 0 })
    $("#content").animate({ opacity: 1 }, 1000)
    gal_resize()
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

track_page = ->
  page = location.pathname[1..-1]
  _gaq.push("_trackEvent", "Pages", "visit", page)

box_images = ->
  for article in $(".article")
    # TODO: when $(".article").loaded or markdown loaded, box image
    article = $(article)
    link = article.find("h2 a").attr("href")
    article.find("img").wrap("<div class='img_box'></div>")
    article.find("img").wrap("<a href='#{link}'></a>")
      
resize_issuu = ->
  if $(".issuu").length > 0
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

restore_gal = ->
  $("#img_gal img").css "opacity", 0
  $("#img_gal img:first-child").css "opacity", 1

cur_idx = 0


titles = []

set_home_height = ->
  height = $("#content").height()
  $(".right").css { height: height }
  
gal_build = ->
  return unless @collection && @collection[0]["collection"] == "articoli"
  images = for article in @collection
    img = article.images[0]
    img.title = article.title if img
    img
    
  images = _(images).compact()  
  $("#img_gal img").remove() 
  titles = []
  for image in images  
    titles.push image.title
    $("#img_gal").append("<img src='#{hostz}#{image.url}'>")
    $("#img_gal img").css({opacity: 0})
    $("#img_gal img:first").css({opacity: 1})
  $(".caption").html titles[cur_idx]

gal_anim = ->
  time = 5000
  # time = 1000
  gal_build() if $("#img_gal img").length < 1
    
  setTimeout =>
    images = _($("#img_gal img")).map (el) -> el
    cond = cur_idx >= images.length-1
    next_idx = if cond then 0 else cur_idx+1
    $(".caption").html titles[next_idx]
    $(images[cur_idx]).css "opacity", 0
    $(images[next_idx]).css "opacity", 1
    # console.log "hiding #{cur_idx}, showing #{next_idx}"
    cur_idx = if cond then 0 else cur_idx + 1

    gal_anim()
  , time


gal_resize = ->
  setTimeout ->
    height = $("#img_gal").width() / 4 * 2.5
    $("#img_gal").height height
  , 10

$(window).on "resize", ->
  gal_resize()


######## 
# fiveapi

# $(document).ajaxSend (event, xhr, settings) ->
#   settings.xhrFields = { withCredentials: true }


unless window.console && console.log
  window.console = {}
  console.log = ->

puts = console.log
  
# models

# mollections

# collections

# views


# console.log hostz

if location.hostname == "localhost"
  # dev
  hostz = "localhost:3000"
  local = "localhost:3001" 
else
  # prod
  hostz = "fiveapi.com"
  local = "riotvan.net"

hostz = "http://#{hostz}"
local = "http://#{local}"

haml.host = local

articles_per_page = 5

# fiveapi requires jquery/zepto

$("body").on "page_loaded", ->

  $.get "#{hostz}/fiveapi.js", (data) ->
    eval data
    configs = {
      user: "makevoid",
      project: { riotvan: 1 },
      collections: { 
        articoli: 1,
        eventi: 2,
        chi_siamo: 3,
        collaboratori: 4,
        video: 5
      }
    }
    window.fiveapi = new Fiveapi( configs )
    fiveapi.activate()
    
    # default sort keys: published_at, id DESC
  
    # #TODO: debug code, remove in production
    # $("#fiveapi_edit").trigger "click"
    # fiveapi.start_edit_mode()
    # setTimeout ->
    #     $(".articles a").first().trigger "click"
    #   , 200
  
    # fiveapi.start_edit_mode()
    # setTimeout ->
    #     $(".articles a").first().trigger "click"
    #   , 200
      
      
    $("body").on "got_collection2", ->
      gal_anim()
      $("body").off "got_collection2"
      
    $("body").on "got_collection", ->
      fb_init()
      setTimeout -> 
        box_images()
        gal_build()
        set_home_height()
      , 300
      
    $("body").on "got_article", ->
      fb_init()
      
    setTimeout ->
      get_elements()
    , 100
  
    $("body").on "page_js_loaded", ->
      get_elements()  
  
hamls = {}

write_images = (obj) =>
  # obj.text = 
  for image in obj.images
    regex = new RegExp "\\[image_#{image.id}\\]"
    obj.text = obj.text.replace regex, "![](#{hostz}#{image.url})"
  obj

write_videos = (text) ->
  # [youtube_2b_8yOZJn8A]
  text.replace /\[youtube_(.+)\]/, "<iframe src='http://www.youtube.com/embed/$1' allowfullscreen></iframe>"
  
markup = (obj) ->  
  obj = write_images obj
  text = markdown.toHTML obj.text
  text = write_videos text
  write_picasa_images text
  
singularize = (word) ->
  word.replace /s$/, ''

get_elements = ->
  get_article()  
  per_page = if location.pathname == "/chi_siamo" ||  location.pathname ==  "/collabs"
    50
  else
    articles_per_page
    
  filters = { limit: per_page, offset: 0 }
  get_collection(filters)  

render_pagination = (pag) ->  
  total_pages = pag["entries_count"] / pag["limit"]
  current_page = pag["offset"]*pag["limit"]
  pages_view =  for i in [1..total_pages]
    "<a>#{i}</a>"
  pagination = "

    #{pages_view.join(" ")}

  "
  $(".pagination[data-collection=#{pag["collection"]}]").html(pagination)
  $(".pagination[data-collection=#{pag["collection"]}] a").on "click", ->
    page = $(this).html()-1
    limit = articles_per_page
    get_collection { limit: limit, offset: limit*page }

get_article = ->
  article_id = fiveapi.article_from_page()
  if article_id
    fiveapi.get_article article_id, (article) ->
      got_article article_id, article

get_collection = (filters={}) ->
  coll_name = fiveapi.collection_from_page()
  if coll_name
    fiveapi.get_collection coll_name, filters, (collection) ->
      if location.pathname == "/chi_siamo"
        collection["articles"] = _(collection["articles"]).shuffle()
      filters.entries_count = collection["count"]
      filters.collection = coll_name
      render_pagination(filters)
      got_collection coll_name, collection["articles"]

load_haml = (view_name, callback) ->
  if hamls[view_name]
    callback hamls[view_name]
  else
    $.get "#{local}/views/#{view_name}.haml", (data) =>
      hamls[view_name] = data 
      callback hamls[view_name]

render_haml = (view_name, obj={}, callback) ->
  # TODO: cache request
  obj.text = markup obj
  load_haml view_name, (view) =>
    html = haml.compileStringToJs(view) obj
    callback html

got_article = (id, article) ->
  view = "#{singularize article.collection}_article"
  render_haml view, article, (html) ->
    $(".fiveapi_element[data-type=article]").append html   
    $("body").trigger "got_article"

got_collection = (name, collection) ->
  collection_elem = $(".fiveapi_element[data-type=collection]")
  collection_elem.html("")    
  @collection = collection
  $("body").trigger "got_collection"
  $("body").trigger "got_collection2"
  _(collection).each (elem) ->                                
    render_haml name, elem, (html) ->                         
      collection_elem.append html 

# helpers

haml.location_article_id = (location) -> 
  _(location.pathname.split("/")).reverse()[0].split("-")[0]

haml.format_date = (date) ->
  date = new Date(date)
  "#{date.getDate()}/#{date.getMonth()+1}/#{date.getFullYear()}"
  
haml.article_preview = (text) ->
  text = text.replace(/\[picasa_(\d+)\]/, '')
  max_length = 520
  if text.length > max_length
    txt = text.split(/\[image_\d+\]/)[1]
    text = txt if txt
    "#{text.substring(0, max_length)}..."
  else
    text
# 
# position: relative;
# top: -66px;
# right: 35px;
# border-radius: 43px;
# width: 1px;
# font-size: 0.1em;