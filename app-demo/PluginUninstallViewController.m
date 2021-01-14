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
#import "PluginUninstallViewController.h"

#import <lib_rt_frame/CRCocosGame.h>
#import <lib_rt_core/CRCocosGameRuntime.h>
#import <lib_rt_core/CRCocosGamePluginManager.h>

#import "GameEnv.h"
#import "ToastView.h"

@interface PluginUninstallCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) NSDictionary *info;
@end

@implementation PluginUninstallCell

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
    }
    return self;
}

@end

@interface PluginUninstallViewController () <UITableViewDelegate, UITableViewDataSource, CRGameListListener, CRPluginRemoveListener>
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *selectedArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, weak) id<CRCocosGamePluginManager> pluginManager;
@end

@implementation PluginUninstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"选择卸载的插件"];
    
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
    [self.tableView registerClass:[PluginUninstallCell class] forCellReuseIdentifier:@"identifier"];
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
    if (!runtime) {
        return;
    }
    self.pluginManager = [runtime getManager:@"plugin_manager" options:nil];
    if (!self.pluginManager) {
        return;
    }
    [self.pluginManager listPlugin:self];
}

- (void)_onClickButtonSelectAll {
    BOOL isSelected = self.selectAllBtn.isSelected;
    [self.selectAllBtn setSelected:!isSelected];
    [self.selectedArr removeAllObjects];
    if (!isSelected) {
        for (int i = 0; i < [self.dataSource count]; i++) {
            NSDictionary *dic = [self.dataSource objectAtIndex:i];
            [self.selectedArr addObject:dic];
        }
    }
    [self.tableView reloadData];
}

- (void)_onClickButtonDelete {
    NSMutableArray *idArr = [NSMutableArray array];
    [self.selectedArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idArr addObject:obj];
    }];
    [self.pluginManager removePluginList:idArr listener:self];
}

#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PluginUninstallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *name = [dic objectForKey:@"provider"];
    NSString *version = [dic objectForKey:@"version"];
    NSString *pluginId = [NSString stringWithFormat:@"%@(%@)",name,version];
    [cell.textLabel setText:pluginId];
    BOOL selected = [self.selectedArr containsObject:dic];
    [cell.selectBtn setSelected:selected];
    [cell setInfo:dic];
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
        [self.pluginManager removePluginList:@[[weakSelf.dataSource objectAtIndex:indexPath.row]] listener:self];
    };
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"卸载" handler:delete];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    if ([self.selectedArr containsObject:dic]) {
        [self.selectedArr removeObject:dic];
    } else {
        [self.selectedArr addObject:dic];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - CRGameListListener
- (void)onListGameFailure:(NSError *)error {
    NSLog(@"list plugin error: %@",error);
}

- (void)onListGameSuccess:(NSArray<NSDictionary *> *)list {
    self.dataSource = list;
    [self.tableView reloadData];
}

#pragma mark - CRPluginRemoveListener
- (void)onPluginRemoveFailure:(NSError *)error {
    NSLog(@"remove plugin list fail: %@",error);
}

- (void)onPluginRemoveFinish:(NSDictionary *)info {
    [self.selectedArr removeObject:info];
    [self _initData];
}

- (void)onPluginRemoveStart:(NSDictionary *)info {
    NSLog(@"remove plugin start: %@",info);
}

- (void)onPluginRemoveSuccess:(NSArray<NSDictionary *> *)removeList {
}

@end
