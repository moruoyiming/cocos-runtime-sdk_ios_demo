# Cocos Runtime Core for iOS API 文档

Runtime Core 模块为支持游戏正常运行的功能模块，由 Cocos Runtime SDK `runGame` API 返回并由 APP 模块保存。本文档中的函数、接口、常量等定义如果没有特别标明所在的类，则属于类 CRCocosGameHandle。

## Cocos Runtime Core APIs

### 获取 Cocos Runtime Core 模块的版本号
```objc
- (NSString *)getVersionInfo;
```
返回形如: **主版本号.次版本号.修订号** 的版本号字符串，版本号递增规则如下：

1. 主版本号：从1开始递增的正整数，当有不兼容的 API 修改时+1
2. 次版本号：从0开始递增的正整数，当新增了向下兼容的新功能时+1，当主版本号增加时归0
3. 修订号：从0开始递增的正整数，当做了向下兼容的问题修正时+1，当次版本号增加时归0

此版本号可用于兼容性判断。

### 获取运行的游戏的 APP ID
```objc
- (NSString *)getAppId;
```
返回 Runtime Core 环境中运行的游戏的唯一标识。

### 获取由游戏绘制的 View 界面
```objc
- (UIView *)getGameView;
```
返回由 Runtime Core 创建的由游戏进行绘制的显示界面，APP 模块可以在里面添加其它界面元素以达到界面定制的目的。

### 设置自定义命令监听者
```objc
- (void)setCustomCommandListener:(id<CRGameCustomCommandListener>)listener;
```
当游戏调用 JS API `callCustomCommand` 时，通过 listener 回调到 APP 模块进行处理。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameCustomCommandListener > listener

    自定义命令监听者

__*CRGameCustomCommandListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onCallCustomCommand:(id< CRGameCustomCommandHandle >)handle<br/>info:(NSDictionary *)argv;|handle:通过此 handle把命令执行结果返回给游戏<br/>argv: JS传入的参数列表 |-|

__*CRGameCustomCommandHandle接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)customCommandSuccess;|-|成功时调用，并将结果返回|
|- (void)customCommandFailure:(NSString *)err;|err:错误描述|失败时调用,如果 err 参数不为 null 此错误信息会返回给 JS |
|- (void)pushResultWithString:(NSString *)res;|res:字符串|添加一个返回给JS的结果|
|- (void)pushResultNull;|-|添加一个返回给JS的 null |
|- (void)pushResultWithBool:(BOOL)res;|res:布尔值|添加一个返回给JS的结果|
|- (void)pushResultWithLong:(long)res;|res:整数|添加一个返回给JS的结果|
|- (void)pushResultWithDouble:(double)res;|res:双精度浮点数|添加一个返回给JS的结果|
|- (void)pushResultWithInt8Arr:(NSData *)res;|res:单字节数组|添加一个返回给JS的结果|
|- (void)pushResultWithInt16Arr:(NSData *)res;|res:双字节数组|添加一个返回给JS的结果|
|- (void)pushResultWithInt32Arr:(NSData *)res;|res:四字节数组|添加一个返回给JS的结果|
|- (void)pushResultWithFloatArr:(NSData *)res;|res:单精度浮点数数组|添加一个返回给JS的结果|
|- (void)pushResultWithDoubleArr:(NSData *)res;|res:双精度浮点数数组|添加一个返回给JS的结果|
|- (void)pushResultWithBoolArr:(NSArray< NSNumber * > *)res;|res:布尔数组|添加一个返回给JS的结果|
|- (void)pushResultWithStringArr:(NSArray< NSString * > *)res;|res:字符串数组|添加一个返回给JS的结果|

`CRGameCustomCommandListener` 处理 JS 调用过来的命令时，需要返回给 JS 的结果通过 `CRGameCustomCommandHandle` 的 `pushResult` 系列 API 按调用顺序先缓存在 handle 中， 在 handle 的 `customCommandSuccess` API 调用时把结果以参数的形式返回给 JS API `callCustomCommand` 的第一个回调对象的 `success` 回调函数。

通过 `pushResult` 系列 API 返回的结果在 JS 中的表现形式为:

| Objective-C类型 | JS 类型 | 说明 |
|:--|:--|:--|
|nil|null|
|BOOL|boolean|
|long|number|
|double|number|
|NSString|string|
|NSData|Int8Array|
|NSData|Int16Array|
|NSData|Int32Array|
|NSData|Float32Array|
|NSData|Float64Array|
|NSArray< NSNumber * >|[boolean]| JS 中所有元素都是 boolean 类型的数组 |
|NSArray< NSString * >|[string]| JS 中所有元素都是 string 类型的数组 |

__*argv 可用字段*__

JS API `callCustomCommand` 调用时除第一个回调对象之外的其它参数都保存在此字段中，读取方法为:
    1. 以 "argc" 为 key 获取参数总数
    2. 以 "type`N`" 为 key 获取第 `N` 个参数的类型
    3. 以 "`N`" 为 key 获取这个参数的值

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"argc"|int|是|参数总数量|
|"type`N`"|String|是|参数类型 |
|"`N`"|&lt;type`N`&gt;|是|参数值; 数据类型为 "null" 时没有此项|

`N` 的取值范围为大于第于0，小于参数总数量的整数。JS API 传入的数据类型到 Objective-C 的对应类型为：

| JS 类型 | Objective-C 类型 | 说明 |
|:--|:--|:--|
|null|nil|
|boolean|BOOL|
|number|long| JS 数字是整数 |
|number|double|JS 数字不是整数 |
|string|NSString|
|Int8Array|NSData|
|Int16Array|NSData|
|Int32Array|NSData|
|Float32Array|NSData|
|Float64Array|NSData|
|[boolean]|NSArray< NSNumber * >| JS 中的数组所有元素类型都是 boolean |
|[number]|NSArray< NSNumber * >| JS 中的数组所有元素类型都是 number |
|[string]|NSArray< NSString * >| JS 中的数组所有元素类型都是 string |

### 执行脚本
```objc
- (void)runScript:(NSString *)script listener:(id<CRGameRunScriptListener>)listener;
```
运行字符串脚本当调用 API `runScript` 时，运行字符串脚本。运行脚本结束后，通过 listener 回调到 APP 模块进行处理。

__*参数*__

- NSString *script

    可执行的 JS 脚本字符串

- id < CRGameRunScriptListener > listener

    运行脚本监听者

__*GameRunScriptListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onRunScriptSuccess:(NSString *)returnType returnInfo:(NSDictionary *)returnValue;|returnType:执行脚本成功的返回值类型<br/>returnValue: 执行脚本成功的返回值<br/>|-|
|- (void)onRunScriptFailure:(NSString *)error;|error: 错误描述|-|

__*returnValue 可用字段*__

运行 自定义脚本 成功后，返回的数据都保存在此字段中，读取方法为:以 "value" 为 key 获取这个参数的值

|属性|数据类型|是否必填|说明|
|:--|:--|:--|:--|
|"value"|&lt;type&gt;|是|参数值; 数据类型为 "null" 时没有此项|

脚本的返回值的数据类型到 Objective-C 的对应类型为：

| JS 类型 | Objective-C 类型 |
|:--|:--|
|null|nil|
|boolean|NSNumber|
|number|NSNumber|
|string|NSString|

## 应用生命周期事件 APIs

### 应用暂停事件
```objc
- (void)didEnterBackground;
```
应用的 App Delegate 收到系统的 applicationDidEnterBackground 事件时,通过此接口把事件传递给 Runtime Core 以进行正确响应。

### 应用暂停恢复事件
```objc
- (void)willEnterForeground;
```
应用的 App Delegate 收到系统的 applicationWillEnterForeground 事件时,通过此接口把事件传递给 Runtime Core 以进行正确响应。

## 游戏权限申请相关 APIs

__*CRPermission枚举值*__

| 枚举值 | 说明 |
|:--|:--|
| CR_LOCATION | 位置权限 |
| CR_RECORD | 录音权限 |
| CR_USER_INFO | 获取用户信息权限 |
| CR_WRITE_PHOTOS_ALBUM | 写图片到相册权限 |
| CR_CAMERA | 摄像头权限 |

### 设置游戏请求权限对话框监听者
```objc
- (void)setGameQueryPermissionDialogListener:(id<CRGameQueryPermissionDialogListener>)listener;
```
当游戏调用 `authorize` JS API 接口申请权限时，会通过设置的 listener 来显示权限首次申请界面。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameQueryPermissionDialogListener > listener

    游戏请求权限对话框监听者，APP模块可以在 listener 被调用时，展示自定义的权限申请对话框。

__*CRGameQueryPermissionDialogListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onAuthDialogShow:(id< CRGameAuthDialogHandle >)handle permission:(CRPermission)per;|handle:当用户点击对话框中的授权/拒绝按钮时，通过此 handle把结果返回 Runtime Core<br/>per:游戏申请的权限枚举值 | 当游戏首次申请某个权限时，回调此接口|

__*CRGameAuthDialogHandle接口*__

当用户点击授权界面的按钮时，通过此接口的 API 把用户的操作传递给 Runtime Core。

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)handleGamePermission:<br/>(CRPermission)per granted:(BOOL)isGranted;|per:游戏申请的权限枚举值<br/>isGranted:用户是否授权|-|

### 设置游戏申请权限所需的系统权限对话框监听者
```objc
- (void)setGameOpenSysPermTipDialogListener:(id<CRGameOpenSysPermTipDialogListener>)listener;
```
当游戏申请的权限对应到某个系统权限，比如 CR_LOCATION，在用户给以游戏权限后，但 APP 还没有得到系统授权时，会通过设置的 listener 来显示'提示用户需要通过设置给予 APP 对应的系统权限'对话框。listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameOpenSysPermTipDialogListener > listener

    游戏请求权限需求系统授权提示对话框监听者，APP模块可以在 listener 被调用时，展示自定义的提示对话框，对话框中至少应该有"去设置"和"拒绝"两个按钮。

__*GameOpenSysPermTipDialogListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onAuthDialogShowWithPermission:<br/>(CRPermission)per;|per: 游戏申请的权限枚举值 | 当游戏首次申请某个权限时，回调此接口|

### 设置游戏权限设置对话框监听者
```objc
- (void)setGameOpenSettingDialogListener:(id<CRGameOpenSettingDialogListener>)listener;
```
当游戏通过 JS API `openSetting` 时，会通过此接口的 listener 打开用户权限设置对话框。用户权限设置对话框负责把当前对此游戏的权限显示在界面上，供用户进行授权/取消授权操作。listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameOpenSettingDialogListener > listener

    游戏权限设置对话框监听者

__*CRGameOpenSettingDialogListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onSettingDialogOpen:(id< CRGameAuthoritySettingHandle >)handle permissionList:(NSDictionary<NSNumber *, NSNumber * >*)perMap;|handle: 用户进行权限操作时通过此 handle 把改动传递给 Runtime Core<br/>perMap:当前的授权状态表，没有申请过的权限不显示| 当游戏调用openSetting时调用|
|- (void)onPermissionChanged:<br/>(CRPermission)permission granted:(BOOL)isGranted;|permission: 变动的权限枚举<br/>isGranted: 变动后的权限值|当 Core 中的权限变更时通过此接口通知 APP 模块更新界面展示|

__*CRGameAuthoritySettingHandle接口*__

当用户在游戏权限设置对话框中进行权限操作时，通过此接口把变动传递给 Runtime Core。

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)changePermission:<br/>(CRPermission)permission granted:(BOOL)isGranted viewController:(UIViewController *)vc;|permission: 变动的权限枚举<br/>isGranted: 变动后的权限值| 当用户修改权限时 APP 模块应调用此接口 |
|- (void)finish;|-| 当游戏权限设置对话框关闭时 APP模块应调用此接口

## 游戏功能相关 APIs

### 设置游戏申请用户信息监听者
```objc
- (void)setGameUserInfoListener:(id<CRGameUserInfoListener>)listener;
```
当游戏调用 JS API `getUserInfo` 时，通过 listener 回调到 APP 模块进行处理。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameUserInfoListener > listener

    游戏申请用户信息监听者

__*GameUserInfoListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)queryUserInfo:(id< CRGameUserInfoHandle >)handle;|handle:通过此 handle 把用户信息返回给游戏| 当游戏请求用户信息时回调 |

__*CRGameUserInfoHandle接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onGetUserInfoSuccess;|-|成功时调用|
|- (void)onGetUserInfoFailure;|-|失败时调用|
|- (void)onGetUserInfoCancel;|-|取消时调用|
|- (void)setUserInfo:(NSDictionary *)info;|info: 用户数据信息 | 返回用户数据信息 |

### 设置图片选择监听者
```objc
- (void)setGameChooseImageListener:(id<CRGameChooseImageListener>)listener;
```
当游戏调用 JS API `chooseImage` 时，通过 listener 回调到 APP 模块进行处理。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameChooseImageListener > listener

    图片选择监听者

__*CRGameChooseImageListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onChooseImage:(id< CRGameChooseImageHandle >)handle withSourceType:(NSString **))sourceType withCount:(NSUInteger)count;|handle:通过此 handle把选择的图片返回给游戏<br/>sourceType:指定选择图片的来源<br/>count:希望选择的张数 | 当游戏请求选择图片时回调 |

__*CRGameChooseImageHandle接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onChooseImageSuccess:(NSArray *)imageInfos;)|imageInfos: 用户选择的图片列表|成功时调用|
|- (void)onChooseImageFailure;|-|失败时调用|
|- (void)onChooseImageCancel;|-|取消时调用|

### 设置图片预览监听者
```objc
- (void)setGamePreviewImageListener:(id<CRGamePreviewImageListener>)listener;
```
当游戏调用 JS API `previewImage` 时，通过 listener 回调到 APP 模块进行处理。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGamePreviewImageListener > listener

    图片选择监听者

__*GameChooseImageListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onPreviewImage:(id< CRGamePreviewImageHandle >)handle<br/>withPath:(NSArray *)paths<br/>withIndex:(NSUInteger)index;|handle:通过此 handle把预览结果返回给游戏<br/>index:默认显示的图片<br/>paths:需要预览的<br/>图片本地路径或者网络URL列表 | 当游戏请求预览图片时回调 |

__*CRGamePreviewImageHandle接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onPreviewImageSuccess;|-|成功时调用|
|- (void)onPreviewImageFailure;|-|失败时调用|
|- (void)onPreviewImageCancel;|-|取消时调用|

### 设置加载游戏分包监听者
```objc
- (void)setGameLoadSubpackageListener:(id<CRGameLoadSubpackageListener>)listener;
```
当游戏调用 JS API `loadSubpackage` 时，通过 listener 回调到 APP 模块进行处理。
listener 的设置是弱引用，需要集成方自己持有。

__*参数*__

- id < CRGameLoadSubpackageListener > listener

    游戏加载分包监听者

__*CRGameLoadSubpackageListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|- (void)onLoadSubpackage:(id< CRGameLoadSubpackageHandle >)handle root:(NSString *)root; |handle:通过此 handle把下载并安装分包的结果返回给游戏<br/>root: 根据该值计算分包的 URL | 当游戏请求加载分包时回调 |

__*CRGameLoadSubpackageHandle接口*__

|接口|接口参数|说明|
|:--|:--|:--|
| - (void)onLoadSubpackageSuccess;|-|APP模块安装分包成功时调用此接口通知 JS|
| - (void)onLoadSubpackageFailure:(NSString *)error;|error:包含失败的错误描述|APP模块安装或下载分包失败时调用此接口通知 JS|
|- (void)onLoadSubpackageProgress:(NSInteger)written total:(NSInteger)total;|written:已写入的数据大小<br/>total:需要加载的数据大小|APP模块更新加载分包进度时调用此接口通知 JS|

### 设置丢帧警告监听者
```objc
-(void)setSkippedFrameWarningListener:(id<CRSkippedFrameWarningListener>)listener;
```

设置丢帧警告监听者。listener 的设置是弱引用，需要集成方自己持有。

__*版本: >= 1.3.0*__

__*参数*__

- id < CRSkippedFrameWarningListener > listener

丢帧警告监听者

__*CRSkippedFrameWarningListener接口*__

|接口|接口参数|说明|
|:--|:--|:--|
|(void)onFramesSkipped:(int)frames;| frames 丢帧数 | 游戏运行过程中丢帧数达到 rt_run_debug_skipped_frame_warning_limit 设置值时回调 |
