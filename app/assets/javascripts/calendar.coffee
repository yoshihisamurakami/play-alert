$(document).on 'turbolinks:load', ->
  if $('#calendar').html() == ''
    $('#calendar').fullCalendar(
      events:window.datas,
      lang: 'ja',
      height: window.innerHeight - 110,
    )