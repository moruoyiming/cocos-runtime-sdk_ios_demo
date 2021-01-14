# Cocos Runtime SDK Plugin for iOS API 文档

为了减少小游戏的安装时间，Cocos Runtime 支持插件功能。

当小游戏首次启动时，若本地已经存在指定插件，可直接复用本地的插件，从而提升小游戏的启动速度。若本地尚未存在指定的插件，则需要先安装插件后，再启动游戏。

本文档中的函数属于 Cocos Runtime SDK 中 Plugin 功能的管理类 CocosPluginManager，可以通过 `api_sdk_ios.md` 文档中的 `getManager` 方法，传入 `plugin_manager` 获取到管理对象。

## 指定插件的安装目录

在调用 `[CocosGame initRuntime]` 时，在 `options` 参数中设置:

|属性|数据类型|是否必填|说明|支持版本|
|:--|:--|:--|:--|:--|
|KEY_STORAGE_PATH_PLUGIN|NSString *|否|所有插件的存储目录，默认为 NSCachesDirectory + "/plugin"|&gt;=1.4.0|

## 检查插件是否安装

__*版本: >= 1.4.0*__

```Objective-C
- (void)checkPluginVersion:(NSDictionary *)info listener:(id<CRPluginCheckVersionListener>)listener
```

__*参数*__

- NSDictionary *info

安装插件信息

- CRPluginCheckVersionListener listener

插件是否安装的监听者

__*CRPluginCheckVersionListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onCheckPluginVersionStart:(NSDictionary *)info|**info**: 当前检查的插件信息|开始检查时回调|
|- (void)onCheckPluginSuccess:(NSDictionary *)info|**info**: 插件信息|当前已经安装了插件时回调|
|- (void)onCheckPluginFailure:(NSDictionary *)info error:(NSError *)error|**error**: 错误对象|当前未安装插件时回调|

__*插件信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"provider"|NSString|是|插件唯一标识|
|"version"|NSString|是|插件版本|

### 列出当前安装的所有插件

__*版本: >= 1.4.0*__

```Objective-C
- (void)listPlugin:(id<CRGameListListener>)listener
```

__*参数*__

- CRGameListListener listener

列出当前安装的所有插件的监听者

__*插件信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"provider"|NSString|是|插件唯一标识|
|"version"|NSString|是|插件版本|
|"path"|NSString|是|插件安装路径|

## 安装插件

__*版本: >= 1.4.0*__

```Objective-C
- (void)installPlugin:(NSDictionary *)info listener:(id<CRPluginInstallListener>)listener
```

安装指定的插件到 Runtime 环境中。

__*参数*__

- NSDictionary *info

安装插件信息

- CRPluginInstallListener listener

安装过程监听者

__*插件信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"provider"|NSString|是|插件唯一标识|
|"version"|NSString|是|插件版本|

__*PluginInstallListener*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onPluginInstallStart:(NSDictionary *)info|**info**:<br/>开始安装的插件<br/>|开始安装时回调|
|- (void)onPluginDownloadProgress:(NSDictionary *)info<br/>&nbsp;&nbsp;&nbsp;&nbsp;downloadSize:(long)downloadedSize<br/>&nbsp;&nbsp;&nbsp;&nbsp;totalSize:(long)totalSize|**info**:<br/>插件信息<br/>**downloadedSize**:<br/>已下载数<br/>**totalSize**:<br/>总下载字节| 下载中回调 |
|- (void)onPluginDownloadRetry:(NSDictionary *)info<br/>&nbsp;&nbsp;&nbsp;&nbsp;retryNo:(long)retryNo|**info**:<br/>插件信息<br/>**retryNo**: 重试次数|重试下载时回调|
|- (void)onPluginInstallSuccess:(NSDictionary *)info|**info**:<br/>成功安装的插件<br/>|安装成功后回调|
|- (void)onPluginInstallFailure:(NSDictionary *)info<br/>&nbsp;&nbsp;&nbsp;&nbsp;error:(NSError *)error|**info**:<br/>插件信息<br/>**error**: 错误对象|安装失败时回调|

## 删除指定的插件

__*版本: >= 1.4.0*__

```Objective-C
- (void)removePluginList:(NSArray<NSDictionary *> *)list listener:(id<CRPluginRemoveListener>)listener
```

如果插件不存在，返回成功，当插件存在且删除出错时才返回错误，遇到错误即中止操作

__*参数*__

- NSArray<NSDictionary *> * list

要删除的插件信息列表

- CRPluginRemoveListener listener

游戏删除监听者

__*插件信息可用字段*__

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"provider"|NSString|是|插件唯一标识|
|"version"|NSString|是|插件版本|

__*PluginRemoveListener 接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onPluginRemoveStart:(NSDictionary *)info|**info**:<br/>插件信息|开始删除一个插件前回调|
|- (void)onPluginRemoveFinish:(NSDictionary *)info|**info**:<br/>插件信息|成功删除一个插件后回调|
|- (void)onPluginRemoveSuccess:(NSArray<NSDictionary *> *)removeList|**removeList**:真正被删除的插件列表|所有插件删除后回调|
|- (void)onPluginRemoveFailure:(NSError *)error|**error**: 错误对象|删除失败时回调|

## 取消正在进行的插件安装请求

__*版本: >= 1.4.0*__

```Objective-C
- (void)cancelPluginRequest
```

重复调用不报错。
