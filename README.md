debug.js
==========

在手机上打印调试信息。

### 快速上手
```javascript
debug.success("This is success message:)");
debug.error("This is error message:)");
debug.log("This is primary message:)");
debug.log({a: 1, b: 2});
debug.log([1,2,3]);
```

`debug.js`为了方便调试，会默认开启捕捉浏览器的报错。如果你不需要这个功能，可以这样禁止它：

```javascript
debug.silence()
```

### 预览
![preview](https://cloud.githubusercontent.com/assets/2696107/4680760/96b74744-560d-11e4-92bb-ab1e2af40573.png)

### Demo
[http://binnng.github.io/debug.js/demo/index.html](http://binnng.github.io/debug.js/demo/index.html)

### API

```javascript
debug.log()
debug.success()
debug.warn()
debug.error()
debug.danger()
```

### 安装
* npm（推荐）
```
npm install m-debug.js
```
* bower
```
bower install binnng/debug.js
```

* component
```
component install binnng/debug.js
```

### angular
如果你使用angular：

```javascript
var app = angular.module("app", [
	"binnng/debug"
]);

app.controller("ctrl", function($debug) {
	$debug.success("Welcome to debug.js");
});
```

### 主页
[http://binnng.github.io/debug.js](http://binnng.github.io/debug.js/)

### 源码
[http://binnng.github.io/debug.js/docs/debug.html](http://binnng.github.io/debug.js/docs/debug.html)

### 协议
MIT
