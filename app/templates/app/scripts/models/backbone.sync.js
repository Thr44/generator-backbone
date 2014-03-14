/*
  This function is taken from backbone.js
  Changed line 32 to enclose all data in a 
  variable :api_data for update and create methods
*/
/*
for support for cookies credentials see: line 29
fo support for xml files see: line 41

*/

var methodMap = {
  'create': 'POST',
  'update': 'PUT',
  'delete': 'DELETE',
  'read':   'GET'
};

Backbone.ajax = function() {
  return $.ajax.apply($, arguments);
};

Backbone.sync = function(method, model, options) {
  var type = methodMap[method];

  // Default options, unless specified.
  options || (options = {});

  // uncomment for cookies credentials
  //@author: Miguel Cardoso
  /*
  if (!options.crossDomain) {
    options.crossDomain = true;
  }

  if (!options.xhrFields) {
    options.xhrFields = {withCredentials:true};
  }
  */

  //uncomment for xml support
  //@author: Miguel Cardoso
  /*
  options = _.extend(options,
    dataType: 'xml'
    contentType: 'application/xml'
    processData: false
  )
  */

  // Default JSON-request options.
  var params = {type: type, dataType: 'json'};

  // Ensure that we have a URL.
  if (!options.url) {
    params.url = _.result(model, 'url') || urlError();
  }

  // Ensure that we have the appropriate request data.
  if (!options.data && model && (method === 'create' || method === 'update')) {
    //params.contentType = 'application/json';
    //params.data = JSON.stringify({ api_data: model.toJSON() })
    params.data = _.map(model.attributes, function(el, val){return val+"="+el}).join("&")
  }

  // For older servers, emulate JSON by encoding the request into an HTML-form.
  if (Backbone.emulateJSON) {
    params.contentType = 'application/x-www-form-urlencoded';
    params.data = params.data ? {model: params.data} : {};
  }

  // For older servers, emulate HTTP by mimicking the HTTP method with `_method`
  // And an `X-HTTP-Method-Override` header.
  if (Backbone.emulateHTTP && (type === 'PUT' || type === 'DELETE')) {
    params.type = 'POST';
    if (Backbone.emulateJSON) params.data._method = type;
    var beforeSend = options.beforeSend;
    options.beforeSend = function(xhr) {
      xhr.setRequestHeader('X-HTTP-Method-Override', type);

      if (beforeSend) return beforeSend.apply(this, arguments);
    };
  }

  // Don't process data on a non-GET request.
  if (params.type !== 'GET' && !Backbone.emulateJSON) {
    params.processData = false;
  }

  var success = options.success;
  options.success = function(resp, status, xhr) {
    if (success) success(resp, status, xhr);
    model.trigger('sync', model, resp, options);
  };

  var error = options.error;
  options.error = function(xhr, status, thrown) {
    if (error) error(model, xhr, options);
    model.trigger('error', model, xhr, options);
  };

  // Make the request, allowing the user to override any Ajax options.
  return Backbone.ajax(_.extend(params, options));
};
