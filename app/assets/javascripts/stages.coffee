# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', -> 
  $('.stage-choice').on 'click', ->
    url = $(this).attr('data-choice')
    window.location.href = url
  $('.popup-help-info').on 'click', ->
    if $("#help-info").css('display') == 'none'
      $("#help-info").fadeIn("slow");
    else
      $("#help-info").css('display', 'none')
  $('#help-info').on 'click', ->
    $("#help-info").css('display', 'none')