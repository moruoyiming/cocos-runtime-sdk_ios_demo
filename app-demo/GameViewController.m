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


#import "GameViewController.h"
#import "GameEnv.h"
#import <lib_rt_core/CRGameHandleInternal.h>
#import <lib_rt_core/CRCocosGameRuntime.h>
#import <lib_rt_frame/CRCocosGame.h>
#import "DummyData.h"
#import "SDKLaunchUtil.h"
#import "AuthSettingViewController.h"
#import "CustomCommand.h"

@interface GamePermissionView : UIView
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLbl;
@property (nonatomic, strong) UIButton *negBtn;
@property (nonatomic, strong) UIButton *posBtn;
- (void)show;
@property (nonatomic, copy) void(^completePermission)(BOOL isPositive);
@end

@implementation GamePermissionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self _initView];
    }
    return self;
}

- (void)_initView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight / 2.0)];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.bgView];
    
    self.msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, screenWidth, 30)];
    [self.msgLbl setTextAlignment:NSTextAlignmentLeft];
    [self.msgLbl setFont:[UIFont systemFontOfSize:24]];
    [self.bgView addSubview:self.msgLbl];
    
    CGFloat space = 14.f;
    self.negBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(space, screenHeight / 2.0 - 80, (screenWidth - space * 3) / 2.0, 40)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
        [btn setTitle:@"拒绝" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.bgView addSubview:self.negBtn];
    
    self.posBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(space * 2 + (screenWidth - space * 3) / 2.0, screenHeight / 2.0 - 80, (screenWidth - space * 3) / 2.0, 40)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:101/255.0 green:193/255.0 blue:226/255.0 alpha:1.0]];
        [btn setTitle:@"允许" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.bgView addSubview:self.posBtn];
  
}

- (void)_onClickButton:(UIButton *)sender {
    if (self.completePermission) {
        BOOL isPositive = NO;
        if (sender == self.posBtn) {
            isPositive = YES;
        }
        self.completePermission(isPositive);
        [self _hide];
    }
}

- (void)show {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [self.msgLbl setText:self.msg];
    [UIView animateWithDuration:0.4 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.5]];
        [self.bgView setFrame:CGRectMake(0, screenHeight / 2.0, screenWidth, screenHeight / 2.0)];
    }];
}

- (void)_hide {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [self.msgLbl setText:self.msg];
    [UIView animateWithDuration:0.4 animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
        [self.bgView setFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight / 2.0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}
@end

@interface GameLoadSubpackageHandle : NSObject <CRPackageInstallListener, CRPackageDownloadListener>
@property (nonatomic, copy) NSString *root;
@property (nonatomic, weak) id<CRGameLoadSubpackageHandle> handle;
@property (nonatomic, weak) GameViewController *gameVC;
@end

@interface GameViewController () <SDKTestLaunchListener, CRRuntimeInitializeListener, CRPackageCheckVersionListener, CRPackageDownloadListener, CRPackageInstallListener, CRGameRunListener, CRGameQueryExitListener, CRGameExitListener, CRGameUserInfoListener, CRGameQueryPermissionDialogListener, CRGameOpenSettingDialogListener, CRGameOpenSysPermTipDialogListener, CRGameLoadSubpackageListener, CRGameRemoveListener, CRSKippedFrameWarningListener, GameRuntimeTaskListener, CRGameCustomCommandListener ,CRGameRunScriptListener>
@property (nonatomic, strong) UIView<LoadingViewHandle> *loadingView;
@property (nonatomic, strong) GamePermissionView *permissionView;
@property (nonatomic, strong) AuthSettingViewController *authVC;
@property (nonatomic, strong) SDKLaunchUtil *SDKLauncher;
@property (nonatomic, strong) GameLoadSubpackageHandle *gameSubpackageListener;
@property (nonatomic, strong) CustomCommand *customCommand;
@property (nonatomic, copy) NSDictionary *gameInfo;
@property (nonatomic, weak) id<CRCocosGameRuntime> gameRuntime;
@property (nonatomic, weak) id<CRCocosGameHandle> gameHandle;
@property (nonatomic, copy) NSString *gamePackagePath;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *extend;
@property (nonatomic, assign) NSInteger orientation;
@property (nonatomic, assign) BOOL isSDKLaunchTest;
@property (nonatomic, strong) NSMutableArray<id<GameRuntimeTask>> *gameRuntimeTasks;
@property (nonatomic, assign) NSInteger currentTaskIndex;
@property (nonatomic, assign) BOOL isReinstall;
@property (nonatomic, strong) id<GameRuntimeTask> testPlugin;
@end

@implementation GameViewController



- (instancetype)initWithData:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.userId = [info objectForKey:SP_KEY_USER_ID];
        self.appId = [info objectForKey:KEY_APP_ID];
        self.extend = [info objectForKey:KEY_NAME];
        self.orientation = [[info objectForKey:KEY_ORIENTATION] integerValue];
        self.isSDKLaunchTest = [[GameEnv getInstance] isSdkLaunchTest];
        NSString *version = [info objectForKey:KEY_VERSION];
        NSString *hash = [info objectForKey:KEY_HASH];
        NSString *url =[info objectForKey:KEY_URL];
        //游戏地址被修改
//        [GameEnv buildGamePackageRequest:self.appId version:version];
        self.gameInfo = [GameEnv buildAppOptions:self.appId version:version url:url hash:hash];
        
        self.customCommand = [[CustomCommand alloc] init];
        
        self.gameRuntimeTasks = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [CRCocosGame initRuntime:self.userId options:[GameEnv buildRuntimeOptions] listener:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.gameHandle) {
        [self.gameHandle willEnterForeground];
    }
    
    
    [self.loadingView setFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.gameHandle) {
        [self.gameHandle didEnterBackground];
    }
}

- (void)setEnterView:(NSDictionary *)info {
    self.SDKLauncher = [[SDKLaunchUtil alloc] initWithListener:self isTest:self.isSDKLaunchTest];
    self.loadingView = [LoadingViewFactory createWithIsDebugger:self.isSDKLaunchTest listener:self info:info];
    __weak typeof(self) weakSelf = self;
    [self.loadingView setCloseCallback:^{
        [weakSelf _onButtonClickExit];
    }];
    [self.view addSubview:self.loadingView];
    
    if (self.isSDKLaunchTest) {
        // 只有在测试模式才需需要添加测试的界面
        Class pluginTestClass = NSClassFromString(@"GameRuntimePluginTest");
        if (pluginTestClass &&
            [self.gameRuntime getManager:@"plugin_manager" options:nil]) {
            self.testPlugin = [pluginTestClass alloc];
            // 调用 init 方法
            SEL initSel = NSSelectorFromString(@"initWithRuntime:gameInfo:");
            IMP initImp = [pluginTestClass instanceMethodForSelector:initSel];
            id (*initFun)(id, SEL, id<CRCocosGameRuntime>, NSDictionary *) = (void *)initImp;
            self.testPlugin = initFun(self.testPlugin, initSel, self.gameRuntime, self.gameInfo);
            
            SEL updateMessageSel = NSSelectorFromString(@"setOnMessageUpdate:");
            IMP updateMessageImp = [pluginTestClass instanceMethodForSelector:updateMessageSel];
            void (*updateMessageFun)(id, SEL, void(^)(NSString *)) = (void *)updateMessageImp;
            updateMessageFun(self.testPlugin, updateMessageSel, ^(NSString * _Nonnull msg) {
                [weakSelf.loadingView setTipText:msg];
            });
            
            SEL addViewSel = NSSelectorFromString(@"addToView:");
            IMP addViewImp = [pluginTestClass instanceMethodForSelector:addViewSel];
            void (*addViewFun)(id, SEL, UIView *) = (void *)addViewImp;
            addViewFun(self.testPlugin, addViewSel, self.loadingView);
        }
    }
}

#pragma mark - orientation
- (BOOL)shouldAutorotate {
    return false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.orientation == 1) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.orientation == 1) {
        return UIInterfaceOrientationPortrait;
    } else {
        return UIInterfaceOrientationLandscapeRight;
    }
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Controls the application's preferred home indicator auto-hiding when this view controller is shown.
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_runGame {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_VERSION] forKey:CR_KEY_RUN_OPT_VERSION];
    if (self.extend) {
        [dic setValue:self.extend forKey:CR_KEY_RUN_OPT_EXTEND_DATA];
    }
    
    NSString *launchOption = [[GameEnv getInstance] getLaunchOptions];
    if (launchOption) {
        [dic setValue:launchOption forKey:CR_KEY_RUN_OPT_APP_LAUNCH_OPTIONS];
    }
    BOOL isShowFps = [[GameEnv getInstance] isShowFPS];
    [dic setValue:[NSNumber numberWithBool:isShowFps] forKey:CR_KEY_RUN_DEBUG_SHOW_DEBUG_VIEW];
    BOOL isShowGameLoadingLog = [[GameEnv getInstance] isShowGameLoadingTimeLog];
    [dic setValue:[NSNumber numberWithBool:isShowGameLoadingLog] forKey:CR_KEY_RUN_DEBUG_SHOW_GAME_LOADING_TIME_LOG];
    NSInteger skippedFrameWarning = [[GameEnv getInstance] getSkippedFrameWarning];
    [dic setValue:[NSNumber numberWithInteger:skippedFrameWarning] forKey:CR_KEY_RUN_DEBUG_SKIPPED_FRAME_WARNING_LIMIT];
    BOOL isEnableVConsole = [[GameEnv getInstance] isVConsoleEnabled];
    [dic setValue:@(isEnableVConsole) forKey:@"rt_run_debug_enable_vconsole"];
    
    [self.gameRuntime runGame:self appId:self.appId options:dic listener:self];
}

- (void)_exit {
    [self.view removeFromSuperview];
    if (self.gameRuntime) {
        if (self.gameHandle) {
            [self.gameRuntime exitGame:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_APP_ID] listener:self];
        }
    }
}

- (void)_prepareGameError:(NSString *)tip {
    [self.loadingView setTipText:tip];
}

- (NSString *)_gerPermisssionHint:(CRPermission)permission {
    NSString *msg;
    if (permission == CR_LOCATION) {
        msg = @"游戏正在请求您的位置权限";
    } else if (permission == CR_RECORD) {
        msg = @"游戏正在请求您的录音权限";
    } else if (permission == CR_WRITE_PHOTOS_ALBUM) {
        msg = @"游戏正在请求您的相册权限";
    } else if (permission == CR_CAMERA) {
        msg = @"游戏正在请求您的相机权限";
    } else if (permission == CR_USER_INFO) {
        msg = @"游戏正在请求您的个人信息权限";
    }
    return msg;
}

- (void)_executeGameRuntimeTask {
    if (self.currentTaskIndex == [_gameRuntimeTasks count]) {
        [self.SDKLauncher handleRunGame];
        return;
    }
    [[self.gameRuntimeTasks objectAtIndex:self.currentTaskIndex++] execute];
}

#pragma mark - initialize delegate
- (void)onInitializeFailure:(NSException *)exception {
    NSLog(@"%@",exception);
}

- (void)onInitializeSuccess:(NSObject<CRCocosGameRuntime> *)instance {
    [self setGameRuntime:instance];
    [self setEnterView:self.gameInfo];
    Class pluginClass = NSClassFromString(@"GameRuntimePluginTask");
    if (pluginClass &&
        [self.gameRuntime getManager:@"plugin_manager" options:nil]) {
        id<GameRuntimeTask> pluginTask = [pluginClass alloc];
        SEL initSel = NSSelectorFromString(@"initWithPackageInfo:gameRuntime:listener:");
        NSMethodSignature *initSignature = [pluginClass instanceMethodSignatureForSelector:initSel];
        NSInvocation *initInvocation = [NSInvocation invocationWithMethodSignature:initSignature];
        [initInvocation setTarget:pluginTask];
        [initInvocation setSelector:initSel];
        NSDictionary *gameInfo = self.gameInfo;
        id<GameRuntimeTaskListener> listener = self;
        [initInvocation setArgument:&gameInfo atIndex:2];
        [initInvocation setArgument:&instance atIndex:3];
        [initInvocation setArgument:&listener atIndex:4];
        [initInvocation invoke];
        [initInvocation getReturnValue:&pluginTask];
        [self.gameRuntimeTasks addObject:pluginTask];
    }
    [self.SDKLauncher handleCheckGameVersion];
    [self.gameRuntime setGameQueryExitListener:self];
}

#pragma mark - Package check delegate
- (void)onCheckVersionFailure:(NSError *)error {
    NSLog(@"onCheckVersionSuccess");
    NSString *msg = [NSString stringWithFormat:@"检查游戏结果错误:%@",error];
    [self.loadingView setTipText:msg];
    [self.SDKLauncher handleGameDownLoad];
}

- (void)onCheckVersionStart:(NSDictionary *)info {
    NSLog(@"onCheckVersionStart");
    [self.loadingView setTipText:@"检查游戏版本号..."];
}

- (void)onCheckVersionSuccess {
    NSLog(@"onCheckVersionSuccess");
    [self.loadingView setTipText:@"检查游戏结果:已安装"];
    self.currentTaskIndex = 0;
    [self _executeGameRuntimeTask];
}

#pragma mark - download delegate
- (void)onDownloadProgress:(long)downloadedSize totalSize:(long)totalSize {
    NSLog(@"mGamePackageDownloadListener.onDownloadProgress");
    [self.loadingView updateProgress:downloadedSize total:totalSize];
}

- (void)onDownloadRetry:(long)retryNo {
    NSLog(@"mGamePackageDownloadListener.onDownloadRetry");
}

- (void)onDownloadStart {
    NSLog(@"mGamePackageDownloadListener.onDownloadStart");
    [self.loadingView setTipText:@"下载游戏包..."];
}

- (void)onDownloadSuccess:(NSString *)path {
    NSLog(@"mGamePackageDownloadListener.onSuccess");
    [self.loadingView setTipText:@"下载游戏包完成"];
    self.gamePackagePath = path;
    [self.SDKLauncher handleInstallGame];
}

- (void)onDownloadFailure:(NSError *)error {
    NSLog(@"mGamePackageDownloadListener.onError");
    NSString *msg = [NSString stringWithFormat:@"游戏包下载失败！(%@)",error];
    [self _prepareGameError:msg];
}

#pragma mark - Package install delegate
- (void)onInstallFailure:(NSError *)error {
    NSLog(@"onInstallFailure");
    NSString *msg = [NSString stringWithFormat:@"游戏包包安装失败！(%@)",error];
    [self _prepareGameError:msg];
}

- (void)onInstallStart {
    NSLog(@"onInstallStart");
    [self.loadingView setTipText:@"安装游戏包..."];
}

- (void)onInstallSuccess {
    NSLog(@"onInstallSuccess");
    [self.loadingView setTipText:@"安装游戏包完成！"];
    self.currentTaskIndex = 0;
    [self _executeGameRuntimeTask];
}

#pragma mark - SDK launch delegate
- (void)handleCancelGamePackageRequest {
    [self.gameRuntime cancelGamePackageRequest];
}

- (void)handleCheckGameVersion {
    [self.gameRuntime checkGameVersion:self.gameInfo listener:self];
}

- (void)handleGameDownLoad {
    [self.gameRuntime downloadGamePackage:self.gameInfo listener:self];
}

- (void)handleInstallGame {
    if (!self.gamePackagePath) {
        self.gamePackagePath = @"";
    }
    NSDictionary *opt = @{CR_KEY_GAME_PACKAGE_APP_ID:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_APP_ID],
                          CR_KEY_GAME_PACKAGE_EXTEND_DATA:self.extend,
                          CR_KEY_GAME_PACKAGE_HASH:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_HASH],
                          CR_KEY_GAME_PACKAGE_PATH:self.gamePackagePath,
                          CR_KEY_GAME_PACKAGE_VERSION:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_VERSION]};
    [self.gameRuntime installGamePackage:opt listener:self];
}

- (void)handleInstallSubpackage:(NSString *)root {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_APP_ID] forKey:CR_KEY_GAME_PACKAGE_APP_ID];
    [dic setObject:self.extend forKey:CR_KEY_GAME_PACKAGE_EXTEND_DATA];
    [dic setObject:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_HASH] forKey:CR_KEY_GAME_PACKAGE_HASH];
    [dic setObject:self.gamePackagePath forKey:CR_KEY_GAME_PACKAGE_PATH];
    [dic setObject:[self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_VERSION] forKey:CR_KEY_GAME_PACKAGE_VERSION];
    [dic setObject:root forKey:CR_KEY_GAME_PACKAGE_SUBPACKAGE_ROOT];
    [self.gameRuntime installGamePackage:dic listener:self.gameSubpackageListener];
}

- (void)handleRunGame {
    [self _runGame];
}

- (void)handleUninstallGame {
    [self.gameRuntime removeGameList:@[self.appId] listener:self];
}

- (void)setLaunchTest:(BOOL)isLaunchTest {
    [self.SDKLauncher setLaunchTest:isLaunchTest];
}

#pragma mark - run game delegate
- (void)onGameHandleCreate:(NSObject<CRCocosGameHandle> *)handle {
    [self.loadingView setTipText:@"初始化游戏环境..."];
    self.gameHandle = handle;
    [self setView:[self.gameHandle getGameView]];
    [self.view addSubview:self.loadingView];
}

- (void)onRunFailure:(NSError *)error {
    NSString *tip = [NSString stringWithFormat:@"启动游戏失败!(%@)",[error description]];
    [self.loadingView setTipText:tip];
}

- (void)onRunSuccess {
    [self.gameHandle setGameUserInfoListener:self];
    [self.gameHandle setGameQueryPermissionDialogListener:self];
    [self.gameHandle setGameOpenSettingDialogListener:self];
    [self.gameHandle setGameOpenSysPermTipDialogListener:self];
    [self.gameHandle setGameLoadSubpackageListener:self];
//    [self.gameHandle setCustomCommandListener:self.customCommand];
    [self.gameHandle setCustomCommandListener:self];
    [self.gameHandle setSkippedFrameWarningListener:self];
    
    [self.loadingView removeFromSuperview];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setFrame:CGRectMake(self.view.frame.size.width - 50, 0, 50, 30)];
    [btn addTarget:self action:@selector(_onButtonClickExit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)_onButtonClickExit {
    [self onQueryExit:self.appId result:@""];
}

#pragma mark - game query exit delegate
- (void)onQueryExit:(NSString *)appID result:(NSString *)result {
    __weak typeof(self) w =self;
    [self dismissViewControllerAnimated:YES completion:^{
        [w _exit];
    }];
}

- (void)onGameExitFailure:(NSError *)error {
    NSLog(@"exit game failure:%@",error);
}

- (void)onGameExitSuccess {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - game user info listener
- (void)queryUserInfo:(id<CRGameUserInfoHandle>)handle {
    NSString *avatarUrl = @"http://google.com";
    NSString *nick = @"nickName";
    @try {
        NSDictionary *info = @{CR_KEY_GAME_USERINFO_USER_ID: self.userId,
                               CR_KEY_GAME_USERINFO_AVATAR_URL: avatarUrl,
                               CR_KEY_GAME_USERINFO_NICK_NAME: nick,
                               CR_KEY_GAME_USERINFO_CITY: @"深圳",
                               CR_KEY_GAME_USERINFO_COUNTRY: @"中国",
                               CR_KEY_GAME_USERINFO_PROVINCE: @"广东省",
                               CR_KEY_GAME_USERINFO_GENDER: [NSNumber numberWithInt:CR_GAME_USERINFO_GENDER_MALE]
                               };
        [handle setUserInfo:info];
        [handle onGetUserInfoSuccess];
    } @catch (NSException *exception) {
        [handle onGetUserInfoFailure];
    }
}

#pragma mark - permission
- (void)onAuthDialogShow:(id<CRGameAuthDialogHandle>)handle permission:(CRPermission)per {
    if (!self.permissionView) {
        self.permissionView = [[GamePermissionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [self.permissionView setCompletePermission:^(BOOL isPositive) {
        [handle handleGamePermission:per granted:isPositive];
    }];
    [self.permissionView setMsg:[self _gerPermisssionHint:per]];
    [self.view addSubview:self.permissionView];
    [self.permissionView show];
}

- (void)onPermissionChanged:(CRPermission)permission granted:(BOOL)isGranted {
    if (self.authVC) {
        [self.authVC setSelectPermission:permission granted:isGranted];
    }
}

- (void)onSettingDialogOpen:(id<CRGameAuthoritySettingHandle>)handle permissionList:(NSDictionary<NSNumber *,NSNumber *> *)perMap {
    if (!self.authVC) {
        self.authVC = [[AuthSettingViewController alloc] init];
    }
    [self.authVC setSettingListener:handle];
    [self.authVC setData:perMap];
    [self.authVC setOnDismiss:^{
        [handle finish];
    }];
    [self presentViewController:self.authVC animated:YES completion:nil];
}

- (void)onAuthDialogShowWithPermission:(CRPermission)per {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"前往系统设置开启权限" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.authVC presentViewController:alert animated:true completion:nil];
}

#pragma mark - game load subpackage listener
- (void)onLoadSubpackage:(id<CRGameLoadSubpackageHandle>)handle root:(NSString *)root {
    NSString *version = [self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_VERSION];
    NSString *hash = [self.gameInfo objectForKey:CR_KEY_GAME_PACKAGE_HASH];
    NSString *url = [GameEnv buildGameSubpackageRequest:self.appId version:version root:root];
    NSMutableDictionary *dic = [[GameEnv buildAppOptions:self.appId version:version url:url hash:hash] mutableCopy];
    [dic setObject:root forKey:CR_KEY_GAME_PACKAGE_SUBPACKAGE_ROOT];
    self.gameSubpackageListener = [[GameLoadSubpackageHandle alloc] init];
    self.gameSubpackageListener.handle = handle;
    self.gameSubpackageListener.gameVC = self;
    self.gameSubpackageListener.root = root;
    [self.gameRuntime downloadGamePackage:dic listener:self.gameSubpackageListener];
}

- (void)onRemoveFailure:(NSError *)error {
    NSString *tip = [NSString stringWithFormat:@"game卸载失败!(%@)",error];
    [self.loadingView setTipText:tip];
}

- (void)onRemoveFinish:(NSString *)appId extra:(NSString *)extra {
    [self.loadingView setTipText:@"game卸载完成..."];
}

- (void)onRemoveStart:(NSString *)appId extra:(NSString *)extra {
    [self.loadingView setTipText:@"卸载game..."];
}

- (void)onRemoveSuccess:(NSArray<NSString *> *)removedList {
    [self.loadingView setTipText:@"game卸载成功"];
    if (self.isReinstall) {
        [self.SDKLauncher handleCheckGameVersion];
    }
}

#pragma mark - skip frame warning listener
- (void)onFramesSkipped:(int)frames {
    NSLog(@"skip frame warning listener: onFramesSkipped: %d", frames);
}

#pragma mark - GameRuntimeTaskListener
- (void)onTaskMessageChange:(NSString *)msg {
    [self.loadingView setTipText:msg];
}

- (void)onTaskSucceed {
    [self _executeGameRuntimeTask];
}

- (void)onTaskFailed:(int)errorType error:(NSError *)error {
    if (errorType == GAME_RUNTIME_TASK_PLUGIN_ERROR) {
        NSString *msg = [NSString stringWithFormat:@"安装插件失败，请尝试下载游戏完整包：%@",error];
        [self.loadingView setTipText:msg];
    } else if (errorType == GAME_RUNTIME_TASK_GAME_CONFIG_ERROR){
        self.isReinstall = YES;
        [self.SDKLauncher handleUninstallGame];
    }
}
- (void)onCallCustomCommand:(id<CRGameCustomCommandHandle>)handle info:(NSDictionary *)argv {
    NSString *index = [NSString stringWithFormat:@"%@",[argv objectForKey:@"0"]];
    NSLog(@"onCallCustomCommand %@",index);
    if ([index containsString:@"init"]) {
        NSLog(@"onCallCustomCommand method is init !");
    }else if([index containsString:@"finish"]){
        NSLog(@"onCallCustomCommand method is finish !");
        [self onQueryExit:self.appId result:@""];
    }else if([index containsString:@"startCloudGame"]){
        NSLog(@"onCallCustomCommand method is startCloudGame !");
        NSString *jsmutualString = [NSString stringWithFormat:@"GameSDK.nativeCallback('onInit','%@')",[self jsonStringWithDict:@{@"error":@(0),@"userId":@"userId",@"nickName":@"Jianruilin",@"headUrl":@"",@"location":@"China",@"sex":@"x",@"age":@(12)} isTrans:NO]];
        NSLog(@"发送消息给游戏：%@",jsmutualString);
        [self.gameHandle runScript:jsmutualString listener:self];
    }
    
}

- (void)onRunScriptSuccess:(NSString *)returnType returnInfo:(NSDictionary *)returnValue{
    NSLog(@"发送消息给游戏成功：returnType = %@ returnInfo = %@",returnType,returnValue);
}

- (void)onRunScriptFailure:(NSString *)error{
    NSLog(@"发送消息给游戏失败：%@",error);
}

#pragma - mark 字典转Json字符串
- (NSString *)jsonStringWithDict:(NSDictionary *)dict isTrans:(BOOL)trans {
    NSError *error;
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
//        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    jsonString = mutStr;
    //转义字符...
    return jsonString;
}

@end

@implementation GameLoadSubpackageHandle
- (void)onInstallFailure:(NSError *)error {
    NSString *tip = [NSString stringWithFormat:@"subpackage %@ install fail, error %@",self.root,error];
    [self.handle onLoadSubpackageFailure:tip];
}

- (void)onInstallStart {
    NSLog(@"install subpackage start");
}

- (void)onInstallSuccess {
    [self.handle onLoadSubpackageSuccess];
}

- (void)onDownloadFailure:(NSError *)error {
    NSString *tip = [NSString stringWithFormat:@"subpackage %@ download fail, error %@",self.root,error];
    [self.handle onLoadSubpackageFailure:tip];
}

- (void)onDownloadProgress:(long)downloadedSize totalSize:(long)totalSize {
    [self.handle onLoadSubpackageProgress:downloadedSize total:totalSize];
}

- (void)onDownloadRetry:(long)retryNo {
    NSLog(@"download subpackage retry");
}

- (void)onDownloadStart {
    NSLog(@"download subpackage start");
}

- (void)onDownloadSuccess:(NSString *)path {
    self.gameVC.gamePackagePath = path;
    [self.gameVC.SDKLauncher handleInstallSubpackage:self.root];
}



@end
