g = window

# TODO: lanciare alla callback o quando appare .gsc-input
setTimeout ->
    $(".gsc-input").css(background: "none")
  , 2000

inject_spinner = ->
  elements = $(".fiveapi_element[data-type=collection],.fiveapi_element[data-type=article],.external_markdown")
  return if elements.html() != ""
  elements.css { width: "100%", display: "block" }
  elements.html "<img src='/images/spinner.gif' class='spinner'>"

render_markup = ->
  elements = $(".fiveapi_element[data-type=article]")
  elements.each (idx, element) ->
    text_elem = $(element).find(".text")
    images = text_elem.data "images"
    return unless images
    text = text_elem.data "text"
    article = { images: images, text: text }
    html = markup article
    html = render_issuu html
    text_elem.html html

render_issuu = (html) ->
  regex = /\[issuu_([a-f0-9-]+)\]/
  match = html.match regex
  if match
    issuu_id = match[1]
    obj = { issuu_id: issuu_id }
    issuu_html = haml.compileStringToJs(views.issuu) obj
    html = html.replace regex, issuu_html
  html


# srvstatus

srvstatus = ->
  # if location.hostname != "localhost"
  $.ajax
    url: "http://riotvan.dyndns.org"
    success: (data) ->
      if data == "OK"
        $(".srvstatus").addClass "open"
    error: ->
      false # do nothing

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

  $(".lightbox img").imagesLoaded ->
    $(".lightbox").css({ display: "block" })
    width = lightbox.image_width()
    img = $(".lightbox img")
    img.css({ width: width }).css({ top: $(document).scrollTop() })
    marginLeft = $("body").width() / 2 - img.width() / 2
    img.css( left: marginLeft )

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
      gal.append "<div class='imgbox'><img src='#{thumb_url}' data-url='#{url}' /></div>"

    lightbox()
    # url = "http://lh4.ggpht.com/-Cg8xAgpmZe4/T13-o6qTUFI/AAAAAAAAAkY/D4b1CFEIq5o/IMG_5881.JPG"
    #lightbox.show(url)

    $(".picasa_gallery .imgbox").on "click", ->
      url = $(this).find("img").data("url")
      lightbox()
      lightbox.show(url)

    picasa_resize()
    $(window).on "resize", ->
      picasa_resize()

picasa_resize = ->
  $(".picasa_gallery .imgbox img").imagesLoaded ->
    $(".picasa_gallery .imgbox").each (idx, img) ->
      img = $(img)
      img.height img.find("img").height()



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
  `
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=333539793359620";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'))
  `
  true

track_page = ->
  page = location.pathname[1..-1]
  _gaq.push("_trackEvent", "Pages", "visit", page)

box_images = ->
  $(".article, .event").each (idx, article) ->
    article = $(article)
    link = article.find("h2 a").attr("href") || article.find("h3 a").attr("href")
    img = article.find("img")
    img.wrap("<div class='img_box'></div>")
    img.wrap("<a href='#{link}'></a>") if link
    img.imagesLoaded =>
      height = Math.min img.height(), 200
      article.find(".img_box").height height

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
  # hostz = "fiveapi.com"
  # local = "riotvan.net"
else
  # prod
  hostz = "fiveapi.com"
  local = "riotvan.net"

hostz = "http://#{hostz}"
local = "http://#{local}"


haml.host = local

articles_per_page = 5

# fiveapi requires jquery/zepto

$ ->

  fb_setup()

  resize_issuu()
  if $(".issuu").length > 0
    $(window).on "resize", ->
      resize_issuu()
  inject_spinner()

  # article (single page article)
  render_markup()
  bind_lightbox()
  add_figcaptions()

  # resize issuu
  setTimeout ->
    resize_issuu()
  , 200

  if $(".issuu").length > 0
    $(window).on "resize", ->
      resize_issuu()

  $(window).on "resize", ->
    gal_resize()

  # fiveapi

  srvstatus()

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
      },
      host: hostz
    }
    window.fiveapi = new Fiveapi( configs )
    fiveapi.activate()

    render_markdown()
    render_external_markdown()

    # fb_init()
    # gal_build()
    set_home_height()

    setTimeout ->
      get_elements()
    , 100

    $("body").on "got_collection", ->
      gal_anim()
      gal_resize()
      set_home_height()
      box_images()

bind_lightbox = ->
  $(".article .text img").on "click", ->
    url = $(this).attr("src")
    lightbox()
    lightbox.show(url)

add_figcaptions = ->
  $(".article .text img").imagesLoaded ->
    $(this).each (id, elem) ->
      add_figcaption $(elem)

add_figcaption = (img) ->
  figure = $("<figure>")
  caption = img.attr "title"
  if caption
    img.wrap figure
    img.after "<figcaption>#{caption}</figcaption>"


hamls = {}

render_external_markdown = ->
  $(".external_markdown").each (idx, elem) ->
    view_name = $(elem).data "name"
    $.get "#{local}/views/#{view_name}.md", (data) =>
      mark = data
      html = markdown.toHTML mark
      $(elem).html html

render_markdown = ->
  $(".md").each (idx, elem) ->
    mark = $(elem).html()
    html = markdown.toHTML mark
    $(elem).html html

write_images = (obj) =>
  # obj.text =
  for image in obj.images
    regex_w_title = new RegExp "\\[(image|file)_#{image.id}\\](>(.+)<)*"
    if obj.text.match regex_w_title
      obj.text = obj.text.replace regex_w_title, "![$3](#{hostz}#{image.url} \"$3\")"
    else
      regex = new RegExp "\\[(image|file)_#{image.id}\\]"
      obj.text = obj.text.replace regex, "![](#{hostz}#{image.url})"
  obj

write_videos = (text) ->
  # [youtube_2b_8yOZJn8A]
  text.replace /\[youtube-(.+)\]/g, "<iframe src='http://www.youtube.com/embed/$1' allowfullscreen></iframe>"

prepare_videos = (text) ->
  text.replace /\[youtube_(.+)\]/g, "[youtube-$1]"

write_openzoom = (text) ->
  text.replace /\[openzoom_(.+)\]/m, '<object type="application/x-shockwave-flash" data="/openzoom/viewer.swf" width="100%" height="600px" name="viewer">
      <param name="scale" value="noscale" />
      <param name="bgcolor" value="#FFFFFF" />
      <param name="allowfullscreen" value="true" />
      <param name="allowscriptaccess" value="always" />
      <param name="flashvars" value="source=/openzoom/$1.dzi" />
  </object>'

markup = (obj) ->
  obj = write_images obj
  text = obj.text
  text = prepare_videos text
  text = markdown.toHTML text
  text = write_openzoom text
  text = write_videos text
  write_picasa_images text

singularize = (word) ->
  word.replace /s$/, '' if word

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
  return if location.pathname.match /\/articoli/
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
      return if location.pathname == "/" && !filters.limit
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
  if article.collection
    view = "#{singularize article.collection}_article"
    render_haml view, article, (html) ->
      $(".fiveapi_element[data-type=article]").html html
      $("body").trigger "got_article"
  else
    console.log "Error: #{article.error}"

g.cur_collection = []

got_collection = (name, collection) ->
  collection_elem = $(".fiveapi_element[data-type=collection]")
  collection_elem.html("")
  @collection = collection
  coll_temp = []
  _(collection).each (elem, idx) =>
    render_haml name, elem, (html) =>
      coll_temp[idx] = html
      if _(coll_temp).compact().length == collection.length
        collection_elem.append coll_temp.join("\n")
        $(collection_elem).css {opacity: 0}
        $(collection_elem).animate {opacity: 1}, 200
        $("body").trigger "got_collection"
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
    txt = text.split(/\[(file|image)_\d+\]/)[1]
    text = txt if txt
    $.htmlClean "#{text.substring(0, max_length)}..."
  else
    text

views = {}

views.issuu = '- src = "http://static.issuu.com/webembed/viewers/style1/v2/IssuuReader.swf"\n
- mode = "mode=mini&backgroundColor=%23222222&documentId="+issuu_id\n
.page.full.history\n
  %object.issuu\n
    %param{ name: "movie", value: src+"?"+mode }/\n
    %param{ name: "allowfullscreen", value: "true"}/\n
    %param{ name: "menu", value: "false"}/\n
    %param{ name: "wmode", value: "transparent"}/\n
    %embed{ allowfullscreen: "true", flashvars: mode, menu: "false", src: src,  type: "application/x-shockwave-flash", wmode: "transparent" }/'

