# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  if $('#pages').val() != '' and $('#page_readed').html() == ''
    loading_page_on_historyback()
  $('#stagelist_area').on 'click', '.stage-choice', ->
    window.location.href = $(this).attr('data-choice')
  $('#stagelist_area').on 'click', '.star', ->
    if $(this).hasClass('glyphicon-star-empty')
      empty_to_star($(this))
    else
      star_to_empty($(this))
    return false
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
  #console.log("page => " + page)
  reading_json(page)
  $('#page_readed').html(page)
loading_page_on_historyback = ->
  #console.log('loading_page_on_historyback..')
  $('#loading').html('<img src="/img/loading.gif">')
  tmp_page = $('#pages').val()
  for page in [2..tmp_page]
    console.log("page(history.back) => " + page)
    reading_json(page)
    $('#page_readed').html(page)
reading_json = (page) ->
  LOADING_END_MARK = '●'
  $.getJSON("?type=json&page=" + page , (data) ->
    if data.length == 0
      $('#loading').html(LOADING_END_MARK)
      return false
    for i in [0..data.length-1]
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
  html = html + data[i].term + '<br>'
  html = html + data[i].theater + '&nbsp;&nbsp;'
  html = html + '</span>'
  html = html + '<a class="glyphicon icon-link star ' + data[i].glyphicon_star + '" href=""></a>'
  html = html + '#' + page + '#' + i + '#'
  html = html + '</div>'
  return html
