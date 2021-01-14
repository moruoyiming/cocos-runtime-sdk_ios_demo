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


#import "GameEnv.h"
#import <lib_rt_core/CRCocosGameRuntime.h>

static NSArray *URL_ARRAY;
static NSArray<NSString *> *FEATURE_CONFIG_ARRAY;
static NSString *REQUEST_PATH = @"cocos-runtime-demo";
static int CORE_DATA_VERSION = 2;
static int CPK_DATA_VERSION = 13;
static int CPK_VERSION = 13;

@implementation GameEnv

static GameEnv *_singleton = nil;

+ (GameEnv *)getInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init] ;
        [[NSUserDefaults standardUserDefaults] addObserver:_singleton forKeyPath:SP_KEY_USER_ID options:NSKeyValueObservingOptionNew context:nil];
    });
    return _singleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [GameEnv getInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [GameEnv getInstance];
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:SP_KEY_USER_ID];
}

+ (NSArray *)_getServer {
    if (!URL_ARRAY) {
        URL_ARRAY = @[
//                      @"http://192.168.2.1:8080",
                      @"http://test-runtime.cocos.com",
                      @"http://cocosplay.sandbox.appget.cn"
                      ];
    }
    return URL_ARRAY;
}

+ (NSArray<NSString *> *)getFeatureConfig {
    if (!FEATURE_CONFIG_ARRAY) {
        FEATURE_CONFIG_ARRAY = @[
            @"CHUKONG",
            @"dev",
            
            @"sharePlugin"
        ];
    }
    return FEATURE_CONFIG_ARRAY;
}

+ (NSString *)getServiceURL {
    return [[self _getServer] objectAtIndex:0];
}

+ (NSDictionary *)buildRuntimeOptions {
    // get caches path
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // get tmp file
    NSString *tmpDir =NSTemporaryDirectory();
    NSString *appPath = [cachesDir stringByAppendingPathComponent:@"app"];
    NSString *userPath = [cachesDir stringByAppendingPathComponent:@"user"];
    NSString *cachePath = tmpDir;
    NSString *corePath = [cachesDir stringByAppendingPathComponent:@"core"];
    NSDictionary *dic = @{CR_KEY_STORAGE_PATH_APP:appPath, CR_KEY_STORAGE_PATH_USER:userPath, CR_KEY_STORAGE_PATH_CACHE:cachePath, CR_KEY_STORAGE_PATH_CORE:corePath};
    return dic;
}

+ (NSString *)buildGameListRequest {
    return [NSString stringWithFormat:@"%@/%@/cpk-data/%d/app_list.json",[self getServiceURL],REQUEST_PATH,CPK_VERSION];
}

+ (NSString *)buildIconURL:(NSString *)appID {
    return [NSString stringWithFormat:@"%@/%@/icon/rt/%@.png",[self getServiceURL],REQUEST_PATH,appID];
}

+ (NSString *)buildGamePackageRequest:(NSString *)appId version:(NSString *)version {
    return [NSString stringWithFormat:@"%@/%@/cpk/%d/%@.%@.cpk",[self getServiceURL],REQUEST_PATH,CPK_VERSION,appId,version];
}

+ (NSString *)buildGameSubpackageRequest:(NSString *)appId version:(NSString *)version root:(NSString *)root {
    NSData *rootData = [root dataUsingEncoding:NSUTF8StringEncoding];
    uint32_t crc32 = [self _crc32FromData:rootData];
    return [NSString stringWithFormat:@"%@/%@/cpk/%d/%@.%@.%u.cpk",[self getServiceURL],REQUEST_PATH, CPK_VERSION, appId, version, crc32];
}

+ (uint32_t)_crc32FromData:(NSData *)data {
    uint32_t *table = malloc(sizeof(uint32_t) * 256);
    uint32_t crc = 0xffffffff;
    uint8_t *bytes = (uint8_t *)[data bytes];
    
    for (uint32_t i = 0; i < 256; i++) {
        table[i] = i;
        for (int j = 0; j < 8; j++) {
            if (table[i] & 1) {
                table[i] = (table[i] >>= 1) ^ 0xedb88320;
            } else {
                table[i] >>= 1;
            }
        }
    }
    
    for (int i = 0; i < data.length; i++) {
        crc = (crc >> 8) ^ table[(crc & 0xff) ^ bytes[i]];
    }
    crc ^= 0xffffffff;
    
    free(table);
    return crc;
}

+ (NSDictionary *)buildAppOptions:(NSString *)appId version:(NSString *)version url:(NSString *)url hash:(NSString *)hash {
    return @{CR_KEY_GAME_PACKAGE_APP_ID:appId,
             CR_KEY_GAME_PACKAGE_VERSION:version,
             CR_KEY_GAME_PACKAGE_URL:url,
             CR_KEY_GAME_PACKAGE_HASH:hash
             };
}

- (NSString *)getUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SP_KEY_USER_ID];
}

- (void)setUserId:(NSString *)userId {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (userId == nil) {
        [userDefault removeObjectForKey:SP_KEY_USER_ID];
    } else {
        [userDefault setObject:userId forKey:SP_KEY_USER_ID];
    }
    [userDefault synchronize];
}

- (NSString *)getLaunchOptions {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SP_KEY_LAUNCH_OPTIONS];
}

- (void)setLaunchOptions:(NSString *)options {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (options == nil) {
        [userDefault removeObjectForKey:SP_KEY_LAUNCH_OPTIONS];
    } else {
        [userDefault setObject:options forKey:SP_KEY_LAUNCH_OPTIONS];
    }
    [userDefault synchronize];
}

- (BOOL)isShowFPS {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SP_KEY_SHOW_FPS];
}

- (void)showFPS:(BOOL)visible {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:visible forKey:SP_KEY_SHOW_FPS];
    [userDefault synchronize];
}

- (BOOL)isVConsoleEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SP_KEY_ENABLE_VCONSOLE];
}

- (void)enableVConsole:(BOOL)enable {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:enable forKey:SP_KEY_ENABLE_VCONSOLE];
    [userDefault synchronize];
}

- (BOOL)isSdkLaunchTest {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SP_SDK_LAUNCH_TEST];
}
- (void)setSdkLaunchTest:(BOOL)visible {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:visible forKey:SP_SDK_LAUNCH_TEST];
    [userDefault synchronize];
}

- (BOOL)isShowGameLoadingTimeLog {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SP_KEY_SHOW_LOADING_TIME_LOG];
}

- (void)setGameLoadingTimeLog:(BOOL)visible {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:visible forKey:SP_KEY_SHOW_LOADING_TIME_LOG];
    [userDefault synchronize];
}

- (NSInteger)getSkippedFrameWarning {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SP_KEY_SKIPPED_FRAME_WARNING_LIMIT];
}

- (void)setSkippedFrameWarning:(NSInteger)skippedCount {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:skippedCount forKey:SP_KEY_SKIPPED_FRAME_WARNING_LIMIT];
    [userDefault synchronize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (SP_KEY_USER_ID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SP_KEY_USER_ID object:nil];
    }
}
@end
