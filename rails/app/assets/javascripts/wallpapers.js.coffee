# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.wallpaper-thumbnail-item').click ->
    $('#downloadDialog img').attr('src', $(this).find('img').attr('src'))
    $('#downloadDialog').modal('show')

$(document).ready(ready)
$(document).on('page:load', ready)