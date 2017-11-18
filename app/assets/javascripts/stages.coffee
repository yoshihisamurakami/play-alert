# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', -> 
  $('.stage-choice').on 'click', ->
    url = $(this).attr('data-choice')
    window.location.href = url
  $('.star').on 'click', ->
    #alert($(this).parent().attr('stage-id'))
    if $(this).hasClass('glyphicon-star-empty')
      $(this).removeClass('glyphicon-star-empty')
      $(this).addClass('glyphicon-star')
      $(this).css('color', 'yellow')
    else
      $(this).removeClass('glyphicon-star')
      $(this).addClass('glyphicon-star-empty')
      $(this).css('color', '#888')
    return false
