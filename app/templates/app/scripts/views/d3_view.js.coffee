
###
to load data, use a collection or model and extend the parse method!
example: (requires d3!)

  parse:(data, xhr)=>
    rawData=d3.csv.parse(data)
    source = []
    for rawItem in rawData
      item = new @model rawItem
      source.push(item)
    return source

###

class Backbone.d3View extends Backbone.ElementView

  init: ->

  modelDidChange:->
    log "model did change"

  modelDidDestroy: ->

  viewWillRender: ->

  viewDidRender: ->

  viewWillRemove: ->

  viewDidRemove: ->

  viewWillUpdate: ->

  viewDidUpdate:->

  initialize: (options = {})->
    do @_methodBinding
    _.bindAll(this, "viewWillUpdate", "viewDidUpdate", "_viewUpdate")

    @rendered = false
    options.binding = @binding = true
    if options.binding and @model?
      @model.on 'change', @_modelWillChange, this
      @model.on 'destroy', @_modelWillDestroy, this
    @init options

    @isTouchable = Modernizr.touch

  _modelWillChange: ->
    do @modelDidChange
    if not @rendered?
      do @render
    else
      do @_viewUpdate

  _viewUpdate:->
    do @viewWillUpdate
    _.defer(@viewDidUpdate)


  render: ->
    throw new Error "Template must be defined" unless (@template? and _.isFunction(@template))
    @templateData = {}

    if not @rendered
      do @_firstRender

      do @viewWillRender
      log @templateData

      do @_serializeData

      template = do @_chooseTemplate

      @$el.html( template( @templateData ) )

      if not @$el.attr('id')? and @idRoot?
        id = @idRoot + (@model.id or @model.cid)
        @$el.attr id: id

      _.defer(@_finishRender)
      this
    else
      do @viewWillUpdate

      _.defer(@viewDidUpdate)

      this
