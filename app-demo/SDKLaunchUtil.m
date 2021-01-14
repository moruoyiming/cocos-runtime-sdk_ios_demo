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


#import "SDKLaunchUtil.h"
#import <lib_rt_core/CRCocosGameRuntime.h>

@interface SDKLaunchUtil ()
@property (nonatomic, weak) id<SDKTestLaunchListener> listener;
@property (nonatomic, assign) BOOL isLaunchTest;
@end

@implementation SDKLaunchUtil
- (instancetype)initWithListener:(id<SDKTestLaunchListener>)listener isTest:(BOOL)isLaunchTest
{
    self = [super init];
    if (self) {
        self.listener = listener;
        [self setLaunchTest:isLaunchTest];
    }
    return self;
}

- (BOOL)isHandleNext {
    return !self.isLaunchTest;
}

- (void)handleCancelGamePackageRequest {
    if ([self isHandleNext]) {
        [self.listener handleCancelGamePackageRequest];
    }
}

- (void)handleCheckGameVersion {
    if ([self isHandleNext]) {
        [self.listener handleCheckGameVersion];
    }
}

- (void)handleGameDownLoad {
    if ([self isHandleNext]) {
        [self.listener handleGameDownLoad];
    }
}

- (void)handleInstallGame {
    if ([self isHandleNext]) {
        [self.listener handleInstallGame];
    }
}

- (void)handleInstallSubpackage:(NSString *)root {
    [self.listener handleInstallSubpackage:root];
}

- (void)handleRunGame {
    if ([self isHandleNext]) {
        [self.listener handleRunGame];
    }
}

- (void)handleUninstallGame {
    if ([self isHandleNext]) {
        [self.listener handleUninstallGame];
    }
}

- (void)setLaunchTest:(BOOL)isLaunchTest {
    self.isLaunchTest = isLaunchTest;
}

@end

@interface GameLoadingView : UIView <LoadingViewHandle>
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) void(^closeCallback)(void);
@end

@implementation GameLoadingView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self _initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [self.logoImg setFrame:CGRectMake(screenWidth / 2.0 - 50, screenHeight / 2.0 - 100, 100, 200)];
    [self.statusLbl setFrame:CGRectMake(0, screenHeight - 60, screenWidth, self.statusLbl.frame.size.height)];
    [self.closeBtn setFrame:CGRectMake(screenWidth - 50 - 30, 20, 50, 30)];
}

- (void)_initView {
    self.logoImg = [[UIImageView alloc] init];
    if (!self.imgPath || [self.imgPath isEqualToString:@""]) {
        self.imgPath = @"cocos_game_logo";
    }
    [self.logoImg setImage:[UIImage imageNamed:self.imgPath]];
    [self.logoImg setContentMode:UIViewContentModeCenter];
    [self addSubview:self.logoImg];
    
    self.statusLbl = [[UILabel alloc] init];
    [self.statusLbl setLineBreakMode:NSLineBreakByWordWrapping];
    [self.statusLbl setNumberOfLines:0];
    [self.statusLbl setTextAlignment:NSTextAlignmentLeft];
    [self.statusLbl setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.statusLbl];
    
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn addTarget:self action:@selector(_onButtonClickClose) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    [self.closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [self.closeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.closeBtn];
}

- (void)setTipText:(NSString *)tip {
    [self.statusLbl setFrame:CGRectMake(self.statusLbl.frame.origin.x,
                                        self.statusLbl.frame.origin.y,
                                        self.frame.size.width,
                                        self.statusLbl.frame.size.height)];
    [self.statusLbl setText:tip];
    [self.statusLbl sizeToFit];
}

- (UIView *)getView {
    return self;
}

- (void)setCenterImage:(NSString *)imgPath {
    self.imgPath = imgPath;
    if (self.logoImg) {
        [self.logoImg setImage:[UIImage imageNamed:self.imgPath]];
    }
}

- (void)updateProgress:(long)size total:(long)total {
    float sizef = size * 1.0f / 1024;
    float totalf = total * 1.0f / 1024;
    NSString *text = [NSString stringWithFormat:@"资源加载中...  %.2fKB/%.2fKB",sizef,totalf];
    [self.statusLbl setText:text];
}

- (void)setCloseCallback:(void (^)(void))closeCallback {
    _closeCallback = closeCallback;
}

- (void)_onButtonClickClose {
    if (self.closeCallback) {
        self.closeCallback();
    }
}

@end

@interface GameLoadingTextView : GameLoadingView <LoadingViewHandle>
@property (nonatomic, weak) id<SDKTestLaunchListener> listener;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *installBtn;
@property (nonatomic, strong) UIButton *uninstallBtn;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UILabel *packageInfoLbl;
@property (nonatomic, strong) UIButton *autoBtn;
@property (nonatomic, copy) NSDictionary *info;
@end

@implementation GameLoadingTextView
- (instancetype)initWithListener:(id<SDKTestLaunchListener>)listener info:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.info = info;
        self.listener = listener;
        [self _initTest];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat beginX = 5;
    
    [self.checkBtn setFrame:[self _getRextAtIndex:0]];
    [self.downloadBtn setFrame:[self _getRextAtIndex:1]];
    [self.installBtn setFrame:[self _getRextAtIndex:2]];
    [self.uninstallBtn setFrame:[self _getRextAtIndex:3]];
    [self.startBtn setFrame:[self _getRextAtIndex:4]];
    self.autoBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.autoBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.autoBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.autoBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.autoBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:100]];
    [self.autoBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.autoBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40]];
    self.packageInfoLbl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.packageInfoLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.autoBtn attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.packageInfoLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:beginX]];
    [self.packageInfoLbl addConstraint:[NSLayoutConstraint constraintWithItem:self.packageInfoLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.statusLbl.frame.size.width]];
    [self.packageInfoLbl addConstraint:[NSLayoutConstraint constraintWithItem:self.packageInfoLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:35]];
    
    CGRect statusLblRect = CGRectMake(0, self.startBtn.frame.size.height + self.startBtn.frame.origin.y + 10, self.statusLbl.frame.size.width, self.statusLbl.frame.size.height);
    for (UIView *view in self.subviews) {
        if (view == self || [view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        if (CGRectIntersectsRect(statusLblRect, view.frame)) {
            statusLblRect = CGRectMake(0, view.frame.size.height + view.frame.origin.y + 10, self.statusLbl.frame.size.width, self.statusLbl.frame.size.height);
        }
    }
    [self.statusLbl setFrame:statusLblRect];
}

- (CGRect)_getRextAtIndex:(NSInteger)index {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    BOOL isPortrait = screenWidth < screenHeight;
    CGFloat beginX = 5;
    CGFloat space = 5;
    CGFloat beginY = self.closeBtn.frame.origin.y + self.closeBtn.frame.size.height + 5;
    CGFloat btnHeight = 40;
    CGFloat btnWidth = isPortrait ? (screenWidth - space*2 - beginX*2)/3 : (screenWidth - space*4 - beginX*2)/5;
    CGRect rect = CGRectMake(beginX + (space + btnWidth)*(index%3), beginY + (space + btnHeight)*(index/3), btnWidth, btnHeight);
    if (!isPortrait) {
        rect = CGRectMake(beginX + (space + btnWidth)*index, beginY, btnWidth, btnHeight);
    }
    return rect;
}

- (void)_initTest {
    self.checkBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"检查game" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.checkBtn];
    
    self.downloadBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"下载game" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.downloadBtn];
    
    self.installBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"安装game" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.installBtn];
    
    self.uninstallBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"卸载game" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.uninstallBtn];
    
    self.startBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.startBtn];
    
    NSString *version = [self.info objectForKey:CR_KEY_GAME_PACKAGE_VERSION];
    NSString *hash = [self.info objectForKey:CR_KEY_GAME_PACKAGE_HASH];
    self.packageInfoLbl = [[UILabel alloc] init];
    [self.packageInfoLbl setTextAlignment:NSTextAlignmentLeft];
    [self.packageInfoLbl setNumberOfLines:2];
    [self.packageInfoLbl setText:[NSString stringWithFormat:@"游戏版本号:%@\n游戏hash值:%@",version,hash]];
    [self.packageInfoLbl setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.packageInfoLbl];
    
    self.autoBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"自动进入游戏" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(_onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.autoBtn];
}

- (void)_onButtonClick:(UIButton *)sender {
    if (sender == self.autoBtn) {
        [self.listener setLaunchTest:NO];
        [self.listener handleCheckGameVersion];
    } else if (sender == self.startBtn) {
        [self.listener handleRunGame];
    } else if (sender == self.checkBtn) {
        [self.listener handleCancelGamePackageRequest];
        [self.listener handleCheckGameVersion];
    } else if (sender == self.downloadBtn) {
        [self.listener handleCancelGamePackageRequest];
        [self.listener handleGameDownLoad];
    } else if (sender == self.installBtn) {
        [self.listener handleCancelGamePackageRequest];
        [self.listener handleInstallGame];
    } else if (sender == self.uninstallBtn) {
        [self.listener handleCancelGamePackageRequest];
        [self.listener handleUninstallGame];
    }
}
@end

@implementation LoadingViewFactory
+ (UIView<LoadingViewHandle> *)createWithIsDebugger:(BOOL)isDebugger listener:(id<SDKTestLaunchListener>)listener info:(NSDictionary *)info {
    UIView<LoadingViewHandle> *loadingView;
    if (isDebugger) {
        loadingView = [[GameLoadingTextView alloc] initWithListener:listener info:info];
    } else {
        loadingView = [[GameLoadingView alloc] init];
    }
    return loadingView;
}
@end
