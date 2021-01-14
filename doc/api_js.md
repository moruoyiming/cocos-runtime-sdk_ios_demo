# Cocos Runtime JavaScript API

如无特殊说明，文档中所示 API 都通过调用全局函数 `loadRuntime()` 得到 runtime 对象来进行访问。

## 系统

### 生命周期
```JS
	exitApplication(Object object)
```
退出当前小游戏

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|data|string/object|否|退出游戏时返回的数据，<br/>交给应用处理，<br/>Object类型会转为JSON|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	getLaunchOptionsSync()
```
返回小游戏启动参数

*返回值*

本接口支持以下类型的返回值:

- undefined
- string
- JSON object
- JSON array

具体的意义请参考渠道启动参数说明。
```JS
	getSystemInfo()
```
获取系统信息

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|brand|string|手机品牌|
|model|string|手机型号|
|pixelRatio|number|设备像素比|
|screenWidth|number|屏幕宽度|
|screenHeight|number|屏幕高度|
|windowWidth|number|可使用窗口宽度|
|windowHeight|number|可使用窗口高度|
|language|string|系统语言|
|coreVersion|string|客户端基础库版本|
|system|string|操作系统版本|
|platform|string|客户端平台|

```JS
   getSystemInfoSync()
```
**支持版本: (core 版本 >= 1.1.0)**
`getSystemInfo()`的同步版本，获取系统信息

```JS
	onHide(function callback)
```
监听小游戏隐藏到后台事件。锁屏、按 HOME 键退到桌面等操作会触发此事件。

*参数*

- function callback

监听事件的回调函数
```JS
	offHide(function callback)
```
取消监听小游戏隐藏到后台事件。锁屏、按 HOME 键退到桌面、显示在聊天顶部等操作会触发此事件。

*参数*

- function callback

取消监听事件的回调函数
```JS
	onShow(function callback)
```
监听小游戏回到前台的事件

*参数*

- function callback

监听事件的回调函数
```JS
	offShow(function callback)
```
取消监听小游戏回到前台的事件

*参数*

- function callback

取消监听事件的回调函数

### 系统事件
```JS
	onAudioInterruptionEnd(function callback)
```
监听音频中断结束，在收到 onAudioInterruptionBegin 事件之后，小游戏内所有音频会暂停，收到此事件之后才可再次播放成功

*参数*

- function callback

监听事件的回调函数
```JS
	offAudioInterruptionEnd(function callback)
```
取消监听音频中断结束，在收到 onAudioInterruptionBegin 事件之后，小游戏内所有音频会暂停，收到此事件之后才可再次播放成功

*参数*

- function callback

取消监听事件的回调函数
```JS
	onAudioInterruptionBegin(function callback)
```
监听音频因为受到系统占用而被中断开始，以下场景会触发此事件：闹钟、电话、FaceTime 通话。此事件触发后，小游戏内所有音频会暂停。

*参数*

- function callback

监听事件的回调函数
```JS
	offAudioInterruptionBegin(function callback)
```
取消监听音频因为受到系统占用而被中断开始，以下场景会触发此事件：闹钟、电话、FaceTime 通话。此事件触发后，小游戏内所有音频会暂停。

*参数*

- function callback

取消监听事件的回调函数
```JS
	onError(function callback)
```
监听全局错误事件

*参数*

- function callback

监听事件的回调函数

- callback 回调函数

*参数*

Object res

|属性|键值类型|说明|
|:--|:--|:--|
|message|string|错误	|
|stack|string|错误调用堆栈|
```JS
	offError(function callback)
```
取消监听全局错误事件

*参数*

- function callback

取消监听事件的回调函数

### 性能

```JS
    getPerformance()
```

获取性能管理器

*返回值*

 - Performance:一个性能管理器对象

```JS
    Performance.now()
```

可以获取当前时间以毫秒为单位的时间戳

## 分包加载

### 触发分包加载
```JS
    LoadSubpackageTask loadSubpackage(Object object)
```

*参数*

- Object object: 分包加载参数和回调函数

*Object 参数*

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|name|string|是|分包的名字或入口，<br/>需要和分包配置中的值对应|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

*返回值*

- LoadSubpackageTask: 加载分包任务实例，用于获取分包加载状态

### 加载分包任务实例
```JS
    LoadSubpackageTask
```
用于获取分包加载状态

*方法*

- onProgressUpdate: 监听分包加载进度变化事件

### 监听分包加载进度变化事件
```JS
    LoadSubpackageTask.onProgressUpdate(function callback)
```

*参数*

- callback: 监听事件的回调函数

*callback 回调函数参数*

|属性|键值类型|说明|
|:--|:--|:--|
|progress|number|分包下载进度百分比|
|totalBytesWritten|number|已经下载的数据长度，单位 Bytes|
|totalBytesExpectedToWrite|number|预期需要下载的数据总长度，单位 Bytes|

## 设备

### 加速计
```JS
	onAccelerometerChange(function callback)
```
监听加速度数据，频率：5次/秒，接口调用后会自动开始监听，可使用 stopAccelerometer 停止监听。

*参数*

- function callback: 监听加速度数据的回调函数

*callback 回调函数参数*

|属性|键值类型|说明|
|:--|:--|:--|
|x|number|x轴|
|y|number|y轴|
|z|number|z轴|
```JS
	startAccelerometer(Object object)
```
开始监听加速度数据。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|interval|string|否|监听加速度数据回调函数的执行频率|
|success|function||否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- interval 的合法值

|值|说明|
|:--|:--|
|game|适用于更新游戏的回调频率，在 20ms/次 左右|
|ui|适用于更新 UI 的回调频率，在 60ms/次 左右|
|normal|普通的回调频率，在 200ms/次 左右|默认值|
```JS
	stopAccelerometer(Object object)
```
停止监听加速度数据。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function	|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数（调用成功、失败都会执行|

### 电量
```JS
	getBatteryInfo(Object object)
```
获取设备电量

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function|否|接口调用成功的回调函数|
|fail|function	|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

success 回调函数

*参数*

- BatteryInfo res

|属性|键值类型|说明|
|:--|:--|:--|
|level|number|设备电量，范围 1 - 100|
|isCharging|number|是否正在充电中（**支持版本: (core 版本 >= 1.1.0)**）|
```JS
   getBatteryInfoSync()
```
**支持版本: (core 版本 >= 1.1.0)**
`getBatteryInfo()`的同步版本，获取设备电量。


### 剪贴板
```JS
	getClipboardData(Object object)
```
获取系统剪贴板的内容

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function	|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

success 回调函数

*参数*

- Object object

|属性|键值类型|说明|
|:--|:--|:--|
|data|string|剪贴板的内容|
```JS
	setClipboardData(Object object)
```
设置系统剪贴板的内容

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|data|string|是|剪贴板的内容|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

### 罗盘
```JS
	onCompassChange(function callback)
```
监听罗盘数据，频率：5 次/秒，接口调用后会自动开始监听，可使用 stopCompass 停止监听。

*参数*

-	function callback

监听罗盘数据的回调函数

- callback 回调函数

*参数*

- Object object

|属性|键值类型|说明|
|:--|:--|:--|
|direction|number|面对的方向度数|
```JS
	startCompass(Object object)
```
开始监听罗盘数据

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function	|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	stopCompass(Object object)
```
停止监听罗盘数据

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function	|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

### 网络
```JS
	getNetworkType(Object object)
```
获取网络类型

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	onNetworkStatusChange(function callback)
```
监听网络状态变化事件

*参数*

- function callback

监听事件的回调函数

- callback 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|isConnected|boolean|当前是否有网络链接|
|networkType|string|网络类型|

- networkType 的合法值

|值|说明|
|:--|:--|
|wifi|wifi|网络|
|2g|2g|网络|
|3g|3g|网络|
|4g|4g|网络|
|unknown|Android 下不常见的网络类型|
|none|无网络|
```JS
	offNetworkStatusChange(function callback)
```
取消监听键盘输入事件

*参数*

- function callback

取消监听事件的回调函数

### 屏幕
```JS
	getScreenBrightness(Object object)
```
获取屏幕亮度

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	setKeepScreenOn(Object object)
```
设置是否保持常亮状态

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|keepScreenOn|boolean|是|是否保持常亮状态，false为关闭状态|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	setScreenBrightness(Object object)
```
设置屏幕亮度

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|value|number|是|屏幕亮度值，范围 0 ~ 1，0 最暗，1 最亮|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

### 振动
```JS
	vibrateShort(Object object)
```
使手机发生较短时间的振动（40 ms）

在 iOS 平台上，iPhone 7 / 7 Plus 以下设备不生效

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	vibrateLong(Object object)
```
使手机发生较长时间的振动（400 ms)

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

## 文件
```JS
	FileSystemManager getFileSystemManager()
```
获取全局唯一的文件管理器

*返回值*

- FileSystemManager

文件管理器
```JS
	FileSystemManager.access(Object object)
```
判断文件/目录是否存在

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|path|string|是|要判断是否存在的文件/目录路径|
|success|function	|否|文件存在的回调函数|
|fail|function|否|文件不存在的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.accessSync(string path)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.access` 的同步版本，判断文件/目录是否存在

*参数*

- string path

    要判断是否存在的文件/目录路径

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|文件/目录不存在|
```JS
    FileSystemManager.appendFile(Object object)
```
**支持版本: (core 版本 >= 1.1.0)**

在文件结尾追加内容

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|要追加内容的文件路径|
|data|string|是|要追加的文本或二进制数据|
|encoding|string|否|指定写入文件的字符编码</br>当前支持:</br>utf8(默认)</br>binary|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.appendFileSync(string filePath, string|ArrayBuffer data, string encoding)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.appendFile` 的同步版本，在文件结尾追加内容

*参数*

- string filePath

    要追加内容的文件路径

- string|ArrayBuffer data

    要追加的文本或二进制数据

- string encoding

    指定写入文件的字符编码，当前支持：

    - utf8
    - binary

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|指定的 filePath 文件不存在, 或是一个目录|
|permission denied|指定目标文件路径没有写权限|
```JS
	FileSystemManager.copyFile(Object object)
```
复制文件

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|srcPath|string|是|源文件路径，只可以是普通文件|
|destPath|string|是|目标文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.copyFileSync(string srcPath, string destPath)
```
`FileSystemManager.copyFile` 的同步版本，拷贝文件

*参数*

- string srcPath

    源文件路径，只可以是普通文件

- string destPath

    目标文件路径

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|源文件不存在，或目标文件路径的上层目录不存在|
|permission denied|指定目标文件路径没有写权限|
```JS
	FileSystemManager.getFileInfo(Object object)
```
获取本地临时文件或本地用户文件的文件信息

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|要读取的文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|size|number|文件大小，以字节为单位|

```JS
	FileSystemManager.mkdir(Object object)
```
创建目录

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|dirPath|string|是|创建的目录路径|
|recursive|boolean|否|是否在递归创建该目录的上级目录后再创建该目录。如果对应的上级目录已经存在，则不创建该上级目录。如 dirPath 为 a/b/c/d 且 recursive 为 true，将创建 a 目录，再在 a 目录下创建 b 目录，以此类推直至创建 a/b/c 目录下的 d 目录。| core >= 1.1.0|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.mkdirSync(string dirPath, boolean recursive)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.mkdir` 的同步版本，创建目录

*参数*

- string dirPath

    创建的目录路径

- boolean recursive

    是否在递归创建该目录的上级目录后再创建该目录。如果对应的上级目录已经存在，则不创建该上级目录。如 dirPath 为 a/b/c/d 且 recursive 为 true，将创建 a 目录，再在 a 目录下创建 b 目录，以此类推直至创建 a/b/c 目录下的 d 目录。

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|上级目录不存在|
|permission denied|指定目标文件路径没有写权限|
|file already exists|有同名文件或目录|
```JS
	FileSystemManager.readFile(Object object)
```
读取本地文件内容

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|要读取的文件的路径|
|encoding|string|否|指定读取文件的字符编码，<br/>当前只支持 binary 与 utf8，<br/>默认为 binary|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|data|string/ArrayBuffer|文件内容|
```JS
    FileSystemManager.readFileSync(string filePath, string encoding)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.readFile` 的同步版本，读取文件

*参数*

- string filePath

    要读取的文件的路径

- string encoding

    指定写入文件的字符编码，当前支持：

    - utf8
    - utf-8 (**支持版本: (core 版本 >= 1.3.2)**)
    - binary(默认)

*返回值*

- string|ArrayBuffer data

    文件内容

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|指定的 filePath 所在目录不存在|
```JS
	FileSystemManager.rename(Object object)
```
重命名文件，可以把文件从 oldPath 移动到 newPath

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|oldPath|string|是|源文件路径，可以是普通文件或目录|
|newPath|string|是|新文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.renameSync(string oldPath, string newPath)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.rename` 的同步版本，重命名文件

*参数*

- string oldPath

    源文件路径，可以是普通文件或目录

- string newPath

    新文件路径

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|源文件不存在，或目标文件路径的上层目录不存在|
|permission denied|没有写权限|
```JS
	FileSystemManager.rmdir(Object object)
```
删除目录

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|dirPath|Object|是|要删除的目录路径|
|recursive|boolean|false|是否递归删除目录。如果为 true，则删除该目录和该目录下的所有子目录以及文件。|core >= 1.1.0|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.rmdirSync(string dirPath, boolean recursive)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.rmdir` 的同步版本，移除目录

*参数*

- string dirPath

    要删除的目录路径

- string newPath

    是否递归删除目录。如果为 true，则删除该目录和该目录下的所有子目录以及文件。

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|目录不存在|
|directory not empty|目录不为空|
```JS
	FileSystemManager.readdir(Object object)
```
读取目录内文件列表

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|dirPath|string|是|要读取的目录路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|files|Array[string]|指定目录下的文件名数组。|
```JS
    FileSystemManager.readdirSync(string dirPath)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.readdir` 的同步版本，读取目录

*参数*

- string dirPath

    要删除的目录路径

*返回值*

- Array files

    指定目录下的文件名数组。

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|目录不存在|
|directory not empty|目录不为空|
```JS
	Stats FileSystemManager.stat(Object object)
```
获取文件 Stats 对象

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|path|string|是|文件/目录路径|
|recursive|bool|否|是否递归获取目录下的每个文件的 Stats 信息</br>默认为false|core 版本 >= 1.1.0|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|stats|Stats/Object|当 recursive 为 false 时，res.stats 是一个 Stats 对象。当 recursive 为 true 且 path 是一个目录的路径时，res.stats 是一个 Object，key 以 path 为根路径的相对路径，value 是该路径对应的 Stats 对象。|
```JS
    Stats|Array FileSystemManager.statSync(string path, boolean recursive)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.stat` 的同步版本，获取 Stats

*参数*

- string path

    要删除的目录路径

- boolean recursive

    是否递归获取目录中所有文件的信息

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|文件不存在|

```JS
	Stats
```
描述文件状态的对象

|属性|键值类型|说明|
|:--|:--|:--|
|mode|string|文件的类型和存取的权限|
|size|number |文件大小，单位：B|
|lastAccessedTime|number |文件最近一次被存取或被执行的时间,UNIX 时间戳|
|lastModifiedTime|number |文件最后一次被修改的时间,UNIX 时间戳|

```JS
	boolean Stats.isDirectory()
```
判断当前文件是否一个目录

*返回值*

- boolean

表示当前文件是否一个目录
```JS
	boolean Stats.isFile()
```
判断当前文件是否一个普通文件

*返回值*

- boolean

表示当前文件是否一个普通文件

```JS
	FileSystemManager.unlink(Object object)
```
删除文件

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|要删除的文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.unlinkSync(string path)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.unlink` 的同步版本，删除文件

*参数*

- string filePath

    要删除的文件路径

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|文件不存在|
```JS
	FileSystemManager.unzip(Object object)
```
解压文件

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|zipFilePath|string|是|源文件路径，只可以是 zip 压缩文件|
|targetPath|string|是|目标目录路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	FileSystemManager.writeFile(Object object)
```
写文件

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|要写入的文件路径|
|data	|string/ArrayBuffer|是|要写入的文本或二进制数据|
|encoding|string|否|指定写入文件的字符编码 utf8 or binary，默认值为 utf8|
|append|bool|否|默认为 false，覆盖旧文件|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数，指定目录不存在调用|
|complete|function|否|接口调用结束的回调函数|
```JS
    FileSystemManager.writeFileSync(string filePath, string|ArrayBuffer data, string encoding)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.writeFile` 的同步版本，写文件

*参数*

- string filePath

    要追加内容的文件路径

- string|ArrayBuffer data

    要追加的文本或二进制数据

- string encoding

    指定写入文件的字符编码，当前支持：

    - utf8
    - binary

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|指定的 filePath 文件不存在, 或是一个目录|
|permission denied|指定目标文件路径没有写权限|
```JS
    FileSystemManager.saveFile(Object object)
```
保存临时文件到本地。此接口会移动临时文件，因此调用成功后，tempFilePath 将不可用。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|tempFilePath|string|是|临时存储文件路径|
|filePath|string|是|要存储的文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数，指定目录不存在调用|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|savedFilePath|string|存储后的文件路径|
```JS
    string FileSystemManager.saveFileSync(string tempFilePath, string filePath)
```
**支持版本: (core 版本 >= 1.1.0)**

`FileSystemManager.saveFile` 的同步版本，保存临时文件到本地。

*参数*

- string tempFilePath

    临时存储文件路径

- string filePath

    要存储的文件路径

*返回值*

- string savedFilePath

    存储后的文件路径

*错误*

|错误信息|说明|
|:--|:--|
|no such file or directory|指定的 tempFilePath 文件不存在, 或是一个目录|
|permission denied|指定目标文件路径没有写权限|

    @Deprecated
    FileSystemManager.removeSavedFile(Object object)
__*该接口已废弃，请使用 FileSystemManager.unlink 代替*__

删除该小程序下已保存的本地缓存文件

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|需要删除的文件路径|
|success|function	|否|接口调用成功的回调函|
|fail|function|否|接口调用失败的回调函数，指定目录不存在调用|
|complete|function|否|接口调用结束的回调函数|

## 位置
```JS
	getLocation(Object object)
```
获取当前的地理位置、速度

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|type|string|否|默认为wgs84坐标，支持gcj02和bd09坐标|core 版本 >= 1.1.0|
|altitude|boolean|否|默认false，传入 true 会返回高度信息|core 版本 >= 1.1.0|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|latitude|number|纬度，范围为 -90~90，负数表示南纬|
|longitude|number|经度，范围为 -180~180，负数表示西经|
|speed|number|速度，单位 m/s|
|accuracy|number|位置的精确度|
|altitude|number|高度，单位 m|
|verticalAccuracy|number|垂直精度，单位 m（Android 无法获取，返回 0）|
|horizontalAccuracy|number|水平精度，单位 m|

## 网络

### 下载
```JS
    downloadFile (Object object)
```
下载文件资源到本地，客户端直接发起一个 HTTP GET 请求，返回文件的本地文件路径。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|url|string|是|下载资源的 url|
|header|Object|否|HTTP 请求的 Header，Header 中不能设置 Referer|
|filePath|string|是|指定文件下载后存储的路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|tempFilePath|string|临时文件路径|
|statusCode|number|服务器返回的 HTTP 状态码|
```JS
	DownloadTask
```
一个可以监听下载进度变化事件，以及取消下载任务的对象

*方法*

- DownloadTask.abort()

中断下载任务

- DownloadTask.onProgressUpdate(function callback)

监听下载进度变化事件

### 上传
**支持版本: (core 版本 >= 1.2.0)**
```JS
    uploadFile (Object object)
```
将本地资源上传到服务器。客户端发起一个 HTTP（S） POST 请求

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|url|string|是|开发者服务器地址|
|filePath|string|是|要上传文件资源的路径|
|name|string|是|文件对应的 key，开发者在服务端可以通过这个 key 获取文件的二进制内容|
|header|Object|否|HTTP 请求的 Header，Header 中不能设置 Referer|
|formData|Object|否|HTTP 请求中其他额外的 form data|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|data|string|开发者服务器返回的数据|
|statusCode|number|服务器返回的 HTTP 状态码|

**支持版本: (core 版本 >= 1.2.0)**
```JS
	UploadTask
```
一个可以监听上传进度变化事件，以及取消上传任务的对象

*方法*

- UploadTask.abort()

中断上传任务

- UploadTask.onProgressUpdate(function callback)

监听上传进度变化事件

## 用户设置
```JS
    getUserInfo(Object object)
```
获取用户信息
*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

- Object res

|属性|类型|说明|
|:--|:--|:--|
|userInfo|UserInfo	|用户信息对象|

- UserInfo

*属性*

- string userID
  用户ID

- string nickName
  用户昵称

- string avatarUrl

  用户头像图片 url。

- string city
  用户所在城市

- string country
  用户所在国家
- number gender
  用户性别
  **gender 的合法值**

  |值|说明|
  |:--|:--|
  |0|未知|
  |1|男性|
  |2|女性|


- string province
用户所在省份
*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|userInfo|UserInfo|用户信息对象|
```JS
	authorize(Object object)
```
向用户发起授权请求
*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|scope|string	|是|需要获取权限的 scope|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	getSetting(Object object)
```
获取用户的当前设置。返回值中只会出现已经请求过的权限。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|authSetting|AuthSetting|用户授权结果|
```JS
	openSetting(Object object)
```
调起客户端小游戏设置界面，返回用户设置的操作结果。设置界面只会出现已经请求过的权限。

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|authSetting|AuthSetting|用户授权结果|

- AuthSetting

*属性*

- boolean scope.userInfo

用户信息，对应接口 getUserInfo

- boolean scope.location

地理位置，对应接口 getLocation

- boolean scope.writePhotosAlbum

保存到相册，对应接口 saveImageToPhotosAlbum

- boolean scope.camera

使用摄像头拍照，对应接口 chooseImage

## 界面

### 键盘
```JS
	hideKeyboard(Object object)
```
隐藏键盘

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	onKeyboardInput(function callback)
```
监听键盘输入事件

*参数*

- function callback

监听事件的回调函数

- callback 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|value|Object|键盘输入的当前值|
```JS
	offKeyboardInput(function callback)
```
取消监听键盘输入事件

*参数*

- function callback

取消监听事件的回调函数
```JS
	onKeyboardConfirm(function callback)
```
监听用户点击键盘 Confirm 按钮时的事件

*参数*

- function callback

监听事件的回调函数

- callback 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|value|string|键盘输入的当前值|
```JS
	offKeyboardConfirm(function callback)
```
取消监听用户点击键盘 Confirm 按钮时的事件

*参数*

- function callback

取消监听事件的回调函数
```JS
	onKeyboardComplete(function callback)
```
监听监听键盘收起的事件

*参数*

- function callback

监听事件的回调函数

- callback 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|value|string|键盘输入的当前值|
```JS
	offKeyboardComplete(function callback)
```
取消监听监听键盘收起的事件

*参数*

- function callback

取消监听事件的回调函数
```JS
	showKeyboard(Object object)
```
显示键盘

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|defaultValue|string|否|键盘输入框显示的默认值<br/>默认为空字符串|
|maxLength|number|否|键盘中文本的最大长度<br/>默认值为 100|
|multiple|boolean|否|是否为多行输入<br/>默认值为 false|
|confirmHold|boolean|否|当点击完成时键盘是否收起<br/>false: 收起<br/>true: 不收起<br/>默认值为 true|
|confirmType|string|否|键盘右下角 confirm 按钮的类型<br/>支持的值为 done next search go send<br/>默认值为 done|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- object.confirmType 的合法值

|值|说明|
|:--|:--|
|done|完成|
|next|下一个|
|search|搜索|
|go|前往|
|send|发送|

```JS
	updateKeyboard(Object object)
```

**支持版本: (core 版本 >= 1.4.0)**

更新键盘输入框内容。只有当键盘处于拉起状态时才会产生效果

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|value|string|是|键盘输入框的当前值|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

## 媒体

### 音频
```JS
	AudioEngine
```
是单例对象，是属于 runtime 对象的子对象。主要用来播放音频，播放的时候会返回一个 audioID，之后都可以通过这个 audioID 来操作这个音频对象。

*方法*

```JS
	number AudioEngine.play(string filePath, boolean loop, number volume)
```
播放音频

*参数*

- string filePath

音频文件路径

- boolean loop [可选]

是否循环播放，默认 false

- number volume [可选]

声音大小，默认1

*返回值*

- number

播放音频的ID

```JS
	setLoop(number audioID, boolean loop)
```
设置音频是否循环。

*参数*

- number audioID

播放的音频ID

- boolean loop

是否循环

```JS
	boolean isLoop(number audioID)
```
获取音频的循环状态。

*参数*

- number audioID

播放的音频ID

*返回值*

 - boolean

 当前音频是否循环播放

```JS
	AudioEngine.setVolume(number audioID, number volume)
```
设置音量

*参数*

- number audioID

播放的音频ID

- number volume

音量大小 0.0~1.0

```JS
	number AudioEngine.getVolume(number audioID)
```
获取音量

*参数*

- number audioID

播放的音频ID

*返回值*

- number

音频的音量 0.0~1.0

```JS
	boolean AudioEngine.setCurrentTime(number audioID, number sec)
```
设置当前的音频时间。

*参数*

- number audioID

播放的音频ID

- number sec

要设置的当前播放时间

*返回值*

- boolean

设置是否成功

```JS
	number AudioEngine.getCurrentTime(number audioID)
```
获取当前的音频播放时间。

*参数*

- number audioID

播放的音频ID

*返回值*

- number

音频的当前播放时间

```JS
	number AudioEngine.getDuration(number audioID)
```
获取音频总时长。

*参数*

- number audioID

播放的音频ID

*返回值*

- number

音频的总播放时间

```JS
	audioEngine.AudioState AudioEngine.getState(number audioID)
```
获取音频状态。

*返回值*

- audioEngine.AudioState

详见[AudioState](http://docs.cocos.com/creator/api/zh/enums/audioEngine.AudioState.html)

```JS
	AudioEngine.setFinishCallback(number audioID, Function callback)
```
设置一个音频结束后的回调

*参数*

- number audioID

播放的音频ID

- Function callback

播放结束后的回调函数

```JS
	AudioEngine.pause(number audioID)
```
暂停正在播放音频。

*参数*

- number audioID

播放的音频ID

```JS
	AudioEngine.pauseAll()
```
暂停现在正在播放的所有音频。

```JS
	AudioEngine.resume(number audioID)
```
恢复播放指定的音频。

*参数*

- number audioID

播放的音频ID

```JS
	AudioEngine.resumeAll()
```
恢复播放所有之前暂停的所有音频。

```JS
	AudioEngine.stop(number audioID)
```
停止播放指定音频。

*参数*

- number audioID

播放的音频ID

```JS
	AudioEngine.stopAll()
```
停止正在播放的所有音频。

```JS
	AudioEngine.setMaxAudioInstance(number num)
```
设置一个音频可以设置几个实例

*参数*

- number num

一个音频可创建的实例个数

```JS
	number AudioEngine.getMaxAudioInstance()
```
获取一个音频可以设置几个实例

```JS
	AudioEngine.uncache(string filePath)
```
卸载预加载的音频。

*参数*

- string filePath

预加载的音频路径

```JS
	AudioEngine.uncacheAll()
```
卸载所有音频。

```JS
	AudioEngine.preload(string filePath, Function callback)
```
预加载一个音频

*参数*

- string filePath

音频文件路径

- Function callback

音频加载完成后的回调函数。该回调函数带有两个参数，第一个参数为isSucceed代表是否加载预加载成功，第二个参数为duration代表所加载音频的长度，只有isSucceed为true的时候duration才有效，否则duration的值为-1。

```JS
	AudioEngine.setWaitingCallback(number audioID, Function callback)
```
**支持版本: (core 版本 >= 1.1.0)**

监听音频加载中事件。当音频因为数据不足时，会调用对应的 callback。

*参数*

- number audioID

播放的音频ID

- Function callback

音频加载中事件的回调函数

```JS
	AudioEngine.setErrorCallback(number audioID, Function callback)
```
**支持版本: (core 版本 >= 1.1.0)**

监听音频播放错误事件

*参数*

- number audioID

播放的音频ID

- Function callback

音频播放错误事件的回调函数

```JS
	AudioEngine.setCanPlayCallback(number audioID, Function callback)
```
**支持版本: (core 版本 >= 1.2.2)**

监听音频即将播放事件。调用AudioEngine.play方法后，音频可能因为缓存等原因还没有开始播放，此时音频信息无法获取正确值，如音频的duration。通过此接口设置回调函数后，当收到回调时，此时音频数据已经准备好，可以正确获取音频信息。

*参数*

- number audioID

播放的音频ID

- Function callback

音频加载中事件的回调函数

### 图片
```JS
	chooseImage(Object object)
```
从本地相册选择图片或使用相机拍照。

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|count|number|是|需要选择的数量|
|sourceType|Array.<string>|否|选择图片的来源</br>默认值为：['album', 'camera']|core 版本 >= 1.0.2|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|tempFilePaths|Array[string]|图片的本地文件路径列表|
|tempFiles|Array[ImageFile]|图片的本地文件列表，每一项是一个 File 对象|
```JS
	previewImage(Object object)
```
预览图片

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|current|string|否|当前显示图片的链接，默认 urls 的第一张|
|urls|Array[string]|是|需要预览的图片链接列表|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
	saveImageToPhotosAlbum(Object object)
```
保存图片到系统相册。需要用户授权 scope.writePhotosAlbum

*参数*

- Object object

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|
|filePath|string|是|图片文件路径|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|
```JS
    ImageFile
```
*属性*

- string path

本地文件路径

- number size

本地文件大小，单位 B

```JS
    saveImageTemp(Object object)
```
异步将二进制图像数据保存为本地临时图片文件。

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|data|Uint8Array|是|像素数据，数据类型为 RGBA8888 格式的 Uint8Array 数组，若该数据的长度不等于 width * height * 4，则认为是不合法的数据，保存文件失败|
|width|number|是| data 包含的图像数据的宽度，最大宽度为 4096|
|height|number|是| data 包含的图像数据的高度，最大高度为 4096|
|fileType|string|是|写入图片的格式，支持的类形为 jpg、png|
|reverse|boolean|否|是否需要将写入的数据按 y 轴反转，默认为 false|core 版本 >= 1.0.1|
|success|function	|否|接口调用成功的回调函数|
|fail|function|否|接口调用失败的回调函数|
|complete|function|否|接口调用结束的回调函数|

- success 回调函数

*参数*

- Object res

|属性|键值类型|说明|
|:--|:--|:--|
|tempFilePath|string|保存完成后，本地临时文件路径|
|errMsg|string|错误信息|

```JS
    string saveImageTempSync(Object object)
```
同步将二进制图像数据保存为本地临时图片文件。

*参数*

- Object object

|属性|键值类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|data|Uint8Array|是|像素数据，数据类型为 RGBA8888 格式的 Uint8Array 数组，若该数据的长度不等于 width * height * 4，则认为是不合法的数据，保存文件失败|
|width|number|是| data 包含的图像数据的宽度，最大宽度为 4096|
|height|number|是| data 包含的图像数据的高度，最大高度为 4096|
|fileType|string|是|写入图片的格式，支持的类行为 jpg、png|
|reverse|boolean|否|是否需要将写入的数据按 y 轴反转，默认为 false|core 版本 >= 1.0.1|

*返回值*

- string

保存完成后，本地临时文件路径

## 帧率
```JS
    setPreferredFramesPerSecond(number fps)
```
修改渲染帧率。默认渲染帧率为 60 帧每秒。修改后，requestAnimationFrame 的回调频率会发生改变。

*参数*

- number fps

帧率，有效范围 1 - 60。

## 性能
```JS
	triggerGC()
```
加快触发 JavaScript VM 进行（垃圾回收），GC 时机是由 JavaScript VM 来控制的，并不能保证调用后马上触发 GC。

## 字体

### 文本行高
```JS
	Number getTextLineHeight(Object object)
```
***支持版本: (core 版本 >= 1.0.2)***

*参数*

- Object object

|属性|键值类型|是否必填|默认值|说明|
|:--|:--|:--|:--|:--|:--|
|fontStyle|string|否|normal|字体样式|
|fontWeight|string|否|normal|字重|
|fontSize|number|否|16|字号|
|fontFamily|string|是||字体名称|
|text|string|是||文本的内容|
|success|function|否||接口调用成功的回调函数|
|fail|function|否||接口调用失败的回调函数|
|complete|function|否||接口调用结束的回调函数|

*返回值*

- Number: 给定文本的行高

### 加载自定义字体文件
```JS
	string  loadFont(string path)
```
***支持版本: (core 版本 >= 1.2.0)***

*参数*

- string path

|属性|键值类型|是否必填|默认值|说明|
|:--|:--|:--|:--|:--|:--|
|path|string|是||字体文件路径|

*返回值*

- string : 如果加载字体成功，则返回字体 family 值，否则返回 null。


## 调试
```JS
	setEnableDebug(Object object)
```
***支持版本: (core 版本 >= 1.2.0)***

*参数*

- Object object

|属性|键值类型|是否必填|默认值|说明|
|:--|:--|:--|:--|:--|:--|
|enableDebug|boolean|是||是否打开调试|
|success|function|否||接口调用成功的回调函数|
|fail|function|否||接口调用失败的回调函数|
|complete|function|否||接口调用结束的回调函数（调用成功、失败都会执行）|


## 窗口
***支持版本: (core 版本 >= 1.1.1)***
```JS
	Object onWindowResize(function callback)
```
监听窗口尺寸变化事件

*参数*

- function callback
窗口尺寸变化事件的回调函数

- Object res
回调函数被调用时传入的参数

|属性|类型|说明|最低版本|
|:--|:--|:--|:--|
|windowWidth|number|变化后的窗口宽度||
|windowHeight|number|变化后的窗口高度||


```JS
	offWindowResize(function callback)
```
取消监听窗口尺寸变化事件

*参数*

- function callback
窗口尺寸变化事件的回调函数


## 调用自定义命令
```JS
	callCustomCommand(Object object, ...)
```
***支持版本: (core 版本 >= 1.1.1)***
具体功能需要由宿主应用提供, Runtime 本身默认不支持任何自定义命令, 任何调用都会返回失败.

*参数*

- Object object

|属性|键值类型|是否必填|默认值|说明|
|:--|:--|:--|:--|:--|:--|
|success|function|否||接口调用成功的回调函数|
|fail|function|否||接口调用失败的回调函数|
|complete|function|否||接口调用结束的回调函数（调用成功、失败都会执行）|

- ...

传递给宿主的不定参数, 支持基本类型、TypedArray 和基本数组:

|基本类型|说明|
|:--|:--|
|null|空类型|
|boolean|布尔类型|
|number|数字类型。如果数字是整数，底层当成64位有符号数处理，否则当成64位浮点数处理|
|string|字符串类型|

|TypedArray类型|说明|
|:--|:--|
|Int8Array|单字节数组|
|Int16Array|双字节数组|
|Int32Array|4字节数组|
|Float32Array|单精度浮点数数组|
|Float64Array|双精度浮点数数组|

对于基本数组, 要求数组中的所有元素的类型要求一致；基本数组支持以下数据形式:

|元素类型|说明|
|:--|:--|
|boolean|布尔值数组。底层做为布尔数组处理|
|number|数字数组。数组中所有数字按双精度浮点数处理|
|string|字符串数组|


## 功能状态
***支持版本: (core 版本 >= 1.3.2)***

```JS
	boolean setFeature(string key, ...)
```

*参数*

- string key

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|:--|
|key|string|是|功能状态key|


__*key可用字段*__

|属性|说明|类型|支持版本|
|:--|:--|:--|:--|
|"canvas.context2d.premultiply_image_data"| context 2d是否将画布上的data做预乘处理|boolean|1.3.2|


*返回值*

- boolean: 功能状态是否设置成功

- ...

状态值，支持布尔、number类型;


```JS
	... getFeature(string key)
```
*参数*

- string key

|属性|键值类型|是否必填|说明|
|:--|:--|:--|:--|:--|
|key|string|是|功能状态key|


__*key可用字段*__

|属性|说明|类型|支持版本|
|:--|:--|:--|:--|
|"canvas.context2d.premultiply_image_data"|context 2d是否将画布上的data做预乘处理|boolean|1.3.2|
|"webgl.extensions.oes_vertex_array_object.revision"|WebGL 的 VAO 扩展功能的修订版本号|number|1.3.7|

*返回值*

- ...:参考key可用字段说明


