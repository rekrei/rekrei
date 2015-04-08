ready = ->
  if $('.dropzone').length > 0
    Dropzone.autoDiscover = false
    dropzone = new Dropzone('.dropzone',
      maxFilesize: 500
      paramName: 'image[image]'
      addRemoveLinks: true
      uploadMultiple: false
      clickable: true)

$(document).ready(ready)
$(document).on('page:load', ready)