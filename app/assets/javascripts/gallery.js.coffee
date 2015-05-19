$(document).on "page:change", ->
  if $('#gallery').length > 0
    $.ajax(url: "https://api.sketchfab.com/v2/models?tags=projectmosul").done (data) ->
      for model in data['results']
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