'use strict';

class <%= _.camelize(appname) %>.Models.<%= _.classify(name) %> extends Backbone.Model
  url: '',

  initialize: () ->

  defaults: {}

  validate: (attrs, options) ->

  parse: (response, options) ->
    response


### to allow loading formats other than json:
  fetch:(options)=>
    options || (options = {})
    options = _.extend(options, {dataType: 'text', contentType: 'text/csv', processData: false})
    return Backbone.Collection.prototype.fetch.call(this, options)

  parse:(data, xhr)=>
    rawData=d3.csv.parse(data)
    source = []
    for rawItem in rawData
      item = new @model rawItem
      source.push(item)
    return source
###
