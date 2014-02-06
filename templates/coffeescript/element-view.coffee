'use strict';

class <%= _.camelize(appname) %>.Views.<%= _.classify(name) %>View extends Backbone.ElementView

    template: JST['<%= jst_path %>']
