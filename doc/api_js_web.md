# Cocos Runtime JavaScript API for Web

Cocos Runtime 为基于 JavaScript 虚拟机的脚本运行环境，为了方便适配浏览器平台的游戏在 Runtime 上运行，Runtime 提供了一些游戏常用的 Web 标准的 JavaScript API，这类 API 在 Runtime 上的使用方式和 Web 环境中保持一致。主要有：

- Document
- WebGL
- LocalStorage
- XMLHttpRequest
- WebSocket
- Canvas Context 2D
- 触摸事件
- 定时器
- 加载自定义字体
- 帧率
- Performance
- Image

## Document APIs

Runtime 本身并不支持 DOM， 只通过 Adapter 的方式模拟实现了有限 Document API 以方便 Web 游戏适配。具体实现详见[jsb-adapter](https://github.com/cocos-creator-packages/jsb-adapter/tree/master/builtin/jsb-adapter)。

```JS
    document
```
全局文档对象。

### 属性
```JS
    readyState
```
文档的加载状态。

```JS
    visibilityState
```
document的可见性。

```JS
    documentElement
```
文档对象（document）的根元素。

```JS
    hidden
```
布尔值,表示是（true）否（false）隐藏。

```JS
    location
```
一个 Location 对象。文档的 URL 相关的信息。

```JS
    head
```
当前文档中的 head 元素。

```JS
    body
```
当前文档中的body元素。

```JS
    scripts
```
当前文档中所有script元素的集合。

### 方法
```JS
   HTMLElement createElementNS(namespaceURI, qualifiedName, options)
```
创建一个具有指定的命名空间URI和限定名称的元素。

*参数*

- namespaceURI

指定与元素相关联的命名空间URI的字符串。

- qualifiedName

指定要创建的元素的类型的字符串。

- options

可选参数(不支持)

*返回值*

- HTMLElement

返回的新元素

```JS
   HTMLElement createElement(tagName)
```
创建一个具有null命名空间URI的元素。

*参数*

- tagName

指定要创建元素类型的字符串。

*返回值*

- HTMLElement

返回的新元素

```JS
   HTMLElement getElementById(id);
```
获取一个匹配特定ID的元素。Runtime 环境默认提供绘制图像的主 Canvas ID 为 'canvas'(`let canvas = document.getElementById('canvas');`), 可以通过这个对象获取 WebGL 上下文(`let ctx = canvas.getContext('webgl');`)。

*参数*

- id

大小写敏感的字符串，代表了所要查找的元素的唯一ID.

*返回值*

- HTMLElement

返回元素

```JS
   HTMLElement getElementsByTagName(tagName)
```
获取一个包括所有给定标签名称的元素的HTML集合。

*参数*

- tagName

标签名称

*返回值*

- HTMLElement

返回的元素的集合。

```JS
   HTMLElement getElementsByName(tagName)
```
根据给定的name获取相对应的列表集合。

*参数*

- tagName

标签名称

*返回值*

- HTMLElement

返回的元素的集合。

```JS
   HTMLElement querySelector(query)
```
获取文档中与指定选择器或选择器组匹配的第一个html元素。

*参数*

- query

包含一个或多个要匹配的选择器的DOM字符串。

*返回值*

- HTMLElement

返回元素

```JS
   HTMLElement querySelectorAll(query)
```
返回与指定的选择器组匹配的文档中的元素列表。

*参数*

- query

包含一个或多个要匹配的选择器的DOM字符串。

*返回值*

- HTMLElement

返回的元素的集合。

```JS
   HTMLElement createTextNode()
```
创建一个新的文本节点。

*返回值*

- HTMLElement

新的文本元素。

```JS
   window[type] createEvent(type)
```
创建一个指定类型的事件

*参数*

- type

一个字符串，表示要创建的事件类型。

*返回值*

- window[type]

创建的 Event 对象。

## WebGL APIs

Cocos Runtime 实现了标准的 WebGL 1.0 功能，请查看 [Webgl API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API)。

*不支持的API*
- WebGLContextEvent

*支持的Extension*
- OES_vertex_array_object

***支持版本: (core 版本 >= 1.2)***

- WEBGL_compressed_texture_etc1

***支持版本: (core 版本 >= 1.3.4)***

- WEBGL_compressed_texture_pvrtc

***支持版本: (core 版本 >= 1.3.4)***

## LocalStorage APIs

Cocos Runtime 实现了标准的 Web Local Storage 功能，请查看 [Local Storage API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/Storage/LocalStorage)。

*限制*

1. 数据缓存的总大小限制为 10MB
2. 单次存入缓存中的数据大小限制为 1MB

*说明*

- 数据缓存并不能写入10个大小为 1MB 的数据，因为数据缓存中数据 key 和表结构也要占用一部分存储空间，所以最多只能写入9个 1MB 大小的数据，写入第10个时会因超出存储大小限制而失败。

## XMLHttpRequest APIs

Cocos Runtime 实现了标准的 XMLHttpRequest 功能，请查看 [XMLHttpRequest API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/XMLHttpRequest)。

*不支持的属性*
- xmlHttp.responseXML

*未完整支持的属性*

- xmlHttp.responseText 仅支持Unicode数据格式请求

## WebSocket APIs

Cocos Runtime 实现了标准的 WebSocket 功能，请查看 [WebSocket API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket/binaryType)。

*不支持的属性*
- bufferedAmount 属性
- extensions 属性

*证书注意事项*
- runtime 不带证书
- 接入方需要定期更新证书，确保默认证书不过期
- 接入方可根据自己业务需求，生成业务相关证书
- 若无证书，可用runtime测试例用的证书。[证书下载地址](https://curl.haxx.se/docs/caextract.html),


## Canvas Context 2D APIs

Cocos Runtime 实现的 Canvas Context 2D API 实现了[HTML Canvas 2D Context](https://www.w3.org/TR/2dcontext/) 定义的大部分属性、方法。 如需使用首先需要创建离屏 Canvas 对象(`let canvas = document.createElement('canvas');`）,然后需要指定宽和高，以分配绘图 buffer，通过`canvas.width = 100,canvas.height = 100`来设置宽和高。

### 不支持的属性和方法
 1. 不支持的方法
   ```
      addHitRegion (微信亦不支持)
      removeHitRegion (微信亦不支持)
      clearHitRegions (微信亦不支持)
      drawFocusIfNeeded (微信亦不支持)
      isPointInPath (微信亦不支持, 但默认返回false)
   ```
 2. 未完整支持的方法
   ```
       drawImage 不支持HTMLVideoElement作为参数(微信亦不支持,微信HTMLVideoElement是未定义的)
   ```
 3. 方法支持存在的差异
   ```
      createRadialGradient 在H5效果为不规则图形时，个别参数会与H5效果不一致。(微信在此有不规则图形下都不绘制)
   ```
 4. 属性支持差异
   ```
      globalCompositeOperation(图像合成)

        与H5一致的类型：xor, source-atop, source-over, destination-out, destination-over, screen, overlay, darken, lighten
        不支持类型(微信也不支持)：lighter、copy
        与H5存在差异，微信不支持的类型: source-in source-out destination-atop
        与H5存在差异，与微信也存在差异(微信跟H5也不一致): destination-in
   ```

### 属性

```JS
   width
```
用于设置 canvas 宽，即绘图 buffer 宽。

```JS
   height
```

用于设置 canvas 高，即绘图 buffer 高。

```JS
   lineCap
```
***支持版本: (core 版本 >= 1.0.2)***

指定如何绘制每一条线段末端的属性。有3个可能的值，分别是：butt, round and square。默认值是 butt。

```JS
   lineJoin
```
***支持版本: (core 版本 >= 1.0.2)***

用来设置2个长度不为0的相连部分（线段，圆弧，曲线）如何连接在一起的属性（长度为0的变形部分，其指定的末端和控制点在同一位置，会被忽略）。

```JS
   lineWidth
```
线段宽度。当获取属性值时，它可以返回当前的值（默认值是1.0 ）。 当给属性赋值时， 0、 负数、 Infinity 和 NaN 都会被忽略；除此之外，都会被赋予一个新值。

```JS
   font
```
配置范例:"oblique small-caps 18px Arial"
字体样式。绘制文字时，当前字体样式的属性。默认字体是 Arial，字体大小 40。font-weight属性不支持数值设置(1-1000)。

- line-height：属性不支持。canvas支持的绘制字体都是单行绘制，设置行高对字体的显示没有影响，无需支持。
- bold：在 iOS 中，如果 font-family 使用的是通过 loadFont 加载的自定义字体，设置加粗时没有效果。
- small-caps：属性在 iOS 中不支持，设置后没有效果。

```JS
   textAlign
```
水平对齐，有效值：

 - left：文本左对齐
 - right: 文本右对齐
 - center：文本水平居中

```JS
   textBaseline
```
垂直对齐，有效值：

 - top：文本上对齐
 - bottom：文本水平居中
 - middle：文本垂直居中

```JS
   fillStyle
```
填充颜色，调用 API `fillText` 绘制字体时，使用此颜色填充字体（实心）。

```JS
   strokeStyle
```
画笔颜色，调用 API `strokeText` 绘制字体时，使用此颜色绘制字体边框（空心）。

```JS
   lineDashOffset
```
***支持版本: (core 版本 >= 1.2.0)***

Specifies where to start a dash array on a line

```JS
   shadowColor
```

***支持版本: (core 版本 >= 1.3.0)***

设置或返回当前阴影颜色

```JS
   shadowOffsetX
```

***支持版本: (core 版本 >= 1.3.0)***

设置或返回当前阴影X轴偏移

```JS
   shadowOffsetY
```

***支持版本: (core 版本 >= 1.3.0)***

设置或返回当前阴影Y轴偏移

```JS
   shadowBlur
```

***支持版本: (core 版本 >= 1.3.0)***

设置或返回应用于阴影的当前模糊级别，如果值为0会移除当前阴影效果。

```JS
   globalCompositeOperation(图像合成)
```
***支持版本: (core 版本 >= 1.3.0)***

API sets the type of compositing operation to apply when drawing new shapes

 - 与H5一致的类型：xor, source-atop, source-over, destination-out, destination-over, screen, overlay, darken, lighten
 - 不支持类型(微信也不支持)：lighter、copy
 - 与H5存在差异，微信不支持的类型: source-in source-out destination-atop
 - 与H5存在差异，与微信也存在差异(微信跟H5也不一致): destination-in

```JS
   globalAlpha(图像合成)
```
***支持版本: (core 版本 >= 1.3.0)***

 - 设置或返回绘图的当前 alpha 或 透明值。必须介于 0.0（完全透明） 与 1.0（不透明） 之间

```JS
   miterLimit
```
***支持版本: (core 版本 >= 1.2.0)***

设置或返回最大斜接长度

### 方法

```JS
   void beginPath();
```
清空子路径列表开始一个新路径。

```JS
   void moveTo(x, y);
```
移动子路径的起始点。

*参数*

 - x: 点的 x 轴坐标。
 - y: 点的 y 轴坐标。

```JS
   void lineTo(x, y);
```
使用直线连接子路径的终点到 x，y 坐标的方法（并不会真正地绘制）。

*参数*

 - x: 直线终点的 x 轴坐标。
 - y: 直线终点的 y 轴坐标。

```JS
   void closePath();
```
将笔点返回到子路径起始点，尝试从当前点到起始点绘制一条曲线。 如果图形已经是封闭的或者只有一个点，那么此方法不会做任何操作。

```JS
   void quadraticCurveTo(cpx, cpy, x, y)
```
***支持版本: (core 版本 >= 1.1.0)***
创建二次贝塞尔曲线

*参数*

 - cpx: 贝塞尔控制点的 x 轴坐标。
 - cpy: 贝塞尔控制点的 y 轴坐标。
 - x: 结束点的 x 轴坐标。
 - y: 结束点的 y 轴坐标。

 ```JS
   void bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y)
```
***支持版本: (core 版本 >= 1.2.0)***
创建三次贝塞尔曲线


*参数*

 - cp1x: 贝塞尔控制点的 x 轴坐标。
 - cp1y: 贝塞尔控制点的 y 轴坐标。
 - cp2x: 贝塞尔控制点的 x 轴坐标。
 - cp2y: 贝塞尔控制点的 y 轴坐标。
 - x: 结束点的 x 轴坐标。
 - y: 结束点的 y 轴坐标。

```JS
   void arc(x, y, radius, startAngle, endAngle, anticlockwise)
```
***支持版本: (core 版本 >= 1.3.0)***
以x,y为中心点，radius为半径，画弧


*参数*

 - x: 圆心点 x 轴坐标。
 - y: 圆心点x坐标 y 轴坐标。
 - radius: 圆的半径。
 - startAngle: 弧的起始位置弧度。
 - endAngle: 弧的结束位置弧度。
 - anticlockwise: 是否是逆时针方向，默认为false。

```JS
   void arcTo(x1, y1, x2, y2, radius)
```
***支持版本: (core 版本 >= 1.3.0)***
通过控制点画弧(x1, y1)为控制点1， (x2, y2)为控制点2


*参数*

 - x1: 控制点1 x 轴坐标。
 - y1: 控制点1 y 轴坐标。
 - x2: 控制点2 x 轴坐标。
 - y2: 控制点2 y 轴坐标。
 - radius: 圆的半径值。


```JS
   void ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise)
```
***支持版本: (core 版本 >= 1.3.0)***
以x,y为中心点，画椭圆

*参数*

 - x: 椭圆中心点 x 轴坐标。
 - y: 椭圆中心点 y 轴坐标。
 - radiusX: 椭圆长轴半径。
 - radiusY: 椭圆短轴半径。
 - rotation: 旋转弧度。
 - startAngle：起始弧度
 - endAngle： 终止弧度
 - anticlockwise: 是否是逆时针方向，默认为false。


```JS
   void clip([fillRule])
```
***支持版本: (core 版本 >= 1.3.0)***
以当前的path做为裁剪区域

*参数*

- fillRule: nonzero(默认值), evenodd


```JS
   void stroke();
```
绘制当前路径。

```JS
   void fill();
```
***支持版本: (core 版本 >= 1.0.2)***

填充当前的绘图(路径)。

```JS
   void rect(x, y, width, height)
```
***支持版本: (core 版本 >= 1.0.2)***

创建矩形(与stroke结合使用)

*参数*

 - x: 矩形起点的 x 轴坐标。
 - y: 矩形起点的 y 轴坐标。
 - width: 矩形的宽度。
 - height: 矩形的高度。

```JS
   void strokeRect(x, y, width, height)
```
***支持版本: (core 版本 >= 1.2.0)***
创建矩形

*参数*

 - x: 矩形起点的 x 轴坐标。
 - y: 矩形起点的 y 轴坐标。
 - width: 矩形的宽度。
 - height: 矩形的高度。

```JS
   void clearRect(x, y, width, height)
```
清空矩形区域，设置指定矩形区域内（ 以点 (x, y) 为起点，范围是(width, height) ）所有像素变成透明，并擦除之前绘制的所有内容。

*参数*

- x: 矩形起点的 x 轴坐标。
- y: 矩形起点的 y 轴坐标。
- width: 矩形的宽度。
- height: 矩形的高度。

```JS
    void fillRect(x, y, width, height)
```
绘制填充矩形，默认的填充颜色是黑色。

*参数*

 - x: 矩形起点的 x 轴坐标。
 - y: 矩形起点的 y 轴坐标。
 - width: 矩形的宽度。
 - height: 矩形的高度。

```JS
    measureText(text)
```
测量文本的尺寸，返回文本的尺寸信息。

*参数*

- text: 需要测量的文本。

*返回值*

- TextMetrics 对象。（目前 Cocos Runtime 只计算了字体的宽度）

```JS
    void strokeText(text, x, y [, maxWidth])
```
绘制文本（不填充），绘制的字体为空心字体。

*参数*

 - text: 使用当前的 font, textAlign 和 textBaseline 对文本进行渲染。
 - x: 文本起点的 x 轴坐标。
 - y: 文本起点的 y 轴坐标。
 - maxWidth（可选）: 绘制的最大宽度。如果指定了值，并且经过计算字符串的值比最大宽度还要宽，字体为了适应会水平缩放或者使用小号的字体。

```JS
   void fillText(text, x, y [, maxWidth])
```
填充文本，绘制的字体为实心字体。

*参数*

- text: 使用当前的 font, textAlign 和 textBaseline 对文本进行渲染。
- x: 文本起点的 x 轴坐标。
- y: 文本起点的 y 轴坐标。
- maxWidth（可选）: 绘制的最大宽度。如果指定了值，并且经过计算字符串的值比最大宽度还要宽，字体为了适应会水平缩放或者使用小号的字体。

```JS
   void scale(scalewidth, scaleheight)
```
***支持版本: (core 版本 >= 1.1.0)***
缩放当前绘图至更大或更小

*参数*

- scalewidth: 缩放当前绘图的宽度 (1=100%, 0.5=50%, 2=200%, 依次类推)。
- scaleheight: 缩放当前绘图的高度 (1=100%, 0.5=50%, 2=200%, 依次类推)。

```JS
   void rotate(angle)
```
***支持版本: (core 版本 >= 1.1.0)***
旋转当前的绘图

*参数*

- angle: 旋转角度，以弧度计。如需将角度转换为弧度，请使用 degrees * Math.PI / 180 公式进行计算。

```JS
   void translate(x, y)
```
***支持版本: (core 版本 >= 1.1.0)***
重新映射画布上的 (0,0) 位置

*参数*

- x: 添加到水平坐标（x）上的值。
- y: 添加到垂直坐标（y）上的值。

```JS
   void transform(a, b, c, d, e, f)
```
***支持版本: (core 版本 >= 1.1.0)***
替换当前的变换矩阵

*参数*

- a: 水平缩放绘图。
- b: 水平倾斜绘图。
- c：垂直倾斜绘图。
- d：垂直缩放绘图。
- e：水平移动绘图。
- f：垂直移动绘图。

```JS
   void setTransform(a, b, c, d, e, f)
```
***支持版本: (core 版本 >= 1.1.0)***

把当前的变换矩阵重置为单位矩阵，然后以相同的参数运行 transform()

*参数*

- a: 水平缩放绘图。
- b: 水平倾斜绘图。
- c：垂直倾斜绘图。
- d：垂直缩放绘图。
- e：水平移动绘图。
- f：垂直移动绘图。

```JS
   void resetTransform()
```
***支持版本: (core 版本 >= 1.1.0)***
把当前的变换矩阵重置为单位矩阵

```JS
   void save()
```
将当前环境状态保存到堆栈

```JS
   void restore()
```
弹出堆栈栈顶的环境状态，将上下文恢复到该状态

```JS
   void setLineDash()
```
***支持版本: (core 版本 >= 1.2.0)***
Cocos Runtime 实现了标准的 Web API setLineDash 功能，请查看 [setLineDash API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/setLineDash)。


```JS
   void getLineDash()
```
***支持版本: (core 版本 >= 1.2.0)***

Cocos Runtime 实现了标准的 Web API getLineDash 功能，请查看 [getLineDash API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/getLineDash)。

```JS
    ImageData createImageData(width, height);
    ImageData createImageData(imagedata);
```
Cocos Runtime 实现了标准的 Web API createImageData 功能，请查看 [createImageData API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/createImageData)。

```JS
    ImageData getImageData(x,y,width,height);
```
Cocos Runtime 实现了标准的 Web API getImageData 功能，请查看 [getImageData API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/getImageData)。

```JS
    void putImageData(imagedata, dx, dy);
    void putImageData(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
```
Cocos Runtime 实现了标准的 Web API putImageData 功能，请查看 [putImageData API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/putImageData)。

```JS
   void drawImage(img, sx, sy, sw, sh, dx, dy, dw, dh)
```
***支持版本: (core 版本 >= 1.3.0)***

在画布上绘制图像、画布，也能够绘制图像的部分区域，以及放大或缩小图像的尺寸

*参数*

- img: 规定要使用的 HTMLImageElement（支持 jpg、png）、HTMLCanvasElement、ImageData。
- sx: 可选。开始剪切的 x 坐标位置。
- sy：可选。开始剪切的 y 坐标位置。
- sw：可选。被剪切图像的宽度。
- sh：可选。被剪切图像的高度。
- dx：在画布上放置图像的 x 坐标位置。
- dy：在画布上放置图像的 y 坐标位置。
- dw：可选。要使用的图像的宽度。（放大或缩小图像）
- dh：可选。要使用的图像的高度。（放大或缩小图像）

```JS
   CanvasGradient createLinearGradient(x0, y0, x1, y1)
```
***支持版本: (core 版本 >= 1.3.0)***
创建线性渐变（用在画布内容上）
*参数*

- x0: 渐变开始点的 x 坐标
- y0: 渐变开始点的 y 坐标
- x1: 渐变结束点的 x 坐标
- y1: 渐变结束点的 y 坐标

```JS
   CanvasGradient createRadialGradient(x0, y0, r0, x1, y1, r1)
```
***支持版本: (core 版本 >= 1.3.0)***
创建放射状/环形的渐变（用在画布内容上）
*参数*

- x0: 渐变的开始圆的 x 坐标
- y0: 渐变的开始圆的 y 坐标
- r0: 开始圆的半径
- x1: 渐变的结束圆的 x 坐标
- y1: 渐变的结束圆的 y 坐标
- r1: 结束圆的半径


```JS
   void addColorStop(offset, color);
```
***支持版本: (core 版本 >= 1.3.0)***
规定渐变对象中的颜色和停止位置

*参数*

- offset: 介于 0.0 与 1.0 之间的值，表示渐变中开始与结束之间的位置
- color: 在offset位置显示的颜色值。
- color合法颜色值：十六进制颜色(如"#ff00ff"); RGB颜色(如"RGB(10, 2, 2)");RGBA颜色(如"RGBA(255, 0, 0, 255)");HSL色彩(如"hsl(300,65%,75%)");HSLA颜色(如"hsla(300,65%,75%,0.5)");预定义/跨浏览器的颜色名称(如 "blue")


```JS
   Object createPattern(image, repeat_rule)
```
***支持版本: (core 版本 >= 1.3.0)***
在指定的方向上重复指定的元素
*参数*

- image: 规定要使用的图片元素。
- repeat_rule: repeat(默认。该模式在水平和垂直方向重复);repeat-x(该模式只在水平方向重复);repeat-y(该模式只在垂直方向重复);no-repeat(该模式只显示一次（不重复）)

## 触摸事件 APIs

Cocos Runtime 实现了标准的 Web API Touch 功能，请查看 [触摸事件 API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/Touch)。

*Touch事件不支持的属性*

- screenX
- screenY

全屏游戏时, screenX 和 screenY 的值等于 clientX 和 clientY

## 定时器 APIs
```JS
   clearTimeout(number timeoutID)
```
可取消由 setTimeout() 方法设置的定时器。

*参数*

- number timeoutID

要取消的定时器的 ID。

```JS
   clearInterval(number intervalID)
```
可取消由 setInterval() 方法设置的定时器。

*参数*

- number intervalID

要取消的定时器的 ID。

```JS
   number setTimeout(function callback, number delay, any rest)
```
设定一个定时器，在定时到期以后执行注册的回调函数。

*参数*

- function callback

回调函数。

- number delay

延迟的时间，函数的调用会在该延迟之后发生，单位 ms。

- any rest

param1, param2, ..., paramN 等附加参数，它们会作为参数传递给回调函数。

*返回值*

- number

定时器的编号。这个值可以传递给 clearTimeout 来取消该定时。

```JS
   number setInterval(function callback, number delay, any rest)
```
设定一个定时器，按照指定的周期（以毫秒计）来执行注册的回调函数。

*参数*

- function callback

回调函数。

- number delay

执行回调函数之间的时间间隔，单位毫秒。

- any rest
param1, param2, ..., paramN 等附加参数，它们会作为参数传递给回调函数。

*返回值*

- number

定时器的编号。这个值可以传递给 clearInterval 来取消该定时。

## 帧率
```JS
    number requestAnimationFrame(function callback)
```
请求在下次绘制前执行设置的回调函数。

*参数*

- function callback

下次绘制前执行设置的回调函数。

*返回值*

- number

请求的 ID 编号。

```JS
    cancelAnimationFrame(number id)
```
取消一个通过`requestAnimationFrame`方法注册的回调请求。

*参数*

- number id

通过`requestAnimationFrame`方法注册回调时返回的 ID。

## Performance APIs
```JS
    Performance
```
性能管理器。

### 方法
```JS
    number Performance.now()
```
可以获取当前时间的时间戳，时间戳精度为微秒，单位为毫秒。

*返回值*

- number

时间戳。

## Image APIS

Cocos Runtime 实现了标准的 Image 功能，请查看 [Image API 参考文档](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/Image)。



