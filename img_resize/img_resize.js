var settings = {
  max_width: 900,
  max_height: 400
}


resize_image = function(img){
  var ctx = canvas.getContext("2d")
  var canvasCopy = document.createElement("canvas")
  var copyContext = canvasCopy.getContext("2d")
  var ratio = 1
  
  if(img.width > settings.max_width)
      ratio = settings.max_width / img.width
  else if(img.height > settings.max_height)
      ratio = settings.max_height / img.height

  canvasCopy.width = img.width
  canvasCopy.height = img.height
  copyContext.drawImage(img, 0, 0)

  canvas.width = img.width * ratio
  canvas.height = img.height * ratio
  ctx.drawImage(canvasCopy, 0, 0, canvasCopy.width, canvasCopy.height, 0, 0, canvas.width, canvas.height)
}

var canvas = document.createElement("canvas")

$(function(){

  document.body.appendChild(canvas)
  img = new Image()
  img.src = "/images/articles/4.png"
  document.body.appendChild(img)
  img.onload = function() {
    resize_image(this)
  }
  
  set_values = function(){
    $("input[name=max_width]").val(settings.max_width)
    $("input[name=max_height]").val(settings.max_height)
  }
  
  set_values()
  
  $("input").on("change", function(evt){
    settings.max_width = parseInt($("input[name=max_width]").val())
    settings.max_height = parseInt($("input[name=max_height]").val())
    resize_image(img)
    set_values()
  })
  
  $("input[type=submit]").on("click", function(){
    var download_mime = "image/octet-stream"
    var data_string = canvas.toDataURL("image/png")
    var data_string = data_string.replace("image/png", download_mime)
    document.location.href = data_string
  })
  
})

