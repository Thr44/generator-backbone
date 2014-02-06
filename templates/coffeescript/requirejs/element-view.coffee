define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class <%= _.classify(name) %>View extends Backbone.ElementView
    template: JST['<%= jst_path %>']