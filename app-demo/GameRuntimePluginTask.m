/*******************************************************************************
Xiamen Yaji Software Co., Ltd., (the “Licensor”) grants the user (the “Licensee”
) non-exclusive and non-transferable rights to use the software according to
the following conditions:
a.  The Licensee shall pay royalties to the Licensor, and the amount of those
    royalties and the payment method are subject to separate negotiations
    between the parties.
b.  The software is licensed for use rather than sold, and the Licensor reserves
    all rights over the software that are not expressly granted (whether by
    implication, reservation or prohibition).
c.  The open source codes contained in the software are subject to the MIT Open
    Source Licensing Agreement (see the attached for the details);
d.  The Licensee acknowledges and consents to the possibility that errors may
    occur during the operation of the software for one or more technical
    reasons, and the Licensee shall take precautions and prepare remedies for
    such events. In such circumstance, the Licensor shall provide software
    patches or updates according to the agreement between the two parties. the
    Licensor will not assume any liability beyond the explicit wording of this
    Licensing Agreement.
e.  Where the Licensor must assume liability for the software according to
    relevant laws, the Licensor’s entire liability is limited to the annual
    royalty payable by the Licensee.
f.  The Licensor owns the portions listed in the root directory and subdirectory
    (if any) in the software and enjoys the intellectual property rights over
    those portions. As for the portions owned by the Licensor, the Licensee
    shall not:
    i.  Bypass or avoid any relevant technical protection measures in the
        products or services;
    ii. Release the source codes to any other parties;
    iii.Disassemble, decompile, decipher, attack, emulate, exploit or
        reverse-engineer these portion of code;
    iv. Apply it to any third-party products or services without Licensor’s
        permission;
    v.  Publish, copy, rent, lease, sell, export, import, distribute or lend any
        products containing these portions of code;
    vi. Allow others to use any services relevant to the technology of these
        codes; and
    vii.Conduct any other act beyond the scope of this Licensing Agreement.
g.  This Licensing Agreement terminates immediately if the Licensee breaches
    this Agreement. The Licensor may claim compensation from the Licensee where
    the Licensee’s breach causes any damage to the Licensor.
h.  The laws of the People's Republic of China apply to this Licensing Agreement.
i.  This Agreement is made in both Chinese and English, and the Chinese version
    shall prevail the event of conflict.

*******************************************************************************/
#import "GameRuntimePluginTask.h"

#import <lib_rt_core/CRCocosGameConfig.h>
#import <lib_rt_core/CRCocosGamePluginManager.h>
#import <lib_rt_core/CRCocosGameRuntime.h>

static NSString * const _GAME_CONFIG_PLUGIN_ITEM_PROVIDER = @"provider";
static NSString * const _GAME_CONFIG_PLUGIN_ITEM_PATH = @"path";

@interface GameRuntimePluginTask () <CRPluginCheckVersionListener, CRPluginInstallListener>
@property (nonatomic, copy) NSDictionary *packageInfo;
@property (nonatomic, weak) id<CRCocosGameRuntime> gameRuntime;
@property (nonatomic, weak) id<GameRuntimeTaskListener> listener;
@property (nonatomic, weak) id<CRCocosGamePluginManager> pluginManager;
@property (nonatomic, copy) NSArray<NSDictionary *> *plugins;
@property (nonatomic, assign) NSInteger currentCheckPluginIndex;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *needInstallPlugins;
@property (nonatomic, assign) NSInteger currentInstallPluginIndex;
@end

@implementation GameRuntimePluginTask

- (instancetype)initWithPackageInfo:(NSDictionary *)packageInfo gameRuntime:(id<CRCocosGameRuntime>)gameRuntime listener:(id<GameRuntimeTaskListener>)listener
{
    self = [super init];
    if (self) {
        self.packageInfo = packageInfo;
        self.gameRuntime = gameRuntime;
        self.listener = listener;
        self.needInstallPlugins = [NSMutableArray array];
    }
    return self;
}

- (void)execute {
    self.currentCheckPluginIndex = 0;
    self.currentInstallPluginIndex = 0;
    [self.needInstallPlugins removeAllObjects];
    self.pluginManager = [self.gameRuntime getManager:@"plugin_manager" options:nil];
    if (!self.pluginManager) {
        [self.listener onTaskSucceed];
        return;
    }
    id<CRCocosGameConfig> gameConfig = [self.gameRuntime getGameConfig:self.packageInfo];
    if (!gameConfig) {
        [self.listener onTaskFailed:GAME_RUNTIME_TASK_GAME_CONFIG_ERROR error:[NSError errorWithDomain:@"get game.config.json failed" code:0 userInfo:nil]];
        return;
    }
    self.plugins = gameConfig.plugins;
    [self _checkGamePlugin];
}

# pragma mark - Private
- (void)_checkGamePlugin {
    NSDictionary *pluginInfo = nil;
    NSString *path;
    while (self.plugins && _currentCheckPluginIndex < [self.plugins count]) {
        pluginInfo = [self.plugins objectAtIndex:self.currentCheckPluginIndex];
        path = [pluginInfo objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PATH];
        if (!path || [path isEqualToString:@""]) {
            // 插件配置信息中不包含 path 信息才需要检查
            break;
        }
        pluginInfo = nil;
        _currentCheckPluginIndex++;
    }
    if (!pluginInfo) {
        [self _installGamePlugin];
    } else {
        [self.pluginManager checkPluginVersion:pluginInfo listener:self];
        self.currentCheckPluginIndex++;
    }
}

- (void)_installGamePlugin {
    if (self.currentInstallPluginIndex >= [self.needInstallPlugins count]) {
        // 没有需要安装的插件，直接进入游戏
        [self.listener onTaskMessageChange:@"安装游戏插件完成"];
        [self.listener onTaskSucceed];
    } else {
        [self.pluginManager installPlugin:[self.needInstallPlugins objectAtIndex:_currentInstallPluginIndex] listener:self];
        self.currentInstallPluginIndex++;
    }
}

#pragma mark - CRPluginCheckVersionListener
- (void)onCheckPluginFailure:(NSDictionary *)info error:(NSError *)error {
    [self.needInstallPlugins addObject:info];
    NSString *msg = [NSString stringWithFormat:@"检查游戏插件不存在：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
    [self _checkGamePlugin];
}

- (void)onCheckPluginSuccess:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"检查游戏插件完成：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
    [self _checkGamePlugin];
}

- (void)onCheckPluginVersionStart:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"检查游戏插件：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
}

#pragma mark - CRPluginInstallListener
- (void)onPluginDownloadProgress:(NSDictionary *)info downloadSize:(long)downloadedSize totalSize:(long)totalSize {}

- (void)onPluginDownloadRetry:(NSDictionary *)info retryNo:(long)retryNo {}

- (void)onPluginInstallFailure:(NSDictionary *)info error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"安装游戏插件失败，请尝试下载游戏完整包：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
    [self.listener onTaskFailed:GAME_RUNTIME_TASK_PLUGIN_ERROR error:error];
}

- (void)onPluginInstallStart:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"安装游戏插件：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
}

- (void)onPluginInstallSuccess:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"安装游戏插件完成：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self.listener onTaskMessageChange:msg];
    [self _installGamePlugin];
}

@end
