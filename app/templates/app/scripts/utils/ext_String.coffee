String::capitalize = () ->
  (this.split(/\s+/).map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '

String::slugify = () ->
  r = this.replace(/\s+/g, '_').toLowerCase()
  r = r.replace(new RegExp("[àáâãäå]", 'g'),"a")
  r = r.replace(new RegExp("[èéêë]", 'g'),"e")
  r = r.replace(new RegExp("[ìíîï]", 'g'),"i")
  r = r.replace(new RegExp("ñ", 'g'),"n");
  r = r.replace(new RegExp("[òóôõö]", 'g'),"o")
  r = r.replace(new RegExp("[ùúûü]", 'g'),"u")
  return r


String::isEmail=()->
  regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
  return regex.test(this)
