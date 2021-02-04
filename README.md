# Cocos Runtime SDK for iOS API 文档

本文档中的函数、接口、常量等定义如果没有特别标明所在的类，则属于类 CRGameRuntime 。

## Cocos Runtime SDK APIs

### 获取 Cocos Runtime SDK 模块的版本号
```objc
- (NSString *)getVersionInfo;
```
返回形如: **主版本号.次版本号.修订号** 的版本号字符串，版本号递增规则如下：

1. 主版本号：从1开始递增的正整数，当有不兼容的 API 修改时+1
2. 次版本号：从0开始递增的正整数，当新增了向下兼容的新功能时+1，当主版本号增加时归0
3. 修订号：从0开始递增的正整数，当做了向下兼容的问题修正时+1，当次版本号增加时归0

此版本号可用于兼容性判断。

### 初始化 Cocos Runtime 运行环境
```objc
// 该方法属于 CRCocosGame
+ (void)initRuntime:(NSString *)userId options:(NSDictionary *)options listener:(NSObject<CRRuntimeInitializeListener> *)listener;
```

__*参数*__

- NSString *userID

    玩家唯一标识字符串

- NSDictionary *options

    初始化参数

-	NSObject < CRRuntimeInitializeListener > * listener

    初始化操作回调监听者

__*初始化参数*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_STORAGE_PATH_APP|NSString|否|游戏包安装目录，默认为>NSCachesDirectory + "/app"|
|CR_KEY_STORAGE_PATH_CACHE|NSString|否|运行时临时存储目录，默认为NSTemporaryDirectory()|
|CR_KEY_STORAGE_PATH_CORE|NSString|否|不同版本 Core 的存储目录，默认为 NSCachesDirectory + "/core"|
|CR_KEY_STORAGE_PATH_USER|NSString|否|玩家数据目录，默认为 NSCachesDirectory + "/user"|

__*RuntimeInitializeListener 接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onInitializeSuccess:(NSObject< CRCocosGameRuntime > *)instance;|instance: 成功初始化的Runtime对象，应用应保存此对象，通过它调用其它接口|初始化成功后回调|
|- (void)onInitializeFailure:(NSException *)exception;|exception: 错误对象|初始化失败时回调|

### 结束 Cocos Runtime 运行环境
```objc
- (void)done
```
回收相关资源。

### 检查文件的可用性
```objc
- (void)checkFileAvailability:(NSDictionary *)info listener:(id<CRCheckFileAvailabilityListener>)listener;
```

__*参数*__

- NSDictionary *info

    文件检查相关信息

- id < CRCheckFileAvailabilityListener > listener

    文件检查过程监听者

__*文件检查相关信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_CHECK_FILE_EXTENSION_NAME_ARRAY|NSArray< NSString * >|否|需要检查的临时文件的后缀名|
|CR_KEY_CHECK_FILE_KEEP_TIME|NSNumber|否|临时文件保留时间，单位为分钟，当前时间减文件最后一次修改时间超出保留时间，删除此文件|

__*CRCheckFileAvailabilityListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onCheckStart;|-|开始检查时回调|
|- (void)onCheckProgress:(NSString removedPath;|removedPath: 已经删除的文件或者文件夹的绝对路径|检查过程回调|
|- (void)onCheckSuccess;|-|检查成功后回调|
|- (void)onCheckFailure:(NSError error;|error: 错误对象|检查失败时回调|

### 获取 Cocos Runtime SDK 指定功能的管理器

__*版本: >= 1.4.0*__

```Objective-C
- (id)getManager:(NSString *)name options:(NSDictionary *)options
```

__*参数*__

- NSString *name

需要获取的功能的名称，具体名称请参考对应功能的说明文档

- NSDictionary *options

其他参数

__*返回值*__

返回指定功能对应的管理对象，若指定功能不存在，则返回空对象

## 小游戏管理 APIs

### 获取指定小游戏的 game.config.json 配置

__*版本: >= 1.4.0*__

```Objective-C
- (id<CRCocosGameConfig>)getGameConfig:(NSDictionary *)info
```

__*参数*__

- NSDictionary *info

指定小游戏的游戏信息

__*返回值*__

返回指定小游戏的配置信息对象

__*指定小游戏的游戏信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|KEY_GAME_PACKAGE_APP_ID|NSString|是|指定小游戏的唯一标识|
|KEY_GAME_PACKAGE_VERSION|NSString|否|指定小游戏的版本号|

__*CocosGameConfig*__

|属性|数据类型|说明|
|:--|:--|:--|
|deviceOrientation|NSString|小游戏的屏幕方向，默认值为 landscape|
|showStatusBar|boolean|小游戏是否显示状态栏，默认值为 false|
|subpackages|Bundle[]|小游戏包含的分包配置信息，默认值为空数组|
|plugins|Bundle[]|小游戏包含的插件配置信息，默认值为空数组|

### 检查某个小游戏的某个版本是否在本地存在
```objc
- (void)checkGameVersion:(NSDictionary *)info listener:(NSObject<CRPackageCheckVersionListener> *)listener;
```

__*参数*__

- NSDictionary *info

    小游戏版本信息

- NSObject< CRPackageCheckVersionListener > * listener

    版本检查过程监听者

__*Runtime Core 版本信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_GAME_PACKAGE_APP_ID|NSString|是|唯一标识小游戏的|
|CR_KEY_GAME_PACKAGE_HASH|NSString|否|小游戏版本对应的Hash值，<br/>有此参数时，函数会对<br/>Core文件进行校验|
|CR_KEY_GAME_PACKAGE_VERSION|NSString|是|要检查的小游戏版本号|

__*CRPackageCheckVersionListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onCheckVersionStart:(NSDictionary info;|info:CheckVersion函数<br/>传入对象|开始检查时回调|
|- (void)onCheckVersionSuccess;|-|检查成功后回调，说明本地存在此版本|
|- (void)onCheckVersionFailure:(NSError error;|error:错误对象|检查失败时回调，说明本地不存在指定版本|

### 下载指定版本的小游戏首包
```objc
- (void)downloadGamePackage:(NSDictionary *)info listener:(NSObject<CRPackageDownloadListener> *)listener;
```
下载的文件会保存到初始化时 CR_KEY_STORAGE_PATH_CACHE 指定的路径下。下载中断时会自动重试5次，每次间隔1.5s。

__*参数*__

- NSDictionary *info

    小游戏首包下载信息

- NSObject< CRPackageDownloadListener > * listener

    下载过程监听者

__*小游戏首包下载信息信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_GAME_PACKAGE_APP_ID|NSString|是|要下载的小游戏唯一标识|
|CR_KEY_GAME_PACKAGE_URL|NSString|是|小游戏某版本的URL|
|CR_KEY_GAME_PACKAGE_VERSION|NSString|是|要下载的小游戏版本号|

__*CRPackageDownloadListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onDownloadStart;|-|开始下载回调|
|- (void)onDownloadProgress:(long)downloadedSize totalSize:(long)totalSize;|downloadedSize:已下载数<br/>totalSize:总下载字节| 下载中回调 |
|- (void)onDownloadRetry:(long)retryNo;|retryNo:重试次数|重试下载时回调|
|- (void)onDownloadSuccess:(NSString *)path;|path:文件保存路径|下载成功后回调|
|- (void)onDownloadFailure:(NSError *)error;|error:错误对象|下载工程中发生错误时回调|

### 安装小游戏首包
```objc
- (void)installGamePackage:(NSDictionary *)info listener:(NSObject<CRPackageInstallListener> *)listener;
```
把下载好的游戏首包安装到 Runtime 环境中。

__*参数*__

- NSDictionary *info

    小游戏安装包信息

- NSObject< CRPackageInstallListener > * listener

    安装过程监听者

__*小游戏安装包信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_GAME_PACKAGE_APP_ID|NSString|是|要安装的小游戏唯一标识|
|CR_KEY_GAME_PACKAGE_EXTEND_DATA|NSString|否|小游戏的附加信息字段，<br/>会保存在数据库中|
|CR_KEY_GAME_PACKAGE_HASH|NSString|否|小游戏安装包对应的Hash值，<br/>有此参数时，函数会对<br/>安装包进行校验|
|CR_KEY_GAME_PACKAGE_PATH|NSString|是|小游戏安装包的本地路径|
|CR_KEY_GAME_PACKAGE_VERSION|NSString|是|要安装的小游戏版本号|

__*CRPackageInstallListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onInstallStart;|-|开始安装时回调|
|- (void)onInstallSuccess;|-|安装成功后回调|
|- (void)onInstallFailure:(NSError *)error;|error:错误对象|安装失败时回调|

### 取消正在进行的小游戏安装包下载请求
```objc
- (void)cancelGamePackageRequest;
```
重复调用不报错。

### 查询已安装的游戏
```objc
- (void)listGame:(id<CRGameListListener>)listener;
```

__*参数*__

- id< CRGameListListener > listener

    游戏查询监听者

__*CRGameListListener 接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onListGameSuccess:(NSArray<NSDictionary * > *)list;|list:游戏信息列表|查询成功时回调|
|- (void)onListGameFailure:(NSError *)error;|error:错误对象|查询失败时回调|

__*游戏信息列表可用字段*__

|属性|数据类型|说明|支持版本|
|:--|:--|:--|:--|
|CR_KEY_GAME_ITEM_APP_ID|NSString|小游戏唯一标识|
|CR_KEY_GAME_ITEM_EXTEND|NSString|在安装游戏时或运行游戏时，传入的EXTEND_DATA字段|

### 删除指定的游戏
```objc
- (void)removeGameList:(NSArray<NSString *> *)list listener:(id<CRGameRemoveListener>)listener;
```
如果游戏不存在，返回成功，当游戏存在且删除出错时才返回错误，遇到错误即中止操作。

__*参数*__

- NSArray< NSString * > * list

    要删除的游戏的 APP ID 列表

- id< CRGameRemoveListener > listener

    游戏删除监听者

__*CRGameRemoveListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onRemoveStart:(NSString *)appId extra:(NSString *)extra;|appId:小游戏唯一标识<br/>extra:保存在数据库中的附加数据|开始删除一个游戏前回调|
|- (void)onRemoveFinish:(NSString *)appId extra:(NSString *)extra;|appId:小游戏唯一标识<br/>extra:保存在数据库中的附加数据|成功删除一个游戏后回调|
|- (void)onRemoveSuccess:(NSArray< NSString * > *)removedList;|removedList:真正被删除的小游戏列表|所有游戏删除后回调|
|- (void)onRemoveFailure:(NSError *)error;|error: 错误对象|删除失败时回调|

### 删除所有游戏
```objc
- (void)removeGameAll:(id<CRGameRemoveListener>)listener;
```

__*参数*__

- id< CRGameRemoveListener > listener

    游戏删除监听者

## 小游戏启动/退出 APIs

### 监听游戏请求退出
```objc
- (void)setGameQueryExitListener:(id<CRGameQueryExitListener>)listener;
```
不设置时游戏直接退出。

__*参数*__

- id< CRGameQueryExitListener > listener

    游戏退出请求监听者

__*CRGameQueryExitListener 接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onQueryExit:(NSString appID result:(NSString *)result;|appID:请求退出的游戏的唯一标识<br/>result:退出附带的字符串信息|游戏请求退出回调|

### 开始运行游戏
```objc
- (void)runGame:(UIViewController *)controller appId:(NSString *)appId options:(NSDictionary *)options listener:(NSObject<CRGameRunListener> *)listener;
```

__*参数*__

- UIViewController *controller

    游戏控制器

- NSString *appId

    游戏唯一标识ID

- NSDictionary *options

    游戏运行参数

- NSObject< CRGameRunListener > * listener

    游戏启动状态监听者

__*游戏运行参数可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|CR_KEY_RUN_OPT_APP_LAUNCH_OPTIONS|NSString|否|需要传递给游戏的启动参数|
|CR_KEY_RUN_DEBUG_SHOW_DEBUG_VIEW | BOOL | 否 | 是否开启调试信息显示 |
|CR_KEY_RUN_DEBUG_SHOW<br/>_GAME_LOADING_TIME_LOG | BOOL | 否 | 是否开启调试日志时间显示 |
|CR_KEY_RUN_OPT_PIXEL_RATIO|int| 否| 1. 关闭离屏渲染2. 启用离屏渲染并设置前后屏的像素比|
|CR_KEY_RUN_OPT_LIMIT_USER_STORAGE|int|否|设置用户存储空间限额&gt;=0,单位MiB减小设置值时不会删除已多占的空间，默认值: 50|
|CR_KEY_RUN_OPT_DEFAULT_CERT_PATH|NSString|否|指定一个目录为默认证书搜索路径|
|CR_KEY_RUN_OPT_CUSTOM_SEARCH_PATH|NSString|否|指定一个目录为脚本搜索路径|
|"rt_run_debug_enable_vconsole"|BOOL|否|是否开启vConsole|
|"rt_run_debug_skipped_frame_warning_limit"|int|否|设置丢帧数，达到该丢帧数触发|

__*CRGameRunListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onGameHandleCreate:(NSObject<CRCocosGameHandle> *)handle;|handle:初始化成功的Game对象,应用应保存此对象|此时可以定制游戏界面，应用需要从handle获取GameView然后添加到Window系统中进行接下来的初始化流程|
|- (void)onRunSuccess;|-|游戏开始运行后回调|
|- (void)onRunFailure:(NSError *)error;|error:错误对象|初始化失败时调用|

### 退出正在运行的游戏
```objc
- (void)exitGame:(NSString *)appId listener:(id<CRGameExitListener>)listener;
```

__*参数*__

- NSString *appID

    游戏唯一标识APP ID

- id< CRGameExitListener > listener

    游戏退出监听者

__*CRGameExitListener 接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onGameExitSuccess;|-|游戏正常退出后调用，此时 CRCocosGameHandle 不可用|
|- (void)onGameExitFailure:(NSError *)error;|error: 错误对象|游戏退出异常时调用|

