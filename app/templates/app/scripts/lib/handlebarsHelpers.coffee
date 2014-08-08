class Backbone.HandlebarsHelpers

  constructor: (options) ->
    @options = options

  registerHelpers: ()=>
    Handlebars.registerHelper('capitalize', @capitalize)
    Handlebars.registerHelper('toLowerCase', @toLowerCase)
    Handlebars.registerHelper('toUpperCase', @toUpperCase)
    Handlebars.registerHelper('isEmail', @isEmail)
    Handlebars.registerHelper('prettyNumber', @prettyNumber)
    Handlebars.registerHelper('prettyCurrency', @prettyCurrency)


  # Strings:
  capitalize:(val)=>
    String(val).capitalize()

  toLowerCase:(val)=>
    String(val).toLowerCase()

  toUpperCase:(val)=>
    String(val).toUpperCase()

  # Numbers:

  prettyNumber:(val)=>
    if val is undefined
      val=""
    Number(val).prettyNumber()

  prettyCurrency:(val)=>
    if val is undefined
      val=""
    Number(val).prettyCurrency()

  #validation:

  isEmail:(val)=>
    String(val).isEmail()
