@rekrei.controller 'TabsController', ->
  @tab = 1

  @setTab = (setTab) ->
    @tab = setTab
    return

  @isTab = (checkTab) ->
    @tab == checkTab

  return
