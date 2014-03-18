window.ATT = new Backbone.App
  lang:"en"
  rootPath:"/"
  # Check lib/backbone.app.js.coffee for more info

  # fonts: [ 'Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic:latin' ]

  # analytics: 'UA-XXXXXXXX-X'


  start: (options)->
    #test2.apiUrl="http://dev.bestiario.org/qfinance/"
    ATT.router = new ATT.Router
    Backbone.history.start
      pushState: true
    return

$ ->
  ATT.run $('#content'), 
    forceDebug:true