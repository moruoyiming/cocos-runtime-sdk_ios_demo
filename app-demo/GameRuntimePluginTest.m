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
#import "GameRuntimePluginTest.h"

#import <lib_rt_core/CRCocosGameConfig.h>
#import <lib_rt_core/CRCocosGamePluginManager.h>
#import <lib_rt_core/CRCocosGameRuntime.h>

static NSString * const _GAME_CONFIG_PLUGIN_ITEM_PROVIDER = @"provider";
static NSString * const _GAME_CONFIG_PLUGIN_ITEM_PATH = @"path";

@interface GameRuntimePluginTestView : UIView
@property (nonatomic, strong) UIButton *getConfigBtn;
@property (nonatomic, strong) UIButton *checkPluginBtn;
@property (nonatomic, strong) UIButton *installPluginBtn;
@property (nonatomic, strong) UIButton *removePluginBtn;

@property (nonatomic, copy) void(^onGetConfig)(void);
@property (nonatomic, copy) void(^onCheckPlugin)(void);
@property (nonatomic, copy) void(^onInstallPlugin)(void);
@property (nonatomic, copy) void(^onRemovePlugin)(void);
@end

@implementation GameRuntimePluginTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *btnBgColor = [UIColor grayColor];
        self.getConfigBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"获取游戏配置" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setBackgroundColor:btnBgColor];
            [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.getConfigBtn];
        
        self.checkPluginBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"检查plugin" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setBackgroundColor:btnBgColor];
            [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.checkPluginBtn];
        
        self.installPluginBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"安装plugin" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setBackgroundColor:btnBgColor];
            [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.installPluginBtn];
        
        self.removePluginBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"卸载plugin" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setBackgroundColor:btnBgColor];
            [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.removePluginBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.getConfigBtn setFrame:[self _getRectAtIndex:0]];
    [self.checkPluginBtn setFrame:[self _getRectAtIndex:1]];
    [self.installPluginBtn setFrame:[self _getRectAtIndex:2]];
    [self.removePluginBtn setFrame:[self _getRectAtIndex:3]];
    
    CGRect rect = CGRectMake(0,
                             0,
                             self.superview.frame.size.width,
                             self.removePluginBtn.frame.size.height + self.removePluginBtn.frame.origin.y);
    for (UIView *view in self.superview.subviews) {
        if (view == self || [view isKindOfClass:[UILabel class]]) {
            continue;
        }
        if (CGRectIntersectsRect(rect, view.frame)) {
            rect = CGRectMake(0,
                              view.frame.size.height + view.frame.origin.y + 5,
                              rect.size.width,
                              rect.size.height);
        }
    }
    [self setFrame:rect];
    [self.superview setNeedsLayout];
}

#pragma mark - Private
- (CGRect)_getRectAtIndex:(NSInteger)index {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    BOOL isPortrait = screenWidth < screenHeight;
    CGFloat beginX = 5;
    CGFloat space = 5;
    CGFloat beginY = 0;
    CGFloat btnHeight = 40;
    CGFloat btnWidth = isPortrait ? (screenWidth - space*2 - beginX*2)/3 : (screenWidth - space*4 - beginX*2)/5;
    CGRect rect = CGRectMake(beginX + (space + btnWidth)*(index%3), beginY + (space + btnHeight)*(index/3), btnWidth, btnHeight);
    if (!isPortrait) {
        rect = CGRectMake(beginX + (space + btnWidth)*index, beginY, btnWidth, btnHeight);
    }
    return rect;
}

- (void)_onClickButton:(UIButton *)sender {
    if (sender == self.getConfigBtn) {
        if (self.onGetConfig) {
            self.onGetConfig();
        }
    } else if (sender == self.checkPluginBtn) {
        if (self.onCheckPlugin) {
            self.onCheckPlugin();
        }
    } else if (sender == self.installPluginBtn) {
       if (self.onInstallPlugin) {
           self.onInstallPlugin();
       }
    } else if (sender == self.removePluginBtn) {
       if (self.onRemovePlugin) {
           self.onRemovePlugin();
       }
    }
}

@end

@interface GameRuntimePluginTest () <CRPluginCheckVersionListener, CRPluginInstallListener, CRPluginRemoveListener>
@property (nonatomic, weak) id<CRCocosGameRuntime> gameRuntime;
@property (nonatomic, copy) NSDictionary *gameInfo;
@property (nonatomic, strong) GameRuntimePluginTestView *containerView;
@property (nonatomic, weak) id<CRCocosGamePluginManager> pluginManager;
@property (nonatomic, copy) NSArray<NSDictionary *> *plugins;
@property (nonatomic, assign) NSInteger currentCheckPluginIndex;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *needInstallPlugins;
@property (nonatomic, assign) NSInteger currentInstallPluginIndex;
@end

@implementation GameRuntimePluginTest
- (instancetype)initWithRuntime:(id<CRCocosGameRuntime>)gameRuntime gameInfo:(NSDictionary *)gameInfo {
    self = [super init];
    if (self) {
        self.gameRuntime = gameRuntime;
        self.gameInfo = gameInfo;
        self.needInstallPlugins = [NSMutableArray array];
        
        __weak typeof(self) weakSelf = self;
        self.containerView = [[GameRuntimePluginTestView alloc] init];
        [self.containerView setOnGetConfig:^{
            id<CRCocosGameConfig> gameConfig = [weakSelf.gameRuntime getGameConfig:weakSelf.gameInfo];
            if (!gameConfig) {
                [weakSelf _onUpdateMessage:@"获取游戏配置失败，请重新安装游戏!"];
                return;
            }
            weakSelf.plugins = [gameConfig plugins];
            NSString *infoStr = @"获取游戏配置成功: ";
            if ([weakSelf.plugins count] == 0) {
                infoStr = [infoStr stringByAppendingFormat:@"空插件列表"];
            } else {
                for (const NSDictionary *plugin in weakSelf.plugins) {
                    infoStr = [infoStr stringByAppendingFormat:@"%@",[plugin objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
                }
            }
            [weakSelf _onUpdateMessage:infoStr];
        }];
        [self.containerView setOnCheckPlugin:^{
            weakSelf.currentCheckPluginIndex = 0;
            [weakSelf.needInstallPlugins removeAllObjects];
            if (!weakSelf.plugins) {
                [weakSelf _onUpdateMessage:@"请先获取游戏配置"];
                return;
            }
            if ([weakSelf.plugins count] == 0) {
                [weakSelf _onUpdateMessage:@"游戏未配置插件"];
                return;
            }
            [weakSelf _checkGamePlugin];
        }];
        [self.containerView setOnInstallPlugin:^{
            weakSelf.currentInstallPluginIndex = 0;
            [weakSelf _installGamePlugin];
        }];
        [self.containerView setOnRemovePlugin:^{
            NSMutableArray *removePlugins = [NSMutableArray array];
            NSString *path;
            if (weakSelf.plugins) {
                for (const NSDictionary *pluginInfo in weakSelf.plugins) {
                    path = [pluginInfo objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PATH];
                    if (!path || [path isEqualToString:@""]) {
                        [removePlugins addObject:pluginInfo];
                    }
                }
            }
            if ([removePlugins count] == 0) {
                [weakSelf _onUpdateMessage:@"plugin卸载完成"];
            } else {
                [weakSelf.pluginManager removePluginList:removePlugins listener:weakSelf];
            }
        }];
    }
    return self;
}

- (void)setOnMessageUpdate:(void (^)(NSString * _Nonnull))onMessageUpdate {
    _onMessageUpdate = onMessageUpdate;
}

- (void)addToView:(UIView *)parent {
    self.pluginManager = [self.gameRuntime getManager:@"plugin_manager" options:nil];
    if (!self.pluginManager) {
        return;
    }
    [parent addSubview:self.containerView];
}

# pragma mark - Private
- (void)_onUpdateMessage:(NSString *)msg {
    if (self.onMessageUpdate) {
        self.onMessageUpdate(msg);
    }
}

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
        NSString *infoStr = @"检查plugin完成";
        if (self.plugins && [self.plugins count] > 0) {
            for (const NSDictionary *pluginInfo in self.plugins) {
                NSString *provider = [pluginInfo objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER];
                infoStr = [infoStr stringByAppendingFormat:@"\n%@",provider];
            }
        } else {
            infoStr = [infoStr stringByAppendingFormat:@"\n空插件列表"];
        }
        infoStr = [infoStr stringByAppendingFormat:@"\n需要安装下列插件:"];
        for (const NSDictionary *pluginInfo in self.needInstallPlugins) {
            NSString *provider = [pluginInfo objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER];
            infoStr = [infoStr stringByAppendingFormat:@"\n%@",provider];
        }
        [self _onUpdateMessage:infoStr];
    } else {
        [self.pluginManager checkPluginVersion:pluginInfo listener:self];
        self.currentCheckPluginIndex++;
    }
}

- (void)_installGamePlugin {
    if (self.currentInstallPluginIndex >= [self.needInstallPlugins count]) {
        [self _onUpdateMessage:@"安装plugin完成"];
    } else {
        [self.pluginManager installPlugin:[self.needInstallPlugins objectAtIndex:_currentInstallPluginIndex] listener:self];
        self.currentInstallPluginIndex++;
    }
}

#pragma mark - CRPluginCheckVersionListener
- (void)onCheckPluginFailure:(NSDictionary *)info error:(NSError *)error {
    [self.needInstallPlugins addObject:info];
    NSString *msg = [NSString stringWithFormat:@"检查plugin不存在：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
    [self _checkGamePlugin];
}

- (void)onCheckPluginSuccess:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"检查plugin完成：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
    [self _checkGamePlugin];
}

- (void)onCheckPluginVersionStart:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"检查plugin插件：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
}

//#pragma mark - CRPluginInstallListener
- (void)onPluginDownloadProgress:(NSDictionary *)info downloadSize:(long)downloadedSize totalSize:(long)totalSize {}

- (void)onPluginDownloadRetry:(NSDictionary *)info retryNo:(long)retryNo {}

- (void)onPluginInstallFailure:(NSDictionary *)info error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"安装plugin失败，请尝试下载游戏完整包：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
}

- (void)onPluginInstallStart:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"安装plugin：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
}

- (void)onPluginInstallSuccess:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"安装plugin完成：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
    [self _installGamePlugin];
}

#pragma mark - CRPluginRemoveListener
- (void)onPluginRemoveFailure:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"卸载plugin失败：%@",error];
    [self _onUpdateMessage:msg];
}

- (void)onPluginRemoveFinish:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"卸载plugin完成：%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
}

- (void)onPluginRemoveStart:(NSDictionary *)info {
    NSString *msg = [NSString stringWithFormat:@"卸载plugin...%@",[info objectForKey:_GAME_CONFIG_PLUGIN_ITEM_PROVIDER]];
    [self _onUpdateMessage:msg];
}

- (void)onPluginRemoveSuccess:(NSArray<NSDictionary *> *)removeList {
    [self _onUpdateMessage:@"卸载plugin成功"];
}

@end
