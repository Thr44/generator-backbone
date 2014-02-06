'use strict';

class <%= _.camelize(appname) %>.Views.<%= _.classify(name) %>View extends Backbone.CollectionView

    template: JST['<%= jst_path %>']
