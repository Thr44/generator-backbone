window.<%= _.camelize(appname) %> = new Backbone.App
  lang:"en"

  start: (options)->
    #test2.apiUrl="http://dev.bestiario.org/qfinance/"
    <%= _.camelize(appname) %>.router = new <%= _.camelize(appname) %>.Router
    Backbone.history.start()
    return

$ ->
  <%= _.camelize(appname) %>.run $('#content'), 
    forceDebug:true