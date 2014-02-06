define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class <%= _.classify(name) %>View extends Backbone.d3View
    template: JST['<%= jst_path %>']