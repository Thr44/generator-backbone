window.<%= _.camelize(appname) %> = new Backbone.App
  lang:"en"
  rootPath:"/"
  # Check lib/backbone.app.js.coffee for more info

  # fonts: [ 'Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic:latin' ]

  # analytics: 'UA-XXXXXXXX-X'


  start: (options)->
    #test2.apiUrl="http://dev.bestiario.org/qfinance/"
    <%= _.camelize(appname) %>.router = new <%= _.camelize(appname) %>.Router
    Backbone.history.start
      pushState: true
    return

$ ->
  <%= _.camelize(appname) %>.run $('#content'), 
    forceDebug:true