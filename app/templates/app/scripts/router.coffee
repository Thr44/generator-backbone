class bestiario.Router extends Backbone.Router

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

  #guaranteeing that whichever route, this will run once:
  before_any: ->
    @once ||= _.once @composeLayout
    do @once

  composeLayout: ->
    log "set anything for composing layout here!"
    

    

