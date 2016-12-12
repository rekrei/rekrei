nextUrl = ''
prevUrl = ''
getUrl = (url) ->
  $.getJSON(url,
    callback: ''
    jsonp: ''
    format: 'json').done (data) ->
      if data.next
        $('#nextBtn').prop 'disabled', false
        nextUrl = data.next
      else
        $('#nextBtn').prop 'disabled', true
      if data.previous
        prevUrl = data.previous
        $('#prevBtn').prop 'disabled', false
      else
        $('#prevBtn').prop 'disabled', true
      displayData(data)
      return
nextPage = ->
  $('#gallery').empty()
  getUrl(nextUrl)
prevPage = ->
  $('#gallery').empty()
  getUrl(prevUrl)
displayData = (data) ->
  $.each data.results, (i, model) ->
    unless model.isPrintable == true
      width = 320
      height = 240
      html = """
      <div class="col-md-4 sketchfab-gallery-item">
      <iframe width="#{width}" height="#{height}" src="https://sketchfab.com/models/#{model['uid']}/embed" frameborder="0" allowfullscreen mozallowfullscreen="true" webkitallowfullscreen="true" onmousewheel=""></iframe>
      <p style="font-size: 13px; font-weight: normal; margin: 5px; color: #4A4A4A;">
        <a href="https://sketchfab.com/models/#{model['uid']}?utm_source=oembed&utm_medium=embed&utm_campaign=#{model['uid']}" target="_blank" style="font-weight: bold; color: #1CAAD9;">#{model['name']}</a>
        by <a href="https://sketchfab.com/#{model['user']['username']}?utm_source=oembed&utm_medium=embed&utm_campaign=#{model['uid']}" target="_blank" style="font-weight: bold; color: #1CAAD9;">#{model['user']['username']}</a>
        on <a href="https://sketchfab.com?utm_source=oembed&utm_medium=embed&utm_campaign=#{model['uid']}" target="_blank" style="font-weight: bold; color: #1CAAD9;">Sketchfab</a>
      </p>
      </div>
      """
      $('#gallery').append html
      return
    return
  return

ready = ->
  $('#nextBtn').prop 'disabled', true
  $('#nextBtn').click(nextPage)
  $('#prevBtn').prop 'disabled', true
  $('#prevBtn').click(prevPage)
  getUrl('https://api.sketchfab.com/v3/search?type=models&tags=projectmosul&sort_by=-publishedAt')

$(document).ready(ready)
$(document).on('page:load', ready)
