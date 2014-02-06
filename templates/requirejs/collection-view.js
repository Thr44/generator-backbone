/*global define*/

define([
    'jquery',
    'underscore',
    'backbone',
    'templates'
], function ($, _, Backbone, JST) {
    'use strict';

    var <%= _.classify(name) %>View = Backbone.CollectionView.extend({
        template: JST['<%= jst_path %>']
    });

    return <%= _.classify(name) %>View;
});
