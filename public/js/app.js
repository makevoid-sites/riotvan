(function() {
  var articles_per_page, box_images, cur_idx, fb_init, fb_setup, g, gal_anim, gal_build, gal_resize, get_article, get_collection, get_elements, got_article, got_collection, hamls, hostz, inject_spinner, lightbox, load_haml, local, markup, picasa_init, puts, render_external_markdown, render_haml, render_markdown, render_markup, render_pagination, resize_issuu, restore_gal, set_home_height, singularize, srvstatus, titles, track_page, write_images, write_openzoom, write_picasa_images, write_videos,
    _this = this;

  g = window;

  inject_spinner = function() {
    var elements;
    elements = $(".fiveapi_element[data-type=collection],.fiveapi_element[data-type=article],.external_markdown");
    if (elements.html() !== "") {
      return;
    }
    elements.css({
      width: "100%",
      display: "block"
    });
    return elements.html("<img src='/images/spinner.gif' class='spinner'>");
  };

  render_markup = function() {
    var elements;
    elements = $(".fiveapi_element[data-type=article]");
    return elements.each(function(idx, element) {
      var article, html, images, text, text_elem;
      text_elem = $(element).find(".text");
      images = text_elem.data("images");
      if (!images) {
        return;
      }
      text = text_elem.data("text");
      article = {
        images: images,
        text: text_elem.html()
      };
      html = markup(article);
      return text_elem.html(html);
    });
  };

  $(function() {
    inject_spinner();
    return render_markup();
  });

  srvstatus = function() {
    return $.ajax({
      url: "http://localhost:3000",
      success: function(data) {
        if (data === "OK") {
          return $(".srvstatus").addClass("open");
        }
      },
      error: function() {}
    });
  };

  lightbox = function() {
    var time, _i, _len, _ref;
    $(".lightbox").remove();
    $("html").prepend("<div class='lightbox'></div><div class='clear'></div>");
    _ref = [0, 200, 500, 1000, 2000, 6000];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      time = _ref[_i];
      setTimeout(function() {
        return lightbox.resize();
      }, time);
    }
    return $(window).on("resize", function() {
      return lightbox.resize();
    });
  };

  lightbox.show = function(url) {
    $(".lightbox").on("click", function() {
      return lightbox.close();
    });
    $(".lightbox").append("<img src='" + url + "' />");
    return $(".lightbox img").on("load", function() {
      var width;
      $(".lightbox").css({
        display: "block"
      });
      width = lightbox.image_width();
      return $(".lightbox img").css({
        width: width
      }).css({
        top: $(document).scrollTop()
      });
    });
  };

  lightbox.resize = function() {
    var height, wheight;
    height = $("html").height();
    wheight = $(window).height();
    height = Math.max(height, wheight);
    return $(".lightbox").height(height);
  };

  lightbox.close = function() {
    return $(".lightbox").hide();
  };

  lightbox.image_width = function() {
    var height, page_height, ratio, width;
    page_height = $(window).height() - parseInt($(".lightbox img").css("marginTop")) * 2;
    width = $(".lightbox img").width();
    height = $(".lightbox img").height();
    ratio = width / height;
    height = Math.min(page_height, height);
    return height * ratio;
  };

  write_picasa_images = function(text) {
    var album_id, match, matches, regex, _i, _len;
    matches = text.match(/\[picasa_(\d+)\]/g);
    if (matches) {
      for (_i = 0, _len = matches.length; _i < _len; _i++) {
        match = matches[_i];
        album_id = match.match(/\[picasa_(\d+)\]/)[1];
        picasa_init(album_id);
      }
      regex = new RegExp("\\[picasa_(" + album_id + ")\\]");
      text = text.replace(regex, "<div class='picasa_gallery' data-album_id='$1'></div>");
    }
    return text;
  };

  picasa_init = function(album_id) {
    var thumb_size, url;
    url = "http://picasaweb.google.com/data/feed/api/user/redazioneriotvan@gmail.com/albumid/" + album_id + "?alt=json&fields=entry(title,gphoto:numphotos,media:group(media:content,media:thumbnail))&imgmax=1280&callback=?";
    thumb_size = 1;
    return $.getJSON(url, function(data) {
      var gal, group, photo, photos, thumb_url, _i, _len;
      photos = data.feed.entry;
      gal = $(".picasa_gallery");
      for (_i = 0, _len = photos.length; _i < _len; _i++) {
        photo = photos[_i];
        group = photo.media$group;
        thumb_url = group.media$thumbnail[thumb_size].url;
        url = group.media$content[0].url;
        gal.append("<div class='imgbox'><img src='" + thumb_url + "' data-url='" + url + "' /></div>");
      }
      lightbox();
      return $(".picasa_gallery .imgbox").on("click", function() {
        url = $(this).find("img").data("url");
        lightbox();
        return lightbox.show(url);
      });
    });
  };

  fb_init = function() {
    if (typeof FB === "object") {
      return FB.init({
        appId: "333539793359620",
        channelUrl: "http://riotvan.net/channel.html",
        status: true,
        cookie: true,
        xfbml: true
      });
    } else {
      return setTimeout(function() {
        return fb_init();
      }, 300);
    }
  };

  g.fb_init = fb_init;

  fb_setup = function() {
    return (function(d) {
      var id, js, ref;
      js = void 0;
      id = "facebook-jssdk";
      ref = d.getElementsByTagName("script")[0];
      if (d.getElementById(id)) {
        return;
      }
      js = d.createElement("script");
      js.id = id;
      js.async = true;
      js.src = "//connect.facebook.net/en_US/all.js";
      return ref.parentNode.insertBefore(js, ref);
    })(document);
  };

  $(function() {
    fb_setup();
    resize_issuu();
    if ($(".issuu").length > 0) {
      return $(window).on("resize", function() {
        return resize_issuu();
      });
    }
  });

  $(function() {
    setTimeout(function() {
      return resize_issuu();
    }, 200);
    if ($(".issuu").length > 0) {
      return $(window).on("resize", function() {
        return resize_issuu();
      });
    }
  });

  track_page = function() {
    var page;
    page = location.pathname.slice(1);
    return _gaq.push("_trackEvent", "Pages", "visit", page);
  };

  box_images = function() {
    return $(".article, .event").each(function(idx, article) {
      var img, link,
        _this = this;
      article = $(article);
      link = article.find("h2 a").attr("href") || article.find("h3 a").attr("href");
      img = article.find("img");
      img.wrap("<div class='img_box'></div>");
      if (link) {
        img.wrap("<a href='" + link + "'></a>");
      }
      return img.imagesLoaded(function() {
        return article.find(".img_box").height(img.height());
      });
    });
  };

  resize_issuu = function() {
    var height, iss_height, page_margin, top_margin;
    if ($(".issuu").length > 0) {
      top_margin = 20;
      page_margin = 15;
      height = $("header").height() + top_margin + page_margin * 2;
      iss_height = $(window).height() - height;
      return $(".issuu, .issuu embed").height(iss_height);
    }
  };

  restore_gal = function() {
    $("#img_gal img").css("opacity", 0);
    return $("#img_gal img:first-child").css("opacity", 1);
  };

  cur_idx = 0;

  titles = [];

  set_home_height = function() {
    var height;
    height = $("#content").height();
    return $(".right").css({
      height: height
    });
  };

  gal_build = function() {
    var article, image, images, img, _i, _len;
    if (!(this.collection && this.collection[0]["collection"] === "articoli")) {
      return;
    }
    images = (function() {
      var _i, _len, _ref, _results;
      _ref = this.collection;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        article = _ref[_i];
        img = article.images[0];
        if (img) {
          img.title = article.title;
        }
        _results.push(img);
      }
      return _results;
    }).call(this);
    images = _(images).compact();
    $("#img_gal img").remove();
    titles = [];
    for (_i = 0, _len = images.length; _i < _len; _i++) {
      image = images[_i];
      titles.push(image.title);
      $("#img_gal").append("<img src='" + hostz + image.url + "'>");
      $("#img_gal img").css({
        opacity: 0
      });
      $("#img_gal img:first").css({
        opacity: 1
      });
    }
    return $(".caption").html(titles[cur_idx]);
  };

  gal_anim = function() {
    var time,
      _this = this;
    time = 5000;
    if ($("#img_gal img").length < 1) {
      gal_build();
    }
    return setTimeout(function() {
      var cond, images, next_idx;
      images = _($("#img_gal img")).map(function(el) {
        return el;
      });
      cond = cur_idx >= images.length - 1;
      next_idx = cond ? 0 : cur_idx + 1;
      $(".caption").html(titles[next_idx]);
      $(images[cur_idx]).css("opacity", 0);
      $(images[next_idx]).css("opacity", 1);
      cur_idx = cond ? 0 : cur_idx + 1;
      return gal_anim();
    }, time);
  };

  gal_resize = function() {
    return setTimeout(function() {
      var height;
      height = $("#img_gal").width() / 4 * 2.5;
      return $("#img_gal").height(height);
    }, 10);
  };

  $(window).on("resize", function() {
    return gal_resize();
  });

  if (!(window.console && console.log)) {
    window.console = {};
    console.log = function() {};
  }

  puts = console.log;

  if (location.hostname === "localhost") {
    hostz = "localhost:3000";
    local = "localhost:3001";
  } else {
    hostz = "fiveapi.com";
    local = "riotvan.net";
  }

  hostz = "http://" + hostz;

  local = "http://" + local;

  haml.host = local;

  articles_per_page = 5;

  $(function() {
    srvstatus();
    return $.get("" + hostz + "/fiveapi.js", function(data) {
      var configs;
      eval(data);
      configs = {
        user: "makevoid",
        project: {
          riotvan: 1
        },
        collections: {
          articoli: 1,
          eventi: 2,
          chi_siamo: 3,
          collaboratori: 4,
          video: 5
        }
      };
      window.fiveapi = new Fiveapi(configs);
      fiveapi.activate();
      render_markdown();
      render_external_markdown();
      fb_init();
      set_home_height();
      setTimeout(function() {
        return get_elements();
      }, 100);
      return $("body").on("got_collection", function() {
        gal_anim();
        gal_resize();
        set_home_height();
        return box_images();
      });
    });
  });

  hamls = {};

  render_external_markdown = function() {
    return $(".external_markdown").each(function(idx, elem) {
      var view_name,
        _this = this;
      view_name = $(elem).data("name");
      return $.get("" + local + "/views/" + view_name + ".md", function(data) {
        var html, mark;
        mark = data;
        html = markdown.toHTML(mark);
        return $(elem).html(html);
      });
    });
  };

  render_markdown = function() {
    return $(".md").each(function(idx, elem) {
      var html, mark;
      mark = $(elem).html();
      html = markdown.toHTML(mark);
      return $(elem).html(html);
    });
  };

  write_images = function(obj) {
    var image, regex, _i, _len, _ref;
    _ref = obj.images;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      image = _ref[_i];
      regex = new RegExp("\\[(image|file)_" + image.id + "\\]");
      obj.text = obj.text.replace(regex, "![](" + hostz + image.url + ")");
    }
    return obj;
  };

  write_videos = function(text) {
    return text.replace(/\[youtube_(.+)\]/, "<iframe src='http://www.youtube.com/embed/$1' allowfullscreen></iframe>");
  };

  write_openzoom = function(text) {
    return text.replace(/\[openzoom_(.+)\]/m, '<object type="application/x-shockwave-flash" data="/openzoom/viewer.swf" width="100%" height="600px" name="viewer">\
      <param name="scale" value="noscale" />\
      <param name="bgcolor" value="#FFFFFF" />\
      <param name="allowfullscreen" value="true" />\
      <param name="allowscriptaccess" value="always" />\
      <param name="flashvars" value="source=/openzoom/$1.dzi" />\
  </object>');
  };

  markup = function(obj) {
    var text;
    obj = write_images(obj);
    text = markdown.toHTML(obj.text);
    text = write_openzoom(text);
    text = write_videos(text);
    return write_picasa_images(text);
  };

  singularize = function(word) {
    if (word) {
      return word.replace(/s$/, '');
    }
  };

  get_elements = function() {
    var filters, per_page;
    get_article();
    per_page = location.pathname === "/chi_siamo" || location.pathname === "/collabs" ? 50 : articles_per_page;
    filters = {
      limit: per_page,
      offset: 0
    };
    return get_collection(filters);
  };

  render_pagination = function(pag) {
    var current_page, i, pages_view, pagination, total_pages;
    total_pages = pag["entries_count"] / pag["limit"];
    current_page = pag["offset"] * pag["limit"];
    pages_view = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 1; 1 <= total_pages ? _i <= total_pages : _i >= total_pages; i = 1 <= total_pages ? ++_i : --_i) {
        _results.push("<a>" + i + "</a>");
      }
      return _results;
    })();
    pagination = "    " + (pages_view.join(" ")) + "  ";
    $(".pagination[data-collection=" + pag["collection"] + "]").html(pagination);
    return $(".pagination[data-collection=" + pag["collection"] + "] a").on("click", function() {
      var limit, page;
      page = $(this).html() - 1;
      limit = articles_per_page;
      return get_collection({
        limit: limit,
        offset: limit * page
      });
    });
  };

  get_article = function() {
    var article_id;
    if (location.pathname.match(/\/articoli/)) {
      return;
    }
    article_id = fiveapi.article_from_page();
    if (article_id) {
      return fiveapi.get_article(article_id, function(article) {
        return got_article(article_id, article);
      });
    }
  };

  get_collection = function(filters) {
    var coll_name;
    if (filters == null) {
      filters = {};
    }
    coll_name = fiveapi.collection_from_page();
    if (coll_name) {
      return fiveapi.get_collection(coll_name, filters, function(collection) {
        if (location.pathname === "/chi_siamo") {
          collection["articles"] = _(collection["articles"]).shuffle();
        }
        filters.entries_count = collection["count"];
        filters.collection = coll_name;
        render_pagination(filters);
        return got_collection(coll_name, collection["articles"]);
      });
    }
  };

  load_haml = function(view_name, callback) {
    var _this = this;
    if (hamls[view_name]) {
      return callback(hamls[view_name]);
    } else {
      return $.get("" + local + "/views/" + view_name + ".haml", function(data) {
        hamls[view_name] = data;
        return callback(hamls[view_name]);
      });
    }
  };

  render_haml = function(view_name, obj, callback) {
    var _this = this;
    if (obj == null) {
      obj = {};
    }
    obj.text = markup(obj);
    return load_haml(view_name, function(view) {
      var html;
      html = haml.compileStringToJs(view)(obj);
      return callback(html);
    });
  };

  got_article = function(id, article) {
    var view;
    if (article.collection) {
      view = "" + (singularize(article.collection)) + "_article";
      return render_haml(view, article, function(html) {
        $(".fiveapi_element[data-type=article]").html(html);
        return $("body").trigger("got_article");
      });
    } else {
      return console.log("Error: " + article.error);
    }
  };

  g.cur_collection = [];

  got_collection = function(name, collection) {
    var coll_temp, collection_elem,
      _this = this;
    collection_elem = $(".fiveapi_element[data-type=collection]");
    collection_elem.html("");
    this.collection = collection;
    coll_temp = [];
    return _(collection).each(function(elem, idx) {
      return render_haml(name, elem, function(html) {
        coll_temp[idx] = html;
        if (_(coll_temp).compact().length === collection.length) {
          collection_elem.append(coll_temp.join("\n"));
          $(collection_elem).css({
            opacity: 0
          });
          $(collection_elem).animate({
            opacity: 1
          }, 200);
          return $("body").trigger("got_collection");
        }
      });
    });
  };

  haml.location_article_id = function(location) {
    return _(location.pathname.split("/")).reverse()[0].split("-")[0];
  };

  haml.format_date = function(date) {
    date = new Date(date);
    return "" + (date.getDate()) + "/" + (date.getMonth() + 1) + "/" + (date.getFullYear());
  };

  haml.article_preview = function(text) {
    var max_length, txt;
    text = text.replace(/\[picasa_(\d+)\]/, '');
    max_length = 520;
    if (text.length > max_length) {
      txt = text.split(/\[(file|image)_\d+\]/)[1];
      if (txt) {
        text = txt;
      }
      return "" + (text.substring(0, max_length)) + "...";
    } else {
      return text;
    }
  };

}).call(this);
