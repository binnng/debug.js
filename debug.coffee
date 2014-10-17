((WIN, DOC) ->

  "use strict"

  UNDEFINED = undefined
  NULL = null

  LOG = "log"
  DANGER = "danger"
  WARN = "warn"
  SUCCESS = "success"
  ERROR = "error"

  noop = ->

  dom = DOC.querySelectorAll or DOC.getElementsByTagName
  toString = {}.toString

  isArray = Array.isArray or (val) -> 
    val.constructor is Array

  isObejct = (obj) -> 
    obj.constructor is Object

  # 不能直接定义，可能取不到
  getBody = -> DOC["body"] or dom("body")?[0] or dom("html")?[0]

  class Debug

    # 种类和颜色
    colorMap = 
      log: "0074cc"
      danger: "da4f49"
      warn: "faa732"
      success: "5bb75b"
      error: "bd362f"

    # 将不同类型的msg转换为可读的String
    render = (msg) ->
      text = []
      arr = []

      if isArray msg
        arr.push "#{item}" for item in msg
        text = "[" + arr.join(',') + "]"

      else if isObejct msg
        arr.push "#{item}: #{msg[item]}" for item of msg
        text = "{" + arr.join(',') + "}"

      else
        text = String(msg)

      text

    joinCss = (css) -> css.join ";"

    # 每个debug信息样式
    childCss = [
      "margin-top:-1px"
      "padding:.5em"
      "border-top:1px solid rgba(255,255,255,.3)"
      "margin:0"
    ]

    # debug容器的样式
    parentCss = [
      "-webkit-overflow-scrolling:touch"
      "pointer-events:none"
      "overflow:auto"
      "line-height:1.5"
      "z-index:5000"
      "position:fixed"
      "left:0"
      "top:0"
      "max-width:50%"
      "max-width:100%"
      "font-size:11px"
      "background:rgba(0,0,0,.8)"
      "color:#fff"
      "width:100%"
    ]

    constructor: -> 
      # 是否初始化
      isInit = no

      msg = fn = color = ""

      # 外层元素
      parent = NULL

    init: ->
      el = @el = DOC.createElement "div"
      el.setAttribute "style", joinCss(parentCss)

      body = getBody()
      body.appendChild(el)

      @isInit = yes

      @

    # 核心的输出debug信息方法
    # private
    print: ->

      @init() unless @isInit

      css = childCss.concat ["color:##{@color}"]
      child = DOC.createElement "p"
      child.setAttribute "style", joinCss(css)
      child.innerHTML = @msg
      @el.appendChild child

      @


    for fn of colorMap
      @::[fn] = ((fn) ->
        (msg) ->
          @fn = fn
          @msg = render msg
          @color = colorMap[fn]
          @print()
      ) fn


  entry = new Debug()

  if typeof exports isnt "undefined" and module.exports
    module.exports = exports = entry
  else if typeof define is "function"
    define (require, exports, module) ->
      module.exports = exports = entry
  else
    # 浏览器端直接运行
    WIN["debug"] = entry

) window, document