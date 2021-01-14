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


#import "AccountViewController.h"
#import <lib_rt_frame/CRCocosGame.h>
#import "GameEnv.h"
#import "ManagerViewController.h"
#import "ToastView.h"

@interface AccountCardView : UIView
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *accountLbl;
@property (nonatomic, strong) UITextField *accountTxt;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *msgLbl;
@end

@implementation AccountCardView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat left = 33.f;
    
    [self.titleLbl setFrame:CGRectMake(0, 28, width, 30)];
    [self.accountTxt setFrame:CGRectMake(left, (self.frame.size.height - 30)/2.0, width - left*2, 30)];
    [self.accountLbl setFrame:CGRectMake(left, self.accountTxt.frame.origin.y - 30, width, 20)];
    [self.btn setFrame:CGRectMake(60, height - 90, width - 60*2, 42)];
    [self.msgLbl setFrame:CGRectMake(0, height - 30, width, 14)];
    
}

- (void)setLogin:(BOOL)isLogin {
    if (!isLogin) {
        [self.accountTxt setEnabled:YES];
        [self.btn setTitle:@"登陆" forState:UIControlStateNormal];
        [self.titleLbl setText:@"请登录"];
    } else {
        [self.accountTxt setEnabled:NO];
        [self.btn setTitle:@"注销" forState:UIControlStateNormal];
        [self.titleLbl setText:@"已登录"];
    }
}

- (void)_initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 5);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 5;
    
    self.titleLbl = ({
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setText:@"已登陆"];
        [lbl setFont:[UIFont boldSystemFontOfSize:30]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        lbl;
    });
    [self addSubview:self.titleLbl];
    
    self.accountLbl = ({
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setText:@"账号ID"];
        [lbl setFont:[UIFont systemFontOfSize:18]];
        [lbl setTextAlignment:NSTextAlignmentLeft];
        [lbl setTextColor:[UIColor redColor]];
        lbl;
    });
    [self addSubview:self.accountLbl];
    
    self.accountTxt = [[UITextField alloc] init];
    [self.accountTxt setFont:[UIFont systemFontOfSize:20]];
    [self.accountTxt setTextAlignment:NSTextAlignmentLeft];
    [self.accountTxt setPlaceholder:@"请输入账号"];
    self.accountTxt.borderStyle = UITextBorderStyleRoundedRect;
    self.accountTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:self.accountTxt];
    
    self.btn = [[UIButton alloc] init];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn setTitle:@"登录" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    [self.btn.layer setCornerRadius:21];
    [self.btn setClipsToBounds:YES];
    [self addSubview:self.btn];
    
    self.msgLbl = ({
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setText:@"随意输入账号"];
        [lbl setFont:[UIFont systemFontOfSize:14]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor grayColor]];
        lbl;
    });
    [self addSubview:self.msgLbl];
}
@end

@interface AccountViewController ()
@property (nonatomic, strong) AccountCardView *accountContainer;
@property (nonatomic, strong) UIButton *managerBtn;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString *userId;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.accountContainer = [[AccountCardView alloc] init];
    [self.accountContainer.btn addTarget:self action:@selector(_onButtonClickAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.accountContainer];
    
    self.managerBtn = [[UIButton alloc] init];
    [self.managerBtn setTitle:@"管理参数设置" forState:UIControlStateNormal];
    [self.managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.managerBtn setBackgroundColor:[UIColor colorWithRed:101/255.0 green:193/255.0 blue:226/255.0 alpha:1.0]];
    [self.managerBtn addTarget:self action:@selector(_onButtonClickManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerBtn];
    
    self.userId = [[GameEnv getInstance] getUserId];
    if (self.userId) {
        [self.accountContainer.accountTxt setText:self.userId];
        [self.accountContainer setLogin:YES];
        self.isLogin = YES;
    } else {
        [self.accountContainer setLogin:NO];
        self.isLogin = NO;
    }
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat widthCard = width - 46*2;
    CGFloat heightCard = height*0.5;
    CGFloat space = 30;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    [self.accountContainer setFrame:CGRectMake((width - widthCard)/2.0, (height - heightCard)/2.0, widthCard, heightCard)];
    [self.managerBtn setFrame:CGRectMake(self.accountContainer.frame.origin.x + space, self.accountContainer.frame.origin.y + heightCard + space, widthCard - space*2, height - (self.accountContainer.frame.origin.y + heightCard + space*2 + tabBarHeight))];
    [self.managerBtn.layer setCornerRadius:self.managerBtn.frame.size.height/3.0];
    [self.managerBtn setHidden:!(self.userId && ![self.userId isEqualToString:@""])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginStatusChange) name:SP_KEY_USER_ID object:nil];
    
    [CRCocosGame initRuntime:self.userId options:[GameEnv buildRuntimeOptions] listener:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:SP_KEY_USER_ID];
}

- (void)_onButtonClickAccount {
    if (self.isLogin) {
        [[GameEnv getInstance] setUserId:nil];
    } else if([self.accountContainer.accountTxt.text isEqualToString:@""]) {
        [ToastView showToast:@"请输入ID" withDuration:1.5];
    } else {
        [[GameEnv getInstance] setUserId:self.accountContainer.accountTxt.text];
    }
}

- (void)_onButtonClickManager {
    ManagerViewController *managerVC = [[ManagerViewController alloc] init];
    [managerVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:managerVC animated:YES];
}

- (void)_loginStatusChange {
    NSString *userId = [[GameEnv getInstance] getUserId];
    if (userId) {
        self.isLogin = YES;
        self.userId = userId;
        [self.accountContainer setLogin:YES];
    } else {
        self.isLogin = NO;
        self.userId = userId;
        [self.accountContainer setLogin:NO];
    }
    [self.managerBtn setHidden:!(self.userId && ![self.userId isEqualToString:@""])];
    [CRCocosGame initRuntime:self.userId options:[GameEnv buildRuntimeOptions] listener:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf.view endEditing:YES];
    }];
}

@end
