# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  if $('#calendar').html() == ''
    $('#calendar').fullCalendar(
      events:window.datas,
      lang: 'ja',
      height: window.innerHeight - 110,
    )