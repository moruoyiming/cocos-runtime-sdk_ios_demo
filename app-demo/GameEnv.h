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


#import <Foundation/Foundation.h>

static int SCREEN_MODE_FULLSCREEN = 0;
static int SCREEN_MODE_SHOW_STATUS_BAR = 1;
static int ORIENTATION_LANDSCAPE = 0;
static int ORIENTATION_PORTRAIT = 1;

static NSString *KEY_SERVICE_URL = @"dev-service-url";

static NSString *SP_KEY_USER_ID = @"user-id";
static NSString *SP_KEY_SHOW_FPS = @"show-fps";
static NSString *SP_KEY_ENABLE_VCONSOLE = @"enable_vconsole";
static NSString *SP_KEY_SKIPPED_FRAME_WARNING_LIMIT = @"skipped-frame-warning-limit";
static NSString *SP_KEY_ENABLE_DEBUGGER = @"enable-debugger";
static NSString *SP_KEY_GO_TO_APP_GAME = @"go-to-app-game";
static NSString *SP_CORE_SELECTED_OBJECT = @"core-selected-object";
static NSString *SP_SDK_LAUNCH_TEST = @"sdk_launch_test";
static NSString *SP_KEY_SHOW_LOADING_TIME_LOG = @"show-loading-time-log";
static NSString *SP_KEY_LAUNCH_OPTIONS = @"launch-options";

//pvp
static NSString *KEY_PVP_SERVER_PARAMETER = @"pvp_server_parameter";

@interface GameEnv : NSObject
+ (NSString *)getServiceURL;
+ (NSArray<NSString *> *)getFeatureConfig;
+ (NSDictionary *)buildRuntimeOptions;
+ (NSString *)buildGameListRequest;
+ (NSString *)buildIconURL:(NSString *)appID;
+ (NSString *)buildGamePackageRequest:(NSString *)appId version:(NSString *)version;
+ (NSString *)buildGameSubpackageRequest:(NSString *)appId version:(NSString *)version root:(NSString *)root;
+ (NSDictionary *)buildAppOptions:(NSString *)appId version:(NSString *)version url:(NSString *)url hash:(NSString *)hash;

+ (GameEnv *)getInstance;
- (NSString *)getUserId;
- (void)setUserId:(NSString *)userId;
- (BOOL)isShowFPS;
- (void)showFPS:(BOOL)visible;
- (BOOL)isVConsoleEnabled;
- (void)enableVConsole:(BOOL)enable;
- (NSInteger)getSkippedFrameWarning;
- (void)setSkippedFrameWarning:(NSInteger)skippedCount;
- (BOOL)isDebuggerEnabled;
- (void)enableDebugger:(BOOL)enable;
- (BOOL)isDebuggerWaitingEnabled;
- (void)enableDebuggerWaiting:(BOOL)enable;
- (BOOL)getGoToAppGameFlag;
- (void)setGoToAppGameFlag:(BOOL)visible;
- (NSString *)getLaunchOptions;
- (void)setLaunchOptions:(NSString *)options;
- (BOOL)isSdkLaunchTest;
- (void)setSdkLaunchTest:(BOOL)visible;
- (BOOL)isShowGameLoadingTimeLog;
- (void)setGameLoadingTimeLog:(BOOL)visible;
@end
