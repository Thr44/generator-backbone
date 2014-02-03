class Backbone.System

  # constructor: () ->
  #   @browser = @getBrowser()
  #   @ieversion = @getBrowserVersion()
  #   @os = @getOS()
  #   @isMobile = @os is @OS.iOS or @os is @OS.Android
  #   @isTouchable = Modernizr.touch
  #   @support =
  #     canvas: @supportCanvas()
  #     localStorage: @supportLocalStorage()
  #     file: @supportFile()
  #     fileSystem: @supportFileSystem()
  #     requestAnimationFrame: @supportRequestAnimationFrame()
  #     sessionStorage: @supportSessionStorage()
  #     webgl: @supportWebgl()
  #     worker: @supportWorker()
    
  @Browser:
    Arora: 'Arora'
    Chrome: 'Chrome'
    Epiphany: 'Epiphany'
    Firefox: 'Firefox'
    MobileSafari: 'Mobile Safari'
    InternetExplorer: 'MSIE'
    Midori: 'Midori'
    Opera: 'Opera'
    Safari: 'Safari'

  @OS:
    Android: 'Android'
    ChromeOS: 'CrOS'
    iOS: 'iOS'
    Linux: 'Linux'
    MacOS: 'Mac OS'
    Windows: 'Windows'

  @Orientation:
    Portrait: 'Portrait'
    LandscapeRight: 'Landscape right'
    LandscapeLeft: 'Landscape left'

  @OnlineStatus:
    Online: 'Online'
    Offline: 'Offline'
    Unknown: 'Unknown'
  
  @orientation: ()->
    return false if not window.orientation?
    switch window.orientation
      when 0 then return @Orientation.Portrait 
      when 90 then return @Orientation.LandscapeLeft 
      when -90 then return @Orientation.LandscapeRight 
    false
  
  @isOnline: ()->
    return @OnlineStatus.Unknown if not window.navigator.onLine?
    return @OnlineStatus.Online if window.navigator.onLine
    return @OnlineStatus.Offline

  @isIpad: ()->
    ua = navigator.userAgent
    return true if /iPad/.test(ua)

  @browser: () ->
    ua = navigator.userAgent
    return @Browser.Arora if /Arora/.test(ua)
    return @Browser.Chrome if /Chrome/.test(ua)
    return @Browser.Epiphany if /Epiphany/.test(ua)
    return @Browser.Firefox if /Firefox/.test(ua)
    return @Browser.MobileSafari if /Mobile Safari/.test(ua)
    return @Browser.InternetExplorer if /MSIE/.test(ua)
    return @Browser.Midori if /Midori/.test(ua)
    return @Browser.Opera if /Opera/.test(ua)
    return @Browser.Safari if /Safari/.test(ua)
    false

  @browserVersion:() ->
    ua = navigator.userAgent
    browser = @getBrowser()

    if /MSIE (\d+\.\d+);/.test(ua) 
      version = new Number(RegExp.$1)
      if /Trident\/(\d+\.\d+);/.test(ua)
        trident = new Number(RegExp.$1)
      if trident? and trident >= 5
        return 9
      else
        return parseInt(version)
    null

  @OS: () ->
    ua = navigator.userAgent;
    return @OS.Android if /Android/.test(ua)
    return @OS.ChromeOS if /CrOS/.test(ua)
    return @OS.iOS if /iP[ao]d|iPhone/.test(ua)
    return @OS.Linux if /Linux/.test(ua)
    return @OS.MacOS if /Mac OS/.test(ua)
    return @OS.Windows if /windows/.test(ua)
    false

  @supportCanvas: () ->
    !!window.CanvasRenderingContext2D

  @supportLocalStorage: () ->
    try
      return !!localStorage.getItem
    catch error
      return false
  
  @supportFile: () ->
    !! window.File and !! window.FileReader and !! window.FileList and !! window.Blob
  
  @supportFileSystem: () ->
    !! window.requestFileSystem
  
  @supportRequestAnimationFrame: () ->
    !!window.mozRequestAnimationFrame or !! window.webkitRequestAnimationFrame or !! window.oRequestAnimationFrame or !! window.msRequestAnimationFrame
  
  @supportSessionStorage: () ->
    try
      return !! sessionStorage.getItem
    catch error
      return false
  
  @supportWebgl: ()->
    !! window.WebGLRenderingContext
  
  @supportWorker: () ->
    !! window.Worker



