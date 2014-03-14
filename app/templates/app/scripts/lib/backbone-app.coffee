#
# Backbone.App 
#
# Creates a backbone app structure namespace
#
# Usage:
#       window.App = Backbone.App(config)
#       App.run(container, options)
#
# Config object:
# 
# [Required]                 
#     start(options):       Bootstrap function for the app
#                           Here is where your code goes.
#                           options is an optional object with parameters
#                           passed from run method 
# [Optionals]
#     namespace:            Namespace object for the application
#                           if already exits
#
#     asset_path:           String or function for the asset_path
#                           (default from rails app)
#
#     lang:                 String or function for setting 
#                           the language (default from html lang)
#
#     localeUrl:            String or function for setting 
#                           locale url for a language strings file
# 
# Result object:
#     Models:                   Namespace for models
#     
#     Views:                    Namespace for views
#     
#     Collections:              Namespace for collections
#     
#     run([container], [opts]): Function to run the app, accepts as  
#                               parameter the container element.
#                               opts is an object that will be passed
#                               to the config.start function
# 
#     stage:                    Stage container for the app
# 
#     t(key, group):            Function for translations
# 
#     asset_path:               Asset path for the app
# 
#     changeLanguage(obj):      Load the new strings file
#                     lang: language
#                     path: path for new strings file
#                     callback: callback function when is loaded
#                     callbackContext: context for callback
#                     options: options to passed to callback function
# 
##### 

root = this


if not Backbone?
  throw new Error "Backbone should be installed"

Backbone.App = (config)->
  config.rootPath||="/"
  window.rootPath=config.rootPath
  conf = config or {}
  conf.root=conf.rootPath

  if not conf.namespace?
    conf.namespace = {}
  else
    if _.isString conf.namespace
      if root[conf.namespace]? 
        conf.namespace = root[conf.namespace]
      else 
        root[conf.namespace] = {}
        conf.namespace = root[conf.namespace]
        
  if not conf.start? or not _.isFunction conf.start
    throw new Error "You need to pass a start function"

  lang = ()->
    if not conf.lang?
      lang = document.getElementsByTagName('html')[0].getAttribute 'lang' 
    else 
      if not _.isFunction conf.lang
        lang = conf.lang
      else
        lang = conf.lang.call this
    console.log "currebt language:", lang
    lang || "en"
  
  localeUrl = (lang)->
    if not conf.localeUrl?
      url = conf.rootPath+"scripts/locale/strings-#{lang}.js"
    else 
      if not _.isFunction conf.localeUrl
        url  = conf.localeUrl
      else
        url = conf.localeUrl.call this, lang 
    url 

  loadFonts = ->
    return unless conf.fonts?

    # if $.browser.msie
    #   yepnope [
    #     load: assetPath()+'msie-fonts.css'
    #   ]
    #   return
    
    if not _.isFunction conf.fonts
      fonts  = conf.fonts
    else
      fonts = conf.fonts.call this

    console.error 'fonts should be an array. Check http://www.google.com/webfonts' unless _.isArray fonts
     
    window.WebFontConfig = 
      google:
       families: fonts


    
    wf = document.createElement 'script'
    wf.src = (if 'https:' is document.location.protocol then 'https' else 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'
    wf.type = 'text/javascript'
    wf.async = 'true'
    # s = document.getElementsByTagName('script')[0]
    # s.parentNode.insertBefore(wf, s)
    yepnope [
      load: wf.src
    ]

  
  loadAnalytics = ->
    return unless conf.analytics?

    ga = window._gaq = window._gaq || [];
    ga.push(['_setAccount', conf.analytics]);
    ga.push(['_trackPageview']);
    src = (if 'https:' is document.location.protocol then 'https://ssl' else 'http://www') + '.google-analytics.com/ga.js';
    
    yepnope [
      load: src
    ]    

  logger = null
  if window.log?
    logger = window.log
  else
    if console? and console.log?
      logger = -> console.log.apply(console, arguments)
    else
      logger = ()->
        return null

  locale = null
  baseApp = 
    Models: {}
    Collections: {}
    Views: {}
  
    run: (stage, options = {})->

      @lang = lang.call(this)
      #console.log "optiondebug?", options
      @isDebug = (location.hostname.match(/\.dev$/)? or options.forceDebug==true or location.port isnt "80" or location.search.match(/forceDebug=true/))
      
      window.log = _.bind @log, this
      window.elog = _.bind @errorlog, this

      console.log "DEBUG MODE ON" if @isDebug
      
      @stage = stage || $('body')
      @system = Backbone.System
      window.System = @system if not window.System?
      
      #HAML.t = _.bind @t, this
      locale = new Backbone.Locale this
      langPath=localeUrl.call this, @lang
      
      @changeLanguage( 
        lang: @lang
        path: langPath
        callback: conf.start
        callbackContext: this
        options: options
      )
      #do conf.start
      this

    log: ->
      return if not @isDebug
      logger.apply(window, arguments) 

    errorlog:(msg)->
      log("%c"+msg, "color:red") 

    on: (event, method, context)->
      switch event
        when 'language' then locale.on(event, method, context)

    off: (event, method, context)->
      switch event
        when 'language' then locale.off(event, method, context)
        
    changeLanguage: (options)->
      throw new Error("Language should be defined") unless options.lang?
      @lang = options.lang
      locale.load options
      this
      
    t: ->
      locale.t.apply locale, arguments

    isEmail:(email)->
      regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
      return regex.test(email)

    prettyNumber:(x)->
      if x is undefined
        x=""
      parts = x.toString().split(".")
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      return parts.join(".")

    prettyCurrency:(x)->
      parts = Number(x).toFixed(2).toString().split(".")
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      return parts.join(".")

    trackEvent: ->
      return if @isDebug or not window._gaq?
      args = Array.prototype.splice.call(arguments, 0)
      payload = ['_trackEvent'].concat args
      console.log "Tracking Event:", payload
      window._gaq.push payload

  do loadFonts  

  do loadAnalytics

  _.extend conf.namespace, baseApp

  if _.isFunction conf.init
    conf.init.call conf.namespace
  else if _.isObject conf.init
    _.extend conf.namespace, conf.init

  conf.namespace.modelns = conf.namespace['Models']
  conf.namespace.collectionns = conf.namespace['Collections']
  conf.namespace.viewns = conf.namespace['Views']
  window.AppRoot = conf.namespace

  Handlebars.registerHelper('t', baseApp.t)
  Handlebars.registerHelper('prettyNumber', baseApp.prettyNumber)
  Handlebars.registerHelper('prettyCurrency', baseApp.prettyCurrency)

  return conf.namespace

