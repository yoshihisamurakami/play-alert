# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', -> 
  #$('.stage-choice').on 'click', ->
  #  url = $(this).attr('data-choice')
  #  window.location.href = url
  $('.star').on 'click', ->
    if $(this).hasClass('glyphicon-star-empty')
      $(this).removeClass('glyphicon-star-empty')
      $(this).addClass('glyphicon-star')
      $(this).css('color', '#FFC700')
    else
      $(this).removeClass('glyphicon-star')
      $(this).addClass('glyphicon-star-empty')
      $(this).css('color', '#888')
    return false
  $('.icon-link-mail').on 'click', (e) ->
    $('#popup').css('display','block')
    $('#popup-title').html($(this).parent().attr('stage-title'))
    $('#popup-group').html($(this).parent().attr('stage-group'))
    
    #url = $(this).parent().attr('data-choice')
    #window.location.href = url
    return false
  $('.close_overlay').on 'click', ->
    $('#popup').css('display','none')
    return false
  $('.popup-close').on 'click', ->
    $('#popup').css('display','none')
    return false