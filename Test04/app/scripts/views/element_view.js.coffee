class Backbone.ElementView extends Backbone.View

  
   
  init: ->

  modelDidChange:->

  modelDidDestroy: ->

  viewWillRender: ->
    
  viewDidRender: ->

  viewWillRemove: ->

  viewDidRemove: ->

  disableLink: (e)->
    do e.preventDefault
    do e.stopPropagation

  # private methods

  initialize: (options = {})->
    do @_methodBinding
    @rendered = false
    @binding = options.binding
    if options.binding and @model?
      @model.on 'change', @_modelWillChange, this
      @model.on 'destroy', @_modelWillDestroy, this
    @init options

    @isTouchable = Modernizr.touch
      
  _methodBinding: ->
    _.bindAll(this, "render", "_finishRender", "viewDidRender", "modelDidChange", "modelDidDestroy", '_serializeData', '_checkDeviceType', 'viewWillRemove', 'viewDidRemove')

  _modelWillChange: ->
    do @modelDidChange
    do @render
  
  _modelWillDestroy: ->
    do @modelDidDestroy
    do @remove
    this

  _serializeData: ->
    data = {}
    data.models = @collection.toJSON() if @collection?
    data.model = @model.toJSON() if @model?
    _.defaults(@templateData, data)
    @templateData

  _firstRender: ->
    
    if _.isFunction @resize 
      _.bindAll this, 'resize'
      $(window).on 'resize', @resize
    
    $(window).on 'resize', @_checkDeviceType

    if _.isFunction @viewOrientationDidChange
      _.bindAll this, 'viewOrientationDidChange'
      $(window).on 'orientationchange', @viewOrientationDidChange

    do @_checkDeviceType

  render: ->
    throw new Error "Template must be defined" unless (@template? and _.isFunction(@template))
    @templateData = {}

    if not @rendered
      do @_firstRender

    do @viewWillRender

    do @_serializeData

    template = do @_chooseTemplate
    
    @$el.html( template( @templateData ) )

    if not @$el.attr('id')? and @idRoot?
      id = @idRoot + (@model.id or @model.cid)
      @$el.attr id: id

    _.defer(@_finishRender)
    this

  _finishRender: ->
    @rendered = true
    do @viewDidRender
    @trigger('render', this)
    @templateData = {}

  _checkDeviceType: ->
    w=$(window).width()
    @isPhone = w<768 #Modernizr.mq('(max-width:767px)')
    @isTablet = w>767 && w<980 #Modernizr.mq('(min-width: 768px) and (max-width: 979px)')
    #@orientation = Backbone.System.orientation()

    @_oldIsPhone = @isPhone if not @rendered
    
    if _.isFunction @phoneTemplate
      if @isPhone isnt @_oldIsPhone
        do @render

    @_oldIsPhone = @isPhone

  _chooseTemplate: ->
    if @isPhone and _.isFunction @phoneTemplate
      return @phoneTemplate
    else
      return @template

  remove:()->
    do @viewWillRemove
    super
    $(window).off 'resize', @_checkDeviceType
    $(window).off 'orientationchange', @viewOrientationDidChange if _.isFunction @viewOrientationDidChange
    $(window).off 'resize', @resize if _.isFunction @resize
    do @viewDidRemove
    @trigger('remove', this)
    this
