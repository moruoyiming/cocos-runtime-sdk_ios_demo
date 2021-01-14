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


#import "AuthSettingViewController.h"
#import <lib_rt_core/CRGameHandleInternal.h>

@interface AuthSettingCell : UITableViewCell
@property (nonatomic, assign) CRPermission per;
@property (nonatomic, strong) UISwitch *swc;
@property (nonatomic, copy) void(^onSwitch)(CRPermission per, BOOL on);
@end

@implementation AuthSettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat height = 55;
        CGFloat swcWith = 50;
        CGFloat swcHeight = 30;
        CGFloat rightSpace = 15;
        self.swc = [[UISwitch alloc] initWithFrame:CGRectMake(width - rightSpace - swcWith, (height - swcHeight)/2.0, swcWith, swcHeight)];
        [self.swc addTarget:self action:@selector(_switchChange) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.swc];
    }
    return self;
}

- (void)_switchChange {
    if (self.onSwitch) {
        self.onSwitch(self.per, [self.swc isOn]);
    }
}

@end

@interface AuthSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *dataSource;
@end

@implementation AuthSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:btn];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [lbl setFont:[UIFont boldSystemFontOfSize:20]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"设置"];
    [self.navigationBar addSubview:lbl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerClass:[AuthSettingCell class] forCellReuseIdentifier:@"identifier"];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    CGFloat navHeight = self.navigationBar.frame.size.height + self.navigationBar.frame.origin.y;
    [self.tableView setFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight)];
    [self.tableView reloadData];
}

- (void)setSelectPermission:(CRPermission)per granted:(BOOL)granted {
    if (self.dataSource) {
        [self.dataSource setObject:@(granted) forKey:@(per)];
        [self.tableView reloadData];
    }
}

- (void)setData:(NSDictionary<NSNumber *,NSNumber *> *)dic {
    self.dataSource = [dic mutableCopy];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (NSString *)_getTitle:(CRPermission)permission {
    switch (permission) {
        case CR_LOCATION:
            return @"位置信息";
            break;
        case CR_RECORD:
            return @"录音权限";
            break;
        case CR_USER_INFO:
            return @"用户信息";
            break;
        case CR_WRITE_PHOTOS_ALBUM:
            return @"相册信息";
            break;
        case CR_CAMERA:
            return @"相机权限";
            break;
    }
    return @"error";
}

- (CRPermission)_getTypeAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return CR_LOCATION;
            break;
        case 1:
            return CR_CAMERA;
            break;
        case 2:
            return CR_USER_INFO;
            break;
        case 3:
            return CR_RECORD;
            break;
        case 4:
            return CR_WRITE_PHOTOS_ALBUM;
            break;
    }
    return -1;
}

- (void)_dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onDismiss) {
            self.onDismiss();
        }
    }];
}

#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AuthSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [cell setOnSwitch:^(CRPermission per, BOOL on) {
        [[weakSelf settingListener] changePermission:per granted:on viewController:weakSelf];
    }];
    CRPermission per = [self _getTypeAtIndex:indexPath.section];
    NSString *title = [self _getTitle:per];
    BOOL status = ([[self.dataSource objectForKey:@(per)] integerValue] == CR_PERMISSION_GRANTED);
    [cell.textLabel setText:title];
    [cell.swc setOn:status];
    cell.per = per;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataSource) {
        return 0;
    }
    CRPermission per = [self _getTypeAtIndex:section];
    NSNumber *status = [self.dataSource objectForKey:@(per)];
    if (!status) {
        return 0;
    }
    return 1;
}

@end
