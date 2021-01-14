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


#import "HallViewController.h"
#import "GameViewController.h"
#import "RequestTask.h"
#import "GameEnv.h"
#import "DummyData.h"

#define COLLECTION_CELL_SPACE 30.f

@interface GameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *imgContainerView;
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *nameLbl;
@end

@implementation GameCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        
        [self.imgContainerView.layer setCornerRadius:10];
        [self.imgContainerView setClipsToBounds:YES];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 5);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 5;
    }
    return self;
}

- (void)_initView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = (screenWidth - COLLECTION_CELL_SPACE * 3) / 2.0;
    CGFloat height = width/1.12f;
    
    self.imgContainerView = [[UIView alloc] init];
    [self.imgContainerView setFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:self.imgContainerView];
    
    self.logoImg = [[UIImageView alloc] init];
    [self.logoImg setFrame:CGRectMake(0, 0, width, height * 3 / 4.0)];
    [self.imgContainerView addSubview:self.logoImg];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 3 / 4.0, width, height / 4.0)];
    [self.nameLbl setText:@"名称"];
    [self.nameLbl setFont:[UIFont systemFontOfSize:16]];
    [self.nameLbl setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLbl];
}

@end

@interface HallViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSCache *imgCache;
@property (nonatomic, strong) RequestTask *gameListTask;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *loadBtn;
@end

@implementation HallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    // Image cache
    self.imgCache = [[NSCache alloc] init];
    
    [self _initView];
    [self _onLoginStatusChange];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onLoginStatusChange) name:SP_KEY_USER_ID object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)getGamePackageUrl {
    return [GameEnv buildGameListRequest];
}

- (DummyData *)getGameDummyData:(NSDictionary *)json {
    return [[DummyData alloc] initWithJSON:json];
}

//TODO 游戏跳转
- (void)goToGame:(DummyData *)dummyData {
    NSLog(@"goToGame %@",dummyData.url);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 游戏参数
    [dic setValue:dummyData.name forKey:KEY_NAME];
    [dic setValue:dummyData.icon forKey:KEY_ICON];
    [dic setValue:dummyData.appID forKey:KEY_APP_ID];
    [dic setValue:dummyData.url forKey:KEY_URL];
    [dic setValue:dummyData.packageHash forKey:KEY_HASH];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)dummyData.orientation] forKey:KEY_ORIENTATION];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)dummyData.screenMode] forKey:KEY_SCREEN_MODE];
    [dic setValue:dummyData.version forKey:KEY_VERSION];
    // 环境参数
    GameEnv *env = [GameEnv getInstance];
    NSString *appID = [env getUserId];
    [dic setValue:appID forKey:SP_KEY_USER_ID];
    [dic setValue:[GameEnv getServiceURL] forKey:KEY_SERVICE_URL];
    GameViewController *gameVC = [[GameViewController alloc] initWithData:dic];
    // 适配 iOS 13，以全屏模式打开游戏界面
    [gameVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (void)_onLoginStatusChange {
    NSString *userId = [[GameEnv getInstance] getUserId];
    if (userId) {
        [self.loadBtn setEnabled:YES];
        [self _getGameList];
    } else {
        self.dataArr = @[];
        [self.collectionView reloadData];
        [self.loadBtn setHidden:NO];
        [self.loadBtn setEnabled:NO];
        [self.loadBtn setTitle:@"请登陆" forState:UIControlStateNormal];
    }
}

- (void)_onRequestComplete:(NSArray *)jsonArr {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < [jsonArr count]; i++) {
        NSDictionary *dic = [jsonArr objectAtIndex:i];
        if (dic) {
            DummyData *dummy = [self getGameDummyData:dic];
            if ([self _requireArrayIncludesRequire:dummy.require inConfig:[GameEnv getFeatureConfig]]) {
                [arr addObject:dummy];
             }
        }
    }
    DummyData *newdata = [[DummyData alloc]init];
    newdata.name = @"绝地大逃杀";
    newdata.icon = @"http://pic.netbian.com/uploads/allimg/210107/215736-1610027856d485.jpg";
    newdata.url = @"http://chukong.oss-cn-qingdao.aliyuncs.com/uploads/202101/cpk/1c7d5a402ed591a8d6e346ab002b981b.cpk";
    newdata.version = @"13";
    newdata.appID = @"602384325";
    newdata.screenMode = 1;
    newdata.orientation = 1 ;
    newdata.packageHash =@"";
    [arr addObject:newdata];
    self.dataArr = arr;
    [self.collectionView reloadData];
}

- (BOOL)_requireArrayIncludesRequire:(NSArray<NSString *> *)requireArr inConfig:(NSArray<NSString *> *)config {
    if (!requireArr || [requireArr count] == 0) {
        return YES;
    }
    for (NSString *require in requireArr) {
        if (![config containsObject:require]) {
            return NO;
        }
    }
    return YES;
}

- (void)_initView {
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pvp_bg"]];
    [bg setContentMode:UIViewContentModeTop];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [mainCollectionView setBackgroundView:bg];
    [self.view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    
    self.collectionView = mainCollectionView;
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setHidesWhenStopped:YES];
    [self.activity setFrame:CGRectMake(self.view.frame.size.width/2.0 - 15, self.view.frame.size.height/2.0 - 15, 30, 30)];
    [self.view addSubview:self.activity];
    
    self.loadBtn = [[UIButton alloc] init];
    [self.loadBtn setFrame:CGRectMake(0, self.view.frame.size.height/2.0 - 10, self.view.frame.size.width, 20)];
    [self.loadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loadBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.loadBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    [self.loadBtn addTarget:self action:@selector(_onButtonClickLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadBtn];
}

- (void)_getGameList {
    if (!self.gameListTask) {
        __weak typeof(self) weakSelf = self;
        self.gameListTask = [[RequestTask alloc] initWithComplete:^(NSString *dataStr) {
            if (dataStr) {
                // 请求成功
                NSError *error = nil;
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                [weakSelf _onRequestComplete:arr];
                [weakSelf _setLoading:false];
            } else {
                // 请求失败
                [weakSelf _setLoadFail];
            }
        }];
    }
    [self _setLoading:YES];
    [self.gameListTask request:[self getGamePackageUrl]];
}

#pragma mark collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GameCollectionViewCell *cell = (GameCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    DummyData *data = [self.dataArr objectAtIndex:indexPath.row];
    [self _setImageWithURL:data.icon toImgView:cell.logoImg];
    [cell.nameLbl setText:data.name];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = (screenWidth - COLLECTION_CELL_SPACE * 3) / 2.0;
    return CGSizeMake(width, width/1.12f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, COLLECTION_CELL_SPACE, 10, COLLECTION_CELL_SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return COLLECTION_CELL_SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return COLLECTION_CELL_SPACE;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self goToGame:[self.dataArr objectAtIndex:indexPath.row]];
}

#pragma mark - Load Image
- (void)_setImageWithURL:(NSString *)url toImgView:(UIImageView *)imgView {
    UIImage *img = [self.imgCache objectForKey:url];
    if (!img) {
        // load image from network
        [imgView setImage:nil];
        [self _loadImageWithURL:url toImgView:imgView];
    } else {
        [imgView setImage:img];
    }
}

- (void)_loadImageWithURL:(NSString *)url toImgView:(UIImageView *)imgView {
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if (res.statusCode == 200) {
            UIImage *img = [UIImage imageWithData:data];
            [weakSelf.imgCache setObject:img forKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf _setImageWithURL:url toImgView:imgView];
            });
        }
    }];
    [task resume];
}

#pragma mark - load state
- (void)_onButtonClickLoad {
    [self _onLoginStatusChange];
}

- (void)_setLoading:(BOOL)isLoading {
    [self.loadBtn setHidden:YES];
    if (isLoading) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

- (void)_setLoadFail {
    [self.loadBtn setHidden:false];
    [self.activity stopAnimating];
}

@end
