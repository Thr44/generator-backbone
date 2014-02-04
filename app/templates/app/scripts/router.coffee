class <%= _.camelize(appname) %>.Router extends Backbone.Router

  appViews:{}
  dataModels:{}
  enablePortrait: false

  routes:
    "example": 'example'
    'receiveArgsExample/:argument0': 'receiveArgsExample'
    '*path':'start' 

  example:->
    do @before_any
    console.log "I'm at example"

  receiveArgsExample:(argument0)->
    do @before_any
    log "argument0:", argument0

  start:->
    do @before_any
    console.log "I'm starting up...."

  before_any: =>
    @doOnce||=_.once @composeLayout
    do @doOnce

  composeLayout:()=>
    log "!!!!!!!!!!!!set anything for composing layout here!"
    

    

