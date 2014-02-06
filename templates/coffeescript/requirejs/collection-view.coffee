define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class <%= _.classify(name) %>View extends Backbone.CollectionView
    template: JST['<%= jst_path %>']