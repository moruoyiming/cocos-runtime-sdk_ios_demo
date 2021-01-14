//
//  CRGameHandleInternal.h
//  lib-rt-core
//
//  Created by wdzhang on 2019/1/4.
//

#import <UIKit/UIKit.h>

static NSString *CR_APP_PARAM_FILE_APP_PACKAGE_PATH = @"_rt_file_app_package_path";
static NSString *CR_APP_PARAM_FILE_APP_DETAIL_PATH = @"_rt_file_app_detail_path";
static NSString *CR_APP_PARAM_FILE_USER_TEMP_PATH = @"_rt_file_user_temp_path";
static NSString *CR_APP_PARAM_FILE_USER_DATA_PATH = @"_rt_file_user_data_path";
static NSString *CR_APP_PARAM_LOCAL_STORAGE_PATH = @"_rt_local_storage_path";
static NSString *CR_APP_PARAM_GAME_LOADING_START_TIME = @"_rt_game_loading_start_time";
static NSString *CR_APP_PARAM_FILE_PLUGIN_PACKAGE_PATH = @"_rt_file_plugin_package_path";

/***
* js定义的权限值
*/
static NSString *CR_PERMISSION_USERINFO = @"userInfo";
static NSString *CR_PERMISSION_LOCATION = @"location";
static NSString *CR_PERMISSION_RECORD = @"record";
static NSString *CR_PERMISSION_WRITE_PHOTOS_ALBUM = @"writePhotosAlbum";
static NSString *CR_PERMISSION_CAMERA = @"camera";

/**
 * 默认权限，未授权
 */
static int CR_PERMISSION_DEFAULT = 0;
/***
 * 用户同意授权该游戏，不是整个应用
 */
static int CR_PERMISSION_GRANTED = 1;
/***
 * 用户拒绝授权该游戏，不是整个应用
 */
static int CR_PERMISSION_DENIED = 2;

@protocol CROnGameQueryExitListener <NSObject>
- (void)onCoreQueryExit:(NSString *)result;
@end

@protocol CRCoreExitListener <NSObject>
-(void)onCoreExitSuccess;
-(void)onCoreExitFailure:(NSError *)error;
@end

@protocol CRCoreRunListener <NSObject>
-(void)onGameViewCreated:(UIView *)view;
-(void)onRunSuccess;
-(void)onRunFailure:(NSError *)error;
@end

@protocol CRUnzipGamePackageListener <NSObject>
- (void)onUnzipSucceed;
- (void)onUnzipProgress:(float)percent;
- (void)onUnzipFailed:(NSString *)errorMsg;
@end

#pragma mark - permission
@protocol CRCorePermissionListener <NSObject>
/****
 * 更新权限字段
 * @param grantedPers 允许权限
 * @param deniedPers  拒绝权限
 */
- (void)updatePermission:(NSString *)appID grantedList:(NSArray<NSString *> *)grantedPers deniedList:(NSArray<NSString *> *)deniedPers;

/***
 *
 * @param per 要查询的权限
 * @return 0:未获取,1: 有权限，2:无权限
 */
- (NSInteger)getSinglePermission:(NSString *)appID permission:(NSString *)per;

/***
 * 查询所有权限，只返回已申请的权限
 */
- (NSDictionary<NSString *, NSNumber *> *)getAllPermission:(NSString *)appID;
@end

@protocol CRGameHandleInternal
- (void)runGame:(UIViewController *)controller appId:(NSString *)appId options:(NSDictionary *)options listener:(NSObject<CRCoreRunListener> *)listener;
- (void)unzipFile:(NSString *)zipFile toFile:(NSString *)dstFile listener:(id<CRUnzipGamePackageListener>)listener;
- (void)exitGame:(NSString *)appId listener:(id<CRCoreExitListener>)listener;
- (void)setOnGameQueryExitListener:(id<CROnGameQueryExitListener>)listener;
- (void)setOnGamePermissionListener:(id<CRCorePermissionListener>)listener;
@end
