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
  setTimeout ->
    height = $("#img_gal").width() / 4 * 2.5
    $("#img_gal").height height
  , 10


  

# 

$(window).on "resize", ->
  gal_resize()

$ ->
  $(document).bind "change", (e) ->
    e.preventDefault()
    console.log e.target
    if ($(e.target).attr("name") == "antani")
      console.log $(e.target).val()
  # $(document).bind "drop", (e) ->  
  #   console.log e.target
  #   if ($(e.target).attr("name") == "antani")
  #     console.log "right1!!!"
  #     e.preventDefault()



######## 
# fiveapi

# $(document).ajaxSend (event, xhr, settings) ->
#   settings.xhrFields = { withCredentials: true }


unless window.console || console.log
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
  local = "new.riotvan.net"

hostz = "http://#{hostz}"
local = "http://#{local}"

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
        collaboratori: 4
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
    setTimeout ->
      get_elements()
    , 100
  
    $("body").on "page_js_loaded", ->
      get_elements()  
  
hamls = {}

singularize = (word) ->
  word.replace /s$/, ''

get_elements = ->
  get_article()  
  get_collection()  

get_article = ->
  article_id = fiveapi.article_from_page()
  if article_id
    fiveapi.get_article article_id, (article) ->
      got_article article_id, article

get_collection = ->
  coll_name = fiveapi.collection_from_page()
  if coll_name
    fiveapi.get_collection coll_name, (collection) ->
      got_collection coll_name, collection

load_haml = (view_name, callback) ->
  if hamls[view_name]
    callback hamls[view_name]
  else
    $.get "#{local}/views/#{view_name}.haml", (data) =>
      hamls[view_name] = data 
      callback hamls[view_name]

render_haml = (view_name, obj={}, callback) ->
  # TODO: cache request
  load_haml view_name, (view) =>
    html = haml.compileStringToJs(view) obj
    callback html

got_article = (id, article) ->
  view = "#{singularize article.collection}_article"
  render_haml view, article, (html) ->
    $(".fiveapi_element[data-type=article]").append html      
      
got_collection = (name, collection) ->                        
  _(collection).each (elem) ->                                
    render_haml name, elem, (html) ->                         
      $(".fiveapi_element[data-type=collection]").append html 


# helpers

haml.format_date = (date) ->
  date = new Date(date)
  date.getDay() + "/" + date.getMonth() + "/" + date.getFullYear()