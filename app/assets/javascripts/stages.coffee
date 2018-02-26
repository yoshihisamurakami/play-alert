# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  # 方法1 *** iphone chromeで #pages が消えるので却下
  #if $('#pages').val() != '' and $('#page_readed').html() == ''
  #  loading_page_on_historyback()
  # 方法2
  #page = location.href.match(/\#([0-9]+)$/)
  #if page != null
  #  alert(page[1])
    #console.log('戻るボタンが押された ' + page[1] )
    #loading_page_on_historyback(page[1])
  current_scrollY = 0
  $('#stagelist_area').on 'click', '.stage-choice', ->
    $('#popup').css('display', 'block')
    $("body").css('overflow', 'hidden')
    current_scrollY = $(window).scrollTop()
    $("body").css('position', 'fixed')
    get_stageinfo($(this))
    #window.location.href = $(this).attr('data-choice')
    
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
    
  $('#usermenu_dropdown').on 'click', ->
    if $('#user_menu').css('display') == 'none'
      $('#user_menu').css('display', 'block')
    else
      $('#user_menu').css('display', 'none')
  $(document).on 'click', ->
    if (!$(event.target).closest('#usermenu_dropdown').length) and (!$(event.target).closest('#user_menu').length)
      if $('#user_menu').css('display') == 'block'
        $('#user_menu').css('display', 'none')

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
    scrolled_to_bottom(obj)
)

scrolled_to_bottom = (obj) ->
  if $('#loading').html() == ''
    loading_page()

loading_page = ->
  $('#loading').html('<img src="/img/loading.gif">')
  page = get_pageno()
  reading_json(page)
  $('#page_readed').html(page)
  #history.replaceState('state', '', '#' + page)

loading_page_on_historyback = (tmp_page) ->
  $('#loading').html('<img src="/img/loading.gif">')
  for page in [2..tmp_page]
    reading_json(page)
    $('#page_readed').html(page)

reading_json = (page) ->
  LOADING_END_MARK = '●'
  $.getJSON("?type=json&page=" + page, (data) ->
    if data.length == 0
      $('#loading').html(LOADING_END_MARK)
      return false
    for i in [0..data.length-1]
      lastdate = $('.stagelist-title:last').attr('data-startdate')
      if lastdate != data[i].startdate
        html = get_stagelist_title(data,i)
        $('#stagelist_area').append(html)
      if $('div[stage-id="' + data[i].id + '"]').length == 0
        $('#stagelist_area').append(get_stage_html(data,i,page))
    $('#pages').val(page)
    if data.length < 20
      $('#loading').html(LOADING_END_MARK)
      return false
    $('#loading').html('')
  )

get_pageno = ->
  if $('#pages').val() == ''
    return 2
  else
    return parseInt($('#pages').val()) + parseInt(1)

get_stage_html = (data,i,page) ->
  html = '<div class="stage-choice" data-choice="' + data[i].url + '" stage-id="' + data[i].id + '">'
  html = html + '<span class="stage-title">'+data[i].title+'</span>&nbsp;&nbsp;'
  html = html + '<span class="stage-group">'+data[i].group+'</span><br>'
  html = html + '<span class="stage-detail">'
  html = html + '<span class="stage-term">' + data[i].term + '</span><br>'
  html = html + '<span class="stage-theater">' + data[i].theater + '</span>&nbsp;&nbsp;'
  html = html + '</span>'
  html = html + '<a class="glyphicon icon-link star ' + data[i].glyphicon_star + '" href=""></a>'
  # html = html + '#' + page + '#' + i + '#'
  html = html + '</div>'
  return html

get_stagelist_title = (data,i) ->
  title_class = ''
  if location.href.match(/playing/)
    title_class = ' nowplaying'
  else if location.href.match(/later/)
    title_class = ' later'
  html = '<div class="stagelist-title' + title_class + '" data-startdate="' + data[i].startdate + '">'
  html = html + data[i].startdatej
  html = html + '<span class="stagelist-tilde">〜</span>'
  html = html + '</div>'

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
  return """
<div class="detail-title">#{title}</div>
<div class="detail-content">#{str}</div>
"""

get_stagedetail_link_html = (title, str) ->
  return """
<div class="detail-title">#{title}</div>
<div class="detail-content"><a href="#{str}" target="_blank">#{str}</a></div>
"""