/*global <%= _.camelize(appname) %>, Backbone, JST*/

<%= _.camelize(appname) %>.Views = <%= _.camelize(appname) %>.Views || {};

(function () {
    'use strict';

    <%= _.camelize(appname) %>.Views.<%= _.classify(name) %>View = Backbone.ElementView.extend({

        template: JST['<%= jst_path %>']

    });

})();
