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


#import "ManagerViewController.h"
#import <lib_rt_core/CRCocosGameRuntime.h>
#import <lib_rt_frame/CRCocosGame.h>
#import "UninstallViewController.h"
#import "GameEnv.h"

@interface ManagerViewController () <CRCheckFileAvailabilityListener, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *appVersionLbl;
@property (nonatomic, strong) UILabel *sdkVersionLbl;
@property (nonatomic, strong) UIButton *uninstallBtn;
@property (nonatomic, strong) UIButton *pluginUninstallBtn;
@property (nonatomic, strong) UIButton *startBackgroundTaskBtn;
@property (nonatomic, strong) UILabel *launchOptionLbl;
@property (nonatomic, strong) UITextField *launchOptionTextField;
@property (nonatomic, strong) UILabel *debugSwitchLbl;
@property (nonatomic, strong) UISwitch *debugSwitch;
@property (nonatomic, strong) UILabel *skippedFrameWarningSwitchLbl;
@property (nonatomic, strong) UIPickerView *frameWarningPickerView;

@property (nonatomic, strong) NSArray *frameLimitItems;

@property (nonatomic, strong) UILabel *vConsoleSwitchLbl;
@property (nonatomic, strong) UISwitch *vConsoleSwitch;
@end

@implementation ManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"管理参数测试"];
    
    CGFloat left = 15;
    CGFloat width = self.view.frame.size.width;
    CGFloat navHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    CGFloat lblHeight = 30;
    CGFloat btnSpace = 10;
    CGFloat btnHeight = 50;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *sdkVersion = [[CRCocosGame getRuntime] getVersionInfo];
    
    self.frameLimitItems = @[@"0", @"2", @"5", @"10", @"15", @"20", @"25", @"30"];
    
    self.appVersionLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, navHeight, width, lblHeight)];
        [lbl setTextColor:[UIColor grayColor]];
        [lbl setText:[NSString stringWithFormat:@"Demo app version: %@",appCurVersion]];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:self.appVersionLbl];
    
    self.sdkVersionLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, navHeight + lblHeight, width, lblHeight)];
        [lbl setTextColor:[UIColor grayColor]];
        [lbl setText:[NSString stringWithFormat:@"Runtime sdk version: %@",sdkVersion]];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:self.sdkVersionLbl];
    
    UIColor *btnBgColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.uninstallBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left, self.sdkVersionLbl.frame.origin.y + lblHeight + btnSpace, width - left*2, btnHeight)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"卸载已下载游戏" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn setBackgroundColor:btnBgColor];
        [btn.layer setCornerRadius:btnHeight/3.0];
        btn;
    });
    [self.uninstallBtn addTarget:self action:@selector(_onButtonClickUninstall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.uninstallBtn];
    
    self.pluginUninstallBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"管理PLUGIN列表" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn setBackgroundColor:btnBgColor];
        [btn.layer setCornerRadius:btnHeight/3.0];
        CGRect frame = CGRectMake(left,
                                  self.uninstallBtn.frame.origin.y + btnHeight + btnSpace,
                                  width - left*2,
                                  btnHeight);
        if (!NSClassFromString(@"PluginUninstallViewController") ||
            ![[CRCocosGame getRuntime] getManager:@"plugin_manager" options:nil]) {
            frame = self.uninstallBtn.frame;
            [btn setHidden:YES];
        }
        [btn setFrame:frame];
        btn;
    });
    [self.pluginUninstallBtn addTarget:self
                                action:@selector(_onButtonClickPluginUninstall)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pluginUninstallBtn];
    
    self.startBackgroundTaskBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left, self.pluginUninstallBtn.frame.origin.y + btnHeight + btnSpace, width - left*2, btnHeight)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"启动后台检查任务" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn setBackgroundColor:btnBgColor];
        [btn.layer setCornerRadius:btnHeight/3.0];
        [btn addTarget:self action:@selector(_onButtonClickStartBackgroundCheckTask) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.startBackgroundTaskBtn];
    
    CGFloat launchOptionLblWidth = 120;
    self.launchOptionLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, self.startBackgroundTaskBtn.frame.origin.y + btnHeight + btnSpace, launchOptionLblWidth, lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:@"启动参数测试："];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:self.launchOptionLbl];
    
    self.launchOptionTextField = ({
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(left + launchOptionLblWidth, self.startBackgroundTaskBtn.frame.origin.y + btnHeight + btnSpace, width - launchOptionLblWidth - left * 2, lblHeight)];
        [textField setTextColor:[UIColor blackColor]];
        [textField setFont:[UIFont systemFontOfSize:16]];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        textField.placeholder = @"launch demo options";
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSString *currentLaunchOptions = [[GameEnv getInstance] getLaunchOptions];
        if (currentLaunchOptions) {
            textField.text = currentLaunchOptions;
        }
        textField;
    });
    [self.view addSubview:self.launchOptionTextField];
    
    CGFloat titleLabelWidth = 300;
    CGFloat lineMargin = 5;
    self.debugSwitchLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, self.launchOptionLbl.frame.origin.y + lblHeight + lineMargin, titleLabelWidth, lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:@"开启调试支持：显示帧率信息"];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:self.debugSwitchLbl];
    
    CGFloat switchWidth = 50;
    CGFloat switchHeight = 30;
    BOOL isDebugOn = [[GameEnv getInstance] isShowFPS];
    self.debugSwitch = ({
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(width - switchWidth - left, self.debugSwitchLbl.frame.origin.y, switchWidth, switchHeight)];
        [toggle setOn:isDebugOn];
        [toggle addTarget:self action:@selector(_debugSwitchToggled:) forControlEvents:UIControlEventValueChanged];
        toggle;
    });
    [self.view addSubview:self.debugSwitch];
    
    
    BOOL isVConsoleEnable = isDebugOn & [[GameEnv getInstance] isVConsoleEnabled];
    self.vConsoleSwitchLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left,
                                                                 self.debugSwitch.frame.origin.y + lblHeight + lineMargin,
                                                                 titleLabelWidth,
                                                                 lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:@" - 开启 vConsole："];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        [lbl setEnabled:isDebugOn];
        lbl;
    });
    [self.view addSubview:self.vConsoleSwitchLbl];
    
    self.vConsoleSwitch = ({
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(width - switchWidth - left,
                                                                      self.vConsoleSwitchLbl.frame.origin.y,
                                                                      switchWidth,
                                                                      switchHeight)];
        
        [toggle setOn:isVConsoleEnable];
        [toggle setEnabled:isDebugOn];
        [toggle addTarget:self action:@selector(_vConsoleSwitchToggled:) forControlEvents:UIControlEventValueChanged];
        toggle;
    });
    [self.view addSubview:self.vConsoleSwitch];
    
    UILabel *testSwitchLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, self.vConsoleSwitchLbl.frame.origin.y + lblHeight + lineMargin, titleLabelWidth, lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:@"使用测试模式启用游戏"];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:testSwitchLbl];
    
    UISwitch *testSwitch = ({
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(width - switchWidth - left, testSwitchLbl.frame.origin.y, switchWidth, switchHeight)];
        BOOL isDebugOn = [[GameEnv getInstance] isSdkLaunchTest];
        [toggle setOn:isDebugOn];
        [toggle addTarget:self action:@selector(_onSwitchChangeTest:) forControlEvents:UIControlEventValueChanged];
        toggle;
    });
    [self.view addSubview:testSwitch];
    
    UILabel *gameLoadingLogSwitchLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, testSwitch.frame.origin.y + lblHeight + lineMargin, titleLabelWidth, lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:@"日志输出游戏加载时间信息"];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:gameLoadingLogSwitchLbl];
    
    UISwitch *gameLoadingLogSwitch = ({
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(width - switchWidth - left, gameLoadingLogSwitchLbl.frame.origin.y, switchWidth, switchHeight)];
        BOOL isGameLoadingLog = [[GameEnv getInstance] isShowGameLoadingTimeLog];
        [toggle setOn:isGameLoadingLog];
        [toggle addTarget:self action:@selector(_onSwitchChangeLoadingLog:) forControlEvents:UIControlEventValueChanged];
        toggle;
    });
    [self.view addSubview:gameLoadingLogSwitch];
    
    NSInteger frameLimit = [[GameEnv getInstance] getSkippedFrameWarning];
    UILabel *skippedFrameWarningSwitchLbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(left, gameLoadingLogSwitchLbl.frame.origin.y + lblHeight + lineMargin, titleLabelWidth, lblHeight)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setText:[NSString stringWithFormat:@"日志输出掉帧告警(0为关闭): %ld",(long)frameLimit]];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        lbl;
    });
    [self.view addSubview:skippedFrameWarningSwitchLbl];
    self.skippedFrameWarningSwitchLbl = skippedFrameWarningSwitchLbl;
    
    UIButton *frameLimitBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width - switchWidth - left, skippedFrameWarningSwitchLbl.frame.origin.y, switchWidth, switchHeight);
        [btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_didClickFrameLimitBtn) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:frameLimitBtn];
    
    UIPickerView *frameWarningPickerView = ({
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 250, self.view.bounds.size.width, 250)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView;
    });
    NSInteger rowIndex = [self _getRowIndexByFrameLimit:frameLimit];
    if (rowIndex != -1) {
        [frameWarningPickerView selectRow:rowIndex inComponent:0 animated:NO];
    }
    [self.view addSubview:frameWarningPickerView];
    self.frameWarningPickerView = frameWarningPickerView;
    [self.frameWarningPickerView setHidden:YES];
    
    NSString *userId = [[GameEnv getInstance] getUserId];
    if (!userId) {
        [self.uninstallBtn setEnabled:NO];
        [self.startBackgroundTaskBtn setEnabled:NO];
    }
}

- (NSInteger)_getRowIndexByFrameLimit:(NSInteger)frameLimit {
    for (int i = 0; i < self.frameLimitItems.count; i++) {
        NSInteger currentLimit = [self.frameLimitItems[i] integerValue];
        if (frameLimit == currentLimit) {
            return i;
        }
    }
    return -1;
}

- (void)_didClickFrameLimitBtn {
    [self.frameWarningPickerView setHidden:(!self.frameWarningPickerView.isHidden)];
}

- (void)_onButtonClickUninstall {
    UninstallViewController *uninstallVC = [[UninstallViewController alloc] init];
    [self.navigationController pushViewController:uninstallVC animated:YES];
}

- (void)_onButtonClickPluginUninstall {
    Class pluginUninstallClass = NSClassFromString(@"PluginUninstallViewController");
    if (!pluginUninstallClass) {
        return;
    }
    UIViewController *uninstallVC = [[pluginUninstallClass alloc] init];
    [self.navigationController pushViewController:uninstallVC animated:YES];
}

- (void)_onButtonClickStartBackgroundCheckTask {
    id<CRCocosGameRuntime> runtime = [CRCocosGame getRuntime];
    if (!runtime) {
        return;
    }
    NSDictionary *dic = @{CR_KEY_CHECK_FILE_EXTENSION_NAME_ARRAY:@[@"cpk"], CR_KEY_CHECK_FILE_KEEP_TIME:@1};
    [runtime checkFileAvailability:dic listener:self];
}

- (void)_debugSwitchToggled:(UISwitch*)swi {
    BOOL isDebugOn = swi.on;
    GameEnv *gameEnv = [GameEnv getInstance];
    [gameEnv showFPS:isDebugOn];
    if (!isDebugOn) {
        [gameEnv enableVConsole:isDebugOn];
        [self.vConsoleSwitch setOn:isDebugOn];
        [self.vConsoleSwitch setEnabled:isDebugOn];
        [self.vConsoleSwitchLbl setEnabled:isDebugOn];
    } else {
        [self.vConsoleSwitch setEnabled:YES];
        [self.vConsoleSwitchLbl setEnabled:YES];
    }
}

- (void)_vConsoleSwitchToggled:(UISwitch*)swi {
    BOOL isOn = swi.on;
    [[GameEnv getInstance] enableVConsole:isOn];
}

- (void)_onSwitchChangeTest:(UISwitch*)swi {
    BOOL isOn = swi.on;
    [[GameEnv getInstance] setSdkLaunchTest:isOn];
}

- (void)_onSwitchChangeLoadingLog:(UISwitch*)swi {
    BOOL isTestOn = swi.on;
    [[GameEnv getInstance] setGameLoadingTimeLog:isTestOn];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *launchOptionText = self.launchOptionTextField.text;
    [[GameEnv getInstance] setLaunchOptions:launchOptionText];
}

#pragma mark - check file
- (void)onCheckFailure:(NSError *)error {
    NSLog(@"CheckFileAvailabilityListener.onCheckStart");
}

- (void)onCheckProgress:(NSString *)removedPath {
    NSLog(@"CheckFileAvailabilityListener.onCheckProgress: remove %@",removedPath);
}

- (void)onCheckStart {
    NSLog(@"CheckFileAvailabilityListener.onCheckSuccess");
}

- (void)onCheckSuccess {
    NSLog(@"CheckFileAvailabilityListener.onCheckSuccess");
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.frameLimitItems.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.frameLimitItems[row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *frameLimit = self.frameLimitItems[row];
    [self.skippedFrameWarningSwitchLbl setText:[NSString stringWithFormat:@"日志输出掉帧告警(0为关闭): %@", frameLimit]];
    [self.frameWarningPickerView setHidden:YES];
    [[GameEnv getInstance] setSkippedFrameWarning:[frameLimit integerValue]];
}

@end
