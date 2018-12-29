$(document).on 'turbolinks:load', ->
  if $('#calendar').html() == ''
    $('#calendar').fullCalendar(
      events:window.data,
      lang: 'ja',
      height: window.innerHeight - 60,
      views:
        month:
          titleFormat: 'YYYY.MM'
      header:
        left: 'prev'
        center: 'title'
        right: 'next'
    )