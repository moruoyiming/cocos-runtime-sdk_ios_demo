//
//  CRCocosGameRuntime.h
//  rt-core
//
//  Created by wdzhang on 2018/12/13.
//

#import <UIKit/UIKit.h>
#import "CRCocosGameHandle.h"
#import "CRCocosGameConfig.h"

static NSString *CR_KEY_STORAGE_PATH_APP = @"rt_storage_path_app";
static NSString *CR_KEY_STORAGE_PATH_CACHE = @"rt_storage_path_cache";
static NSString *CR_KEY_STORAGE_PATH_CORE = @"rt_storage_path_core";
static NSString *CR_KEY_STORAGE_PATH_USER = @"rt_storage_path_user";
static NSString *CR_KEY_STORAGE_PATH_PLUGIN = @"rt_storage_path_plugin";

static NSString *CR_KEY_GAME_PACKAGE_APP_ID = @"rt_game_package_app_id";
static NSString *CR_KEY_GAME_PACKAGE_EXTEND_DATA = @"rt_game_package_extend_data";
static NSString *CR_KEY_GAME_PACKAGE_HASH = @"rt_game_package_hash";
static NSString *CR_KEY_GAME_PACKAGE_PATH = @"rt_game_package_path";
static NSString *CR_KEY_GAME_PACKAGE_URL = @"rt_game_package_url";
static NSString *CR_KEY_GAME_PACKAGE_VERSION = @"rt_game_package_version";
static NSString *CR_KEY_GAME_PACKAGE_SUBPACKAGE_ROOT = @"rt_game_package_subpackage_root";

static NSString *CR_KEY_RUN_DEBUG_SHOW_DEBUG_VIEW = @"rt_run_debug_show_debug_view";
static NSString *CR_KEY_RUN_DEBUG_SHOW_GAME_LOADING_TIME_LOG = @"rt_run_debug_show_game_loading_time_log";
static NSString *CR_KEY_RUN_DEBUG_SKIPPED_FRAME_WARNING_LIMIT = @"rt_run_debug_skipped_frame_warning_limit";

static NSString *CR_KEY_RUN_OPT_APP_LAUNCH_OPTIONS = @"rt_run_opt_app_launch_options";
static NSString *CR_KEY_RUN_OPT_EXTEND_DATA = @"rt_run_opt_extend";
static NSString *CR_KEY_RUN_OPT_VERSION = @"rt_run_opt_version";
static NSString *CR_KEY_RUN_OPT_DEFAULT_CERT_PATH = @"rt_run_opt_default_cert_path";

// 用于IGameListItem 的key
static NSString *CR_KEY_GAME_ITEM_APP_ID = @"rt_game_item_app_id";
static NSString *CR_KEY_GAME_ITEM_EXTEND = @"rt_game_item_extend";
/** 用于后台检查任务 */
static NSString *CR_KEY_CHECK_FILE_EXTENSION_NAME_ARRAY = @"rt_check_file_extension_name_array";
static NSString *CR_KEY_CHECK_FILE_KEEP_TIME = @"rt_check_file_keep_time";

@protocol CRCocosGameRuntime;

@protocol CRGameRunListener <NSObject>
- (void)onGameHandleCreate:(NSObject<CRCocosGameHandle> *)handle;
- (void)onRunSuccess;
- (void)onRunFailure:(NSError *)error;
@end

@protocol CRRuntimeInitializeListener <NSObject>
- (void)onInitializeSuccess:(NSObject<CRCocosGameRuntime> *)instance;
- (void)onInitializeFailure:(NSException *)exception;
@end

@protocol CRGameQueryExitListener
- (void)onQueryExit:(NSString *)appID result:(NSString *)result;
@end

@protocol CRGameExitListener
- (void)onGameExitSuccess;
    
- (void)onGameExitFailure:(NSError *)error;
@end

#pragma mark - Package listener
@protocol CRPackageCheckVersionListener <NSObject>
- (void)onCheckVersionStart:(NSDictionary *)info;
- (void)onCheckVersionSuccess;
- (void)onCheckVersionFailure:(NSError *)error;
@end

@protocol CRPackageDownloadListener <NSObject>
- (void)onDownloadStart;
- (void)onDownloadProgress:(long)downloadedSize totalSize:(long)totalSize;
- (void)onDownloadRetry:(long)retryNo;
- (void)onDownloadSuccess:(NSString *)path;
- (void)onDownloadFailure:(NSError *)error;
@end

@protocol CRPackageInstallListener <NSObject>
- (void)onInstallStart;
- (void)onInstallSuccess;
- (void)onInstallFailure:(NSError *)error;
@end

@protocol CRGameListListener <NSObject>
- (void)onListGameSuccess:(NSArray<NSDictionary *> *)list;
- (void)onListGameFailure:(NSError *)error;
@end

@protocol CRGameDataSetListener <NSObject>
- (void)onGameDataSetSuccess;
- (void)onGameDataSetFailure:(NSError *)error;
@end

@protocol CRGameRemoveListener <NSObject>
- (void)onRemoveStart:(NSString *)appId extra:(NSString *)extra;
- (void)onRemoveFinish:(NSString *)appId extra:(NSString *)extra;
- (void)onRemoveSuccess:(NSArray<NSString *> *)removedList;
- (void)onRemoveFailure:(NSError *)error;
@end

@protocol CRCheckFileAvailabilityListener <NSObject>
- (void)onCheckStart;
- (void)onCheckProgress:(NSString *)removedPath;
- (void)onCheckSuccess;
- (void)onCheckFailure:(NSError *)error;
@end

@protocol CRCocosGameRuntime <NSObject>
- (void)runGame:(UIViewController *)controller appId:(NSString *)appId options:(NSDictionary *)options listener:(NSObject<CRGameRunListener> *)listener;
- (void)exitGame:(NSString *)appId listener:(id<CRGameExitListener>)listener;
- (void)checkGameVersion:(NSDictionary *)info listener:(NSObject<CRPackageCheckVersionListener> *)listener;
- (void)downloadGamePackage:(NSDictionary *)info listener:(NSObject<CRPackageDownloadListener> *)listener;
- (void)installGamePackage:(NSDictionary *)info listener:(NSObject<CRPackageInstallListener> *)listener;
- (void)cancelGamePackageRequest;
- (NSString *)getVersionInfo;
- (void)setGameQueryExitListener:(id<CRGameQueryExitListener>)listener;
// game manager
- (void)listGame:(id<CRGameListListener>)listener;
- (void)setGameData:(NSString *)appId info:(NSDictionary *)info listener:(id<CRGameDataSetListener>)listener;
- (void)removeGameList:(NSArray<NSString *> *)list listener:(id<CRGameRemoveListener>)listener;
- (void)removeGameAll:(id<CRGameRemoveListener>)listener;
- (void)checkFileAvailability:(NSDictionary *)info listener:(id<CRCheckFileAvailabilityListener>)listener;
- (id<CRCocosGameConfig>)getGameConfig:(NSDictionary *)info;
- (id)getManager:(NSString *)name options:(NSDictionary *)options;
@end
