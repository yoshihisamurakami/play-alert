# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', -> 
  $('.stage-choice').on 'click', ->
    window.location.href = $(this).attr('data-choice')
    return false
  $('.star').on 'click', ->
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
