# ```
# debug.js 1.0.0
#
# ! CopyRight: binnng http://github.com/binnng/debug.js
# Licensed under: MIT
# http://binnng.github.io/debug.js
# ```

# ### Fork me on [Github](https://github.com/binnng/debug.js)!

# ### [Homepage](http://binnng.github.io/debug.js)

((WIN, DOC) ->

  "use strict"

  UNDEFINED = undefined
  NULL = null

  LOG = "log"
  DANGER = "danger"
  WARN = "warn"
  SUCCESS = "success"
  ERROR = "error"

  CLICK = "click"

  isTouch = "ontouchend" of WIN

  noop = ->

  dom = DOC.querySelectorAll
  toString = {}.toString

  # 绑定事件
  bind = (el, evt, callback) ->
    el.addEventListener evt, callback, no

  # 解绑事件
  unbind = (el, evt, fn) ->
    el.removeEventListener evt, fn, no

  isNull = (val) -> val is NULL

  isArray = Array.isArray or (val) ->
    val and "[object Array]" is toString.call(val)

  isObejct = (val) ->
    typeof val is "object" and not isArray(val) and not isNull(val)

  # 不能直接定义，可能取不到
  getBody = -> DOC["body"] or dom("body")?[0] or dom("html")?[0]


  class Debug

    # 种类和颜色
    debugMap =
      log: "0074cc"
      danger: "da4f49"
      warn: "faa732"
      success: "5bb75b"
      error: "bd362f"

    # 将不同类型的msg转换为可读的String
    render = (msg) ->
      text = ""
      arr = []

      if isArray msg
        for item in msg
          if typeof(item) is "object"
            arr.push render(item)
            text = "[" + arr.join(',') + "]"
          else
            arr.push "#{item}"
            text = "[" + arr.join(',') + "]"

      else if isObejct msg
        for item of msg
          if typeof(msg[item]) is "object"
            arr.push "#{item}: " + render(msg[item])
            text = "{" + arr.join(',') + "}"
          else
            arr.push "#{item}: #{msg[item]}"
            text = "{" + arr.join(',') + "}"

      else
        text = String(msg)

      text

    # 设置translate
    translate = (el, y) ->
      el.style.webkitTransform = "translate3d(0,#{y},0)"
      el.style.transform = "translate3d(0,#{y},0)"

    joinCss = (css) -> css.join ";"

    # debug 容器底部预留的高度
    parentBottom = 6

    publicCss = [
      "-webkit-transition: all .3s ease"
      "transition: all .3s ease"
    ]

    # 每个debug信息样式
    childCss = [
      "margin-top:-1px"
      "padding:10px"
      "border-top:1px solid rgba(255,255,255,.1)"
      "margin:0"
      "max-width:" + ( WIN.outerWidth - 20 ) + "px"
    ].concat publicCss

    # debug容器的样式
    parentCss = [
      "-webkit-overflow-scrolling:touch"
      "overflow:auto"
      "line-height:1.5"
      "z-index:5000"
      "position:fixed"
      "left:0"
      "top:0"
      "font-size:11px"
      "background:rgba(0,0,0,.8)"
      "color:#fff"
      "width:100%"
      "padding-bottom:#{parentBottom}px"
      "max-height:100%"
    ].concat publicCss

    constructor: ->
      # 是否初始化，是否收起
      @isInit = @isHide = no

      # 当前消息，当前执行函数，当前颜色
      @msg = @fn = @color = ""

      # 外层元素
      @el = NULL

    init: ->
      el = @el = DOC.createElement "div"
      el.setAttribute "style", joinCss(parentCss)

      body = getBody()
      body.appendChild(el)

      # 初始位置
      translate el, 0

      # 绑定事件
      bind el, CLICK, => @toggle()

      @isInit = yes

      @

    # `debug.print()`
    # 核心的输出debug信息方法
    print: ->

      @init() unless @isInit

      css = childCss.concat ["color:##{@color}"]
      child = DOC.createElement "p"
      child.setAttribute "style", joinCss(css)
      child.innerHTML = @msg
      @el.appendChild child

      @

    # `debug.toggle()`
    # 隐藏和收起
    toggle: (event) =>
      (if @isHide then @show else @hide).call @, event

    show: (event) ->
      translate @el, 0
      @isHide = no

      @

    hide: (event) ->
      translate @el, "-#{@el.offsetHeight - parentBottom}px"
      @isHide = yes

      @

    # 添加所有debug方法
    # ```
    # debug.log()
    # debug.danger()
    # debug.warn()
    # debug.error()
    # debug.success()
    # ```
    for fn of debugMap
      @::[fn] = ((fn) ->
        (msg) ->
          @fn = fn
          @msg = render msg
          @color = debugMap[fn]
          @print()
      ) fn

  # 开放一个实例
  entry = new Debug()

  # 绑定window，捕捉js报错信息
  # 可以通过debug.silence()禁用
  errListener = (error) ->
    # 只输出有用的错误信息
    msg = [
      "Error:"
      "filename: #{error.filename}"
      "lineno: #{error.lineno}"
      "message: #{error.message}"
      "type: #{error.type}"
    ]

    entry.error msg.join("<br/>")

  bind WIN, ERROR, errListener

  # 取消绑定window的错误捕捉
  entry.silence = ->
    unbind WIN, ERROR, errListener

  # 如果是移动设备
  # 接管`console.log`
  # 使用uglify压缩可以去掉所有console代码
  if isTouch
    _log = window.console.log 
    console.log = ->
      entry.log arguments[0]
      _log.apply window.console, arguments

  if typeof exports isnt "undefined" and module.exports
    module.exports = exports = entry
  else if typeof define is "function"
    define "debug", (require, exports, module) ->
      module.exports = exports = entry
  else if typeof angular is "object"
    angular.module("binnng/debug", []).factory "$debug", -> entry
  else
    WIN["debug"] = entry

) window, document
