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


#import "UninstallViewController.h"
#import <lib_rt_frame/CRCocosGame.h>
#import <lib_rt_core/CRCocosGameRuntime.h>
#import "GameEnv.h"
#import "ToastView.h"

@interface UninstallCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, copy) NSDictionary *info;
@property (nonatomic, copy) void(^authOp)(NSDictionary *info);
@end

@implementation UninstallCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat height = 44;
        CGFloat btnX = 10;
        CGFloat btnWidth = 20;
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, (height - btnWidth)/2.0, btnWidth, btnWidth)];
        [self.selectBtn setUserInteractionEnabled:NO];
        [self.selectBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateSelected];
        [self addSubview:self.selectBtn];
        
        [self setIndentationWidth:btnX + btnWidth];
        [self setIndentationLevel:1];
        
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat authBtnWidth = 50;
        CGFloat authBtnTop = 10;
        self.authBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - authBtnWidth - btnX,
                                                                    authBtnTop,
                                                                    authBtnWidth,
                                                                    height - authBtnTop * 2)];
        [self.authBtn addTarget:self action:@selector(_onButtonClickAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.authBtn setBackgroundColor:[UIColor colorWithRed:101/255.0 green:193/255.0 blue:226/255.0 alpha:1.0]];
        [self.authBtn setTitle:@"权限" forState:UIControlStateNormal];
        [self.authBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:self.authBtn];
    }
    return self;
}

- (void)_onButtonClickAuth {
    if (self.authOp) {
        self.authOp(_info);
    }
}

@end

@interface UninstallViewController () <UITableViewDelegate, UITableViewDataSource, CRGameListListener, CRRuntimeInitializeListener, CRGameRemoveListener, CRGameDataSetListener>
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation UninstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"选择卸载的游戏"];
    
    self.selectedArr = [NSMutableArray array];
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
    }
    CGFloat safeBottomHeight = UIEdgeInsetsEqualToEdgeInsets(safeInsets, UIEdgeInsetsZero) ? 0 : 34;
    CGFloat toolBarHeight = 44 + safeBottomHeight;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, width, height - toolBarHeight - navHeight) style:UITableViewStylePlain];
    [self.tableView registerClass:[UninstallCell class] forCellReuseIdentifier:@"identifier"];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, height - toolBarHeight, width, toolBarHeight)];
    self.selectAllBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn addTarget:self action:@selector(_onClickButtonSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateSelected];
        [btn setFrame:CGRectMake(5, 0, 100, 44)];
        [btn setTitle:@" 全选" forState:UIControlStateNormal];
        [btn setTitle:@" 取消全选" forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn;
    });
    [toolBar addSubview:self.selectAllBtn];
    
    self.deleteBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(_onClickButtonDelete) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(width - 5 - 50, 5, 50, 34)];
        [btn setTitle:@" 卸载" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
        btn;
    });
    [toolBar addSubview:self.deleteBtn];
    [self.view addSubview:toolBar];
    
    [self _initData];
}

- (void)_initData {
    id<CRCocosGameRuntime> runtime = [CRCocosGame getRuntime];
    if (runtime) {
        [runtime listGame:self];
    }
}

- (void)_onClickButtonSelectAll {
    BOOL isSelected = self.selectAllBtn.isSelected;
    [self.selectAllBtn setSelected:!isSelected];
    [self.selectedArr removeAllObjects];
    if (!isSelected) {
        for (int i = 0; i < [self.dataSource count]; i++) {
            NSString *appId = [[self.dataSource objectAtIndex:i] objectForKey:CR_KEY_GAME_ITEM_APP_ID];
            [self.selectedArr addObject:appId];
        }
    }
    [self.tableView reloadData];
}

- (void)_onClickButtonDelete {
    NSMutableArray *idArr = [NSMutableArray array];
    [self.selectedArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idArr addObject:obj];
    }];
    id<CRCocosGameRuntime> runtime = [CRCocosGame getRuntime];
    if (runtime) {
        [runtime removeGameList:idArr listener:self];
    }
}

- (void)_setGameData:(NSDictionary *)info value:(NSNumber *)value {
    NSDictionary *options = @{@"auth_location": value,
                              @"auth_user_info": value,
                              @"auth_record": value,
                              @"auth_write_photos_album": value,
                              @"auth_camera": value};
    [[CRCocosGame getRuntime] setGameData:[info objectForKey:@"rt_game_item_app_id"]
                                     info:options
                                 listener:self];
}

#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UninstallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:CR_KEY_GAME_ITEM_EXTEND];
    NSString *appId = [dic objectForKey:CR_KEY_GAME_ITEM_APP_ID];
    BOOL selected = [self.selectedArr containsObject:appId];
    if (!title) {
        title = appId;
    }
    [cell.textLabel setText:title];
    [cell.selectBtn setSelected:selected];
    [cell setInfo:dic];
    __weak typeof(self) weakSelf = self;
    [cell setAuthOp:^(NSDictionary *info) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置权限" message:@"选择授权或撤销授权" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"授予所有权限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf _setGameData:info value:@(1)];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"撤销所有权限" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf _setGameData:info value:@(0)];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataSource) {
        return 0;
    }
    return [self.dataSource count];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    void(^delete)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *appId = [[weakSelf.dataSource objectAtIndex:indexPath.row] objectForKey:CR_KEY_GAME_ITEM_APP_ID];
        id<CRCocosGameRuntime> runtime = [CRCocosGame getRuntime];
        if (runtime) {
            [runtime removeGameList:@[appId] listener:self];
        }
    };
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"卸载" handler:delete];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *appId = [dic objectForKey:CR_KEY_GAME_ITEM_APP_ID];
    if ([self.selectedArr containsObject:appId]) {
        [self.selectedArr removeObject:appId];
    } else {
        [self.selectedArr addObject:appId];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - list game listener
- (void)onListGameFailure:(NSError *)error {
    NSLog(@"list game error: %@",error);
}

- (void)onListGameSuccess:(NSArray<NSDictionary *> *)list {
    self.dataSource = list;
    [self.tableView reloadData];
}

#pragma mark - remove game
- (void)onRemoveFailure:(NSError *)error {
    NSLog(@"remove game list fail: %@",error);
}

- (void)onRemoveFinish:(NSString *)appId extra:(NSString *)extra {
    [self.selectedArr removeObject:appId];
    [self _initData];
}

- (void)onRemoveStart:(NSString *)appId extra:(NSString *)extra {
    NSLog(@"remove game start: %@ extra: %@",appId,extra);
}

- (void)onRemoveSuccess:(NSArray<NSString *> *)removedList {
}

# pragma mark game data set
- (void)onGameDataSetSuccess {
    [ToastView showToast:@"设置游戏权限成功" withDuration:1];
}
- (void)onGameDataSetFailure:(NSError *)error {
    [ToastView showToast:@"设置游戏权限失败" withDuration:1];
}

@end
