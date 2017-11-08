# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#calendar').fullCalendar(
    events:window.datas,
    lang: 'ja',
    minTime: "00:00:00",
    maxTime: "24:00:00",
  )