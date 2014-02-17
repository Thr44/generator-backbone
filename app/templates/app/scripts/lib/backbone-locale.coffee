#namespace 'Backbone'

class Backbone.Locale
  
  constructor: (options) ->
    @options = options
    @strings = {}
    @lang = options.lang
    @strings[@lang] = options.strings if options.strings?
    _.extend(this, Backbone.Events) if Backbone.Events?
    @loadingDicts = false

  load: (opts) ->
    return if @loadingDicts or (not @lorem? and @checkLorem(opts))  

    lang = opts.lang || "en"
    url = opts.path
    callback = opts.callback
    callbackContext = opts.callbackContext || this
    options = opts.options || {}

    lang = document.getElementsByTagName('html')[0].getAttribute('lang') unless lang?

    cb = =>
      @lang = lang
      $('html').addClass @lang unless $('html').hasClass @lang
      console.info "Strings file for language #{lang} loaded"
      console.timeEnd('Locale time loading')
      @strings[lang] = Backbone.Locale.strings if not @strings[lang]?
      moment.lang(lang, @strings[lang].momentjs) if @strings[lang] and @strings[lang].momentjs? and moment?
      moment.lang('en') if moment? and lang is 'en'
      console.log "OK LANG"
      callback.call(callbackContext, options) if callback?
      @trigger('language', lang) if  typeof @trigger is 'function'
    
    console.time('Locale time loading')
    if @strings[lang]?
      do cb
      return
    
    url = window.rootPath+"scripts/locale/strings-#{lang}.js" unless url?
    if url?
      if typeof yepnope is 'function'
        yepnope([{
          load: url
          callback: (url, test, key) =>
            do cb
        }])
       else
         throw new Error("yepnope lib not loaded. Check Modernizr version > 2.0")
    else
      throw new Error("URL for strings file not defined for lang #{lang}")
  
  t: (locale_string, locale_group, options) ->
    throw new Error('No traslation strings loaded') unless @strings?

    if not options? and locale_group? and typeof locale_group is 'object'
      options = locale_group 
      locale_group = null
    
    options = options or {}

    options.span = if options.span? then options.span else true

    group = locale_group && @strings[@lang][locale_group] || @strings[@lang]

    return group[locale_string] if group[locale_string]?

    dataAttribute = "data-locale-string=\"#{locale_string}\""
    dataAttribute += " data-locale-group=\"#{locale_group}\"" if locale_group?
    path = @lang + '.' + (if locale_group? then locale_group + '.'  else '') + locale_string

    if  @lorem? and (options.lorem? or options.wars? or options.futurama?)
      val = options.lorem || options.wars || options.futurama
      count = parseInt val
      type = Lorem.TYPE.WORD
      type = Lorem.TYPE.PARAGRAPH if /\d+p/.test val        
      type = Lorem.TYPE.SENTENCE if /\d+s/.test val    
      type = Lorem.TYPE.WORD if /\d+w/.test val
      type = Lorem.TYPE.WORDSENTENCE if /\d+ws/.test val
      
      dict = Lorem.DICTS.StarWars.master if options.wars? and Lorem.DICTS.StarWars?
      if options.futurama? and Lorem.DICTS.Futurama?
        dict = Lorem.DICTS.Futurama 
        type = Lorem.TYPE.ELEMENT
      
      text = @lorem.createText(count, type, dict)

      if type is Lorem.TYPE.PARAGRAPH or type is Lorem.TYPE.ELEMENT
        paragraphs = text.split("\n")
        paragraphs = for p in paragraphs
          "<p class=\"translation-missing\" #{dataAttribute} title=\"Translation missing: #{path}\">#{p}</p>"
        
        return paragraphs.join(' ')              
    else
      text = locale_string

    
    if options.span
      return "<span class=\"translation-missing\" #{dataAttribute} title=\"Translation missing: #{path}\">#{text}</span>"
    else
      return text
    
    
  checkLorem: (opts)->
    console.log "@checkLorem", opts, opts.options
    return false if location.hostname.split('.').slice(-1).toString() isnt 'dev' and not opts.options and not opts.options.forceLorem
    dicts = ['lorem.js', 'lorem.starwars.js']
    dicts = for file in dicts
      window.rootPath+"scripts/locale/#{file}" 
    #"#{@options.asset_path}lib/lorem/#{file}"
    @loadingDicts = true
    yepnope(
      load: dicts
      complete:  (url, test, key) =>
          @lorem = new Lorem if Lorem?    
          @loadingDicts = false
          @load(opts)
    )
    true

  @extractMissingTranslations: ->
    missingTranslations = $('.translation-missing')
    obj = {}
    missingTranslations.each ->
      $el = $(this)
      group = $el.attr 'data-locale-group'
      string = $el.attr 'data-locale-string'
      if group?
        obj[group] = {} unless obj[group]? 
        obj[group][string] = $el.html()
      else
        obj[string] = $el.html()
    return obj


  @missingTranslationsFile: ->
    obj = @extractMissingTranslations()
    filecontent = "Backbone.Locale.strings = \n\tlang: \"#{INW.lang}\"\n"
    for key, string of obj
      if _.isString string
        text = "\t"
        text += "\"#{key}\": \"Edit text\"\n"
        filecontent += text
      else if _.isObject string
        filecontent += "\t\"#{key}\":\n"
        for k, st of string
          text = "\t\t"
          text += "\"#{k}\": \"Edit text\"\n"
          filecontent += text

    filecontent
    
    
