# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  current_scrollY = 0
  $('#stagelist_area').on 'click', '.stage-choice', ->
    $('#popup').css('display', 'block')
    $("body").css('overflow', 'hidden')
    current_scrollY = $(window).scrollTop()
    $("body").css('position', 'fixed')
    get_stageinfo($(this))
    
  $('#stagelist_area').on 'click', '.star', ->
    if $(this).hasClass('glyphicon-star-empty')
      empty_to_star($(this))
    else
      star_to_empty($(this))
    return false
    
  $('.popup-close').on 'click', ->
    $('#popup').css('display', 'none')
    $('#popup-detail').html('')
    $("body").css('overflow', 'auto')
    $("body").css('position', 'static')
    $(window).scrollTop(current_scrollY)
    
  # $('#usermenu_dropdown').on 'click', ->
  #   if $('#user_menu').css('display') == 'none'
  #     $('#user_menu').css('display', 'block')
  #   else
  #     $('#user_menu').css('display', 'none')
      
  # $(document).on 'click', ->
  #   if (!$(event.target).closest('#usermenu_dropdown').length) and (!$(event.target).closest('#user_menu').length)
  #     if $('#user_menu').css('display') == 'block'
  #       $('#user_menu').css('display', 'none')
        
  $('.stagenavi-later').on 'click', ->
    if $('.later-list').css('display') == 'none'
      $('.later-list').css('display', 'block')
    else
      $('.later-list').css('display', 'none')
    return false
  $('.pagetop').on 'click', ->
    $('body,html').animate({
      scrollTop: 0}
    ,500);
    return false;
    
empty_to_star = (obj)->
  obj.removeClass('glyphicon-star-empty').addClass('glyphicon-star')
  id = obj.parent().attr('stage-id')
  $.get '/stars/set/' + id, (data) ->
    if data.result != 'OK'
      alert('ERROR')

star_to_empty = (obj)->
  obj.removeClass('glyphicon-star').addClass('glyphicon-star-empty')
  obj.css('color','#888')
  id = obj.parent().attr('stage-id')
  $.get '/stars/unset/' + id, (data) ->
    if data.result != 'OK'
      alert('ERROR')

$(window).bind("scroll", ->
  scrollHeight = $(document).height()
  scrollPosition = $(window).height() + $(window).scrollTop()
  obj = $(this)

  if ((scrollHeight - scrollPosition) / scrollHeight <= 0.05)
    scrolled_to_bottom()
  if $(this).scrollTop() > 160
   $(".pagetop").fadeIn()
  if $(this).scrollTop() <= 160
   $(".pagetop").fadeOut()
)

scrolled_to_bottom = ->
  if $('#loading').html() != ''
    return

  loading.loading()
  res = append_nextpage()
  if res == false
    loading.error()
    
class loading
  @LOADING_END_MARK = '●'
  
  @loading: () ->
    $('#loading').html('<img src="/img/loading.gif">')
    
  @end: () ->
    $('#loading').html(this.LOADING_END_MARK)
    
  @clear: () ->
    $('#loading').html('')

  @error: () ->
    $('#loading').html('エラーが発生しました')

class pages
  @get: () ->
    if $('#pages').val() == ''
      1
    else
      parseInt($('#pages').val())

  @get_next: () ->
    this.get() + parseInt(1)
    
  @set: (page) ->
    $('#pages').val(page)

class stages_list
  constructor: (@param) ->
    @stages = @param
    
  size: () ->
    @stages.length

  json_to_html: (@page) ->
    if this.size() == 0
      loading.end()
      return false
    for i in [0..@stages.length-1]
      _append_startdate_label.call @, @stages[i]
      _append_stage_info.call @, @stages[i]
      
    pages.set(@page)
    
    if this.size < 20
      loading.end()
      return false
      
    loading.clear()

  _append_startdate_label = (stage) ->
    lastdate = $('.stagelist-title:last').attr('data-startdate')
    if lastdate != stage.startdate
      html = _startdate_label_html.call @, stage
      $('#stagelist_area').append(html)
      
  _append_stage_info = (stage) ->
    if $('div[stage-id="' + stage.id + '"]').length == 0
      html = _stage_html.call @, stage
      $('#stagelist_area').append(html)
    
  _startdate_title_class = () ->
    if location.href.match(/playing/)
      'nowplaying'
    else if location.href.match(/later/)
      'later'
    else
      ''

  _startdate_label_html = (stage) ->
    title_class = _startdate_title_class.call @
    """
<div class="stagelist-title #{title_class}" data-startdate="#{stage.startdate}">
  #{stage.startdatej} <span class="stagelist-tilde">〜</span>
</div>
    """

  _stage_html = (stage) ->
    """
<div class="stage-choice" data-choice=#{stage.url}" stage-id="#{stage.id}">
  <span class="stage-title">#{stage.title}</span>&nbsp;&nbsp;
  <span class="stage-group">#{stage.group}</span><br>
  <span class="stage-detail">
    <span class="stage-term">#{stage.term}</span><br>
    <span class="stage-theater">#{stage.theater}</span>&nbsp;&nbsp;
  </span>
  <a class="glyphicon icon-link star #{stage.glyphicon_star}"></a>
</div>
    """

append_nextpage = ->
  page = pages.get_next()
  json_url = get_json_url(page)
  if json_url == false
    false
  
  $.getJSON(json_url, (data) ->
    stages = new stages_list(data)
    stages.json_to_html(page)
  )

get_json_url = (page) ->
  if m = location.pathname.match(/\/stages\/(playing|thisweek)/)
    "/stages/json/" + m[1] + "?page=" + page
  else if location.pathname.match(/\/stages\/later/)
    if m = location.search.match(/\?start=(\d{8})/)
      "/stages/json/later?start=" + m[1] + "&page=" + page
    else
      false
  else if location.pathname == '/'
    "/stages/json/thisweek?page=" + page
  else
    console.log("not match " + location.pathname)
    false

get_stageinfo = (obj) ->
  title = obj.children('.stage-title').html()
  group = obj.children('.stage-group').html()
  term  = obj.children('.stage-detail').children('.stage-term').html()
  theater = obj.children('.stage-detail').children('.stage-theater').html()
  $('#popup-title').html(title)
  $('#popup-group').html(group)
  $('#popup-term').html(term)
  $('#popup-theater').html(theater)
  $('#popup-detail').html('<div style="text-align: center; margin-top:3em;"><img src="/img/loading.gif"></div>')
  $('.popup-bottom').css('display', 'none')
  
  $.getJSON('/stages/detail/' + obj.attr('stage-id'), (data) ->
    $('#popup-detail').html('')
    if data.status == "notfound"
      $('.popup-bottom').css('display', 'block')
      return

    if data.playwright != ''
      $('#popup-detail').append( get_stagedetail_html('脚本', data.playwright))
    if data.director != ''
      $('#popup-detail').append( get_stagedetail_html('演出', data.director))
    if data.cast != ''
      $('#popup-detail').append( get_stagedetail_html('出演', data.cast))
    if data.price != ''
      $('#popup-detail').append( get_stagedetail_html('チケット', data.price))
    if data.timetable != ''
      $('#popup-detail').append( get_stagedetail_html('タイムテーブル', data.timetable))
    if data.site != ''
      $('#popup-detail').append( get_stagedetail_link_html('公式サイト', data.site))
    if $("#popup-stagelink")[0]
      $("#popup-stagelink").attr("href", "/stages/" + obj.attr('stage-id'))
    $('.popup-bottom').css('display', 'block')
  )

get_stagedetail_html = (title, str) ->
  """
<div class="detail-title">#{title}</div>
<div class="detail-content">#{str}</div>
"""

get_stagedetail_link_html = (title, str) ->
  """
<div class="detail-title">#{title}</div>
<div class="detail-content"><a href="#{str}" target="_blank">#{str}</a></div>
"""