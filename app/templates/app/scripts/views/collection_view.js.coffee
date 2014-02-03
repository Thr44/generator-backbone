#'use strict';

class Backbone.CollectionView extends Backbone.ElementView

  modelView: Backbone.ElementView


  initialize: (options)->
    
    do @_methodBinding

    _.bindAll(this, 'addElement', 'removeElement', 'renderElement', 'populateWithElement')
    @collection.on('add', @addElement, this)
    @collection.on('remove', @removeElement, this)
    @collection.on('reset', @render, this)
    @delayedRender = _.debounce(@render, 500)
    @collection.on('add', @delayedRender, this)
    @init(options)

  populateWithElement: (view, i)->
    @$el.append view.el

  addElement:(model)->
    @modelViews ||= {}
    #log model
    return @modelViews[model.cid] if model.cid? and @modelViews[model.cid]?
    if model instanceof Backbone.Model
      if _.isString @modelView
        ns = namespace @modelView
        clase = _.last ns
        view = new clase model:model
      else
        view = new @modelView model:model
                
    else if model instanceof Backbone.View
      view = model
      if not view.model?
        throw new Error('View must have a model associated')
      else
        model = view.model
    else
      throw new Error("Can only add a model or a view instance")

    view.collectionView = this

    @collection.add(model, silent: true) unless @collection.get(model.cid)?
    @modelViews[view.model.cid] = view

    view

  removeElement: (model)->
    if not @modelViews
      return
    if model instanceof Backbone.Model
      view = @modelViews[model.cid]
    else if model instanceof Backbone.View
      if not model.model?
        throw new Error('View must have a model associated')
      else
        view = @modelViews[model.model.cid]
    else
      throw new Error("Can only remove a model or a view instance")
    
    delete @modelViews[view.model.cid] if view?

    @collection.remove(view.model, silent: true) if view and @collection.get(view.model.cid)?

  render: ()->
    @templateData = {}
    
    if not @rendered
      do @_firstRender

    do @viewWillRender

    if @template?

      @templateData = do @_serializeData

      template = do @_chooseTemplate
      
      @$el.html( template( @templateData ) )

      if not @$el.attr('id')? and @idRoot?
        id = @idRoot + (@model.cid or @model.cid)
        @$el.attr id: id
    
    @collection.each @renderElement

    _.defer @_finishRender

    this


  renderElement: (model, i)->
    
    throw new Error('You must provide a modelView') unless @modelView?
    
    view = @addElement model
    do view.render
    
    @populateWithElement view, i
    
    do view.delegateEvents #view.events if view.events?
    this

  

  remove:()->
    super
    _.each(@modelViews, (element)=>
        do element.remove
    ) if @modelViews
    this
  


