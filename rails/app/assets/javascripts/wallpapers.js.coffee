# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.wallpaper-thumbnail-item').click ->
    url = $(this).find('.thumbnail_download_dialog_path').text()
    $('#download-dialog .wallpaper-download-container').load(url)
    $('#download-dialog').modal('show')

$(document).ready(ready)
$(document).on('page:load', ready)