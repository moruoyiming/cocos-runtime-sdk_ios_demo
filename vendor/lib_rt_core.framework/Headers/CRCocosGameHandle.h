//
//  CRCocosGameHandle.h
//  rt-core
//
//  Created by wdzhang on 2018/12/13.
//

#import <UIKit/UIKit.h>

/***
 *  用于GameUserInfoHandle设置用户信息
 */
static NSString *CR_KEY_GAME_USERINFO_USER_ID = @"rt_game_userinfo_user_id";
static NSString *CR_KEY_GAME_USERINFO_AVATAR_URL = @"rt_game_userinfo_avatar_url";
static NSString *CR_KEY_GAME_USERINFO_NICK_NAME = @"rt_game_userinfo_nick_name";
static NSString *CR_KEY_GAME_USERINFO_CITY = @"rt_game_userinfo_city";
static NSString *CR_KEY_GAME_USERINFO_COUNTRY = @"rt_game_userinfo_country";
static NSString *CR_KEY_GAME_USERINFO_PROVINCE = @"rt_game_userinfo_province";
static NSString *CR_KEY_GAME_USERINFO_GENDER = @"rt_game_userinfo_gender";

/***
 * 性别未知
 */
static int CR_GAME_USERINFO_GENDER_UNKNOWN = 0;
/***
 * 男性
 */
static int CR_GAME_USERINFO_GENDER_MALE = 1;
/***
 * 女性
 */
static int CR_GAME_USERINFO_GENDER_FEMALE = 2;

@protocol CRGameUserInfoHandle <NSObject>
- (void)onGetUserInfoFailure;
    
- (void)onGetUserInfoSuccess;
    
- (void)onGetUserInfoCancel;
    
- (void)setUserInfo:(NSDictionary *)info;
@end

@protocol CRGameUserInfoListener <NSObject>
- (void)queryUserInfo:(id<CRGameUserInfoHandle>)handle;
@end

#pragma mark - permission
typedef enum  {
    CR_LOCATION,
    CR_RECORD,
    CR_USER_INFO,
    CR_WRITE_PHOTOS_ALBUM,
    CR_CAMERA
} CRPermission;

@protocol CRGameAuthoritySettingHandle <NSObject>
- (void)changePermission:(CRPermission)permission granted:(BOOL)isGranted viewController:(UIViewController *)vc;
- (void)finish;
@end

@protocol CRGameOpenSettingDialogListener <NSObject>
- (void)onPermissionChanged:(CRPermission)permission granted:(BOOL)isGranted;
- (void)onSettingDialogOpen:(id<CRGameAuthoritySettingHandle>)handle permissionList:(NSDictionary<NSNumber *, NSNumber *> *)perMap;
@end

@protocol CRGameAuthDialogHandle <NSObject>
- (void)handleGamePermission:(CRPermission)per granted:(BOOL)isGranted;
@end

@protocol CRGameQueryPermissionDialogListener <NSObject>
- (void)onAuthDialogShow:(id<CRGameAuthDialogHandle>)handle permission:(CRPermission)per;
@end

@protocol CRGameOpenSysPermTipDialogListener <NSObject>
- (void)onAuthDialogShowWithPermission:(CRPermission)per;
@end

@protocol CRGameLoadSubpackageHandle <NSObject>
- (void)onLoadSubpackageFailure:(NSString *)error;
- (void)onLoadSubpackageSuccess;
- (void)onLoadSubpackageProgress:(NSInteger)written total:(NSInteger)total;
@end

@protocol CRGameLoadSubpackageListener <NSObject>
- (void)onLoadSubpackage:(id<CRGameLoadSubpackageHandle>)handle root:(NSString *)root;
@end

@protocol CRGameChooseImageHandle <NSObject>
- (void)onChooseImageSuccess:(NSArray *)imageInfos;
- (void)onChooseImageFailure;
- (void)onChooseImageCancel;
@end

@protocol CRGameChooseImageListener <NSObject>
- (void)onChooseImage:(id<CRGameChooseImageHandle>)handle withSourceType:(NSString *)sourceType withCount:(NSUInteger)count;
@end

@protocol CRGamePreviewImageHandle <NSObject>
- (void)onPreviewImageSuccess;
- (void)onPreviewImageFailure;
- (void)onPreviewImageCancel;
@end

@protocol CRGamePreviewImageListener <NSObject>
- (void)onPreviewImage:(id<CRGamePreviewImageHandle>)handle withPath:(NSArray *)paths withIndex:(NSUInteger)index;
@end

@protocol CRGameCustomCommandHandle <NSObject>
- (void)customCommandSuccess;
- (void)customCommandFailure:(NSString *)err;
- (void)pushResultWithString:(NSString *)res;
- (void)pushResultWithBool:(BOOL)res;
- (void)pushResultWithLong:(long)res;
- (void)pushResultWithDouble:(double)res;
- (void)pushResultWithInt8Arr:(NSData *)res;
- (void)pushResultWithInt16Arr:(NSData *)res;
- (void)pushResultWithInt32Arr:(NSData *)res;
- (void)pushResultWithFloatArr:(NSData *)res;
- (void)pushResultWithDoubleArr:(NSData *)res;
- (void)pushResultWithStringArr:(NSArray<NSString *> *)res;
- (void)pushResultWithBoolArr:(NSArray<NSNumber *> *)res;
- (void)pushResultNull;
@end

@protocol CRGameCustomCommandListener <NSObject>
- (void)onCallCustomCommand:(id<CRGameCustomCommandHandle>)handle info:(NSDictionary *)argv;
@end

@protocol CRGameRunScriptListener <NSObject>
- (void)onRunScriptSuccess:(NSString *)returnType returnInfo:(NSDictionary *)returnValue;
- (void)onRunScriptFailure:(NSString *)error;
@end

@protocol CRSKippedFrameWarningListener <NSObject>
- (void)onFramesSkipped:(int)frames;
@end

@protocol CRCocosGameHandle <NSObject>
- (NSString *)getAppId;
- (UIView *)getGameView;
- (NSString *)getVersionInfo;
- (void)didEnterBackground;
- (void)willEnterForeground;
- (void)setGameUserInfoListener:(id<CRGameUserInfoListener>)listener;
- (void)setGameOpenSettingDialogListener:(id<CRGameOpenSettingDialogListener>)listener;
- (void)setGameQueryPermissionDialogListener:(id<CRGameQueryPermissionDialogListener>)listener;
- (void)setGameOpenSysPermTipDialogListener:(id<CRGameOpenSysPermTipDialogListener>)listener;
- (void)setGameLoadSubpackageListener:(id<CRGameLoadSubpackageListener>)listener;
- (void)setGameChooseImageListener:(id<CRGameChooseImageListener>)listener;
- (void)setGamePreviewImageListener:(id<CRGamePreviewImageListener>)listener;
- (void)setCustomCommandListener:(id<CRGameCustomCommandListener>)listener;
- (void)setSkippedFrameWarningListener:(id<CRSKippedFrameWarningListener>)listener;
- (void)runScript:(NSString *)script listener:(id<CRGameRunScriptListener>)listener;
@end
