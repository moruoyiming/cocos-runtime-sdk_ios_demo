//
//  CRGameHandle.h
//  rt-core
//
//  Created by wdzhang on 2018/12/14.
//

#import <Foundation/Foundation.h>
#import "CRCocosGameHandle.h"
#import "CRGameHandleInternal.h"

@interface CRGameHandle : NSObject <CRCocosGameHandle, CRGameHandleInternal>
+ (CRGameHandle *)getInstance;
- (void)onCPPQueryExit:(NSString *)reasult;
- (void)onCPPGetUserInfo;
- (void)onCPPAuthorize:(NSString *)permission;
- (void)onGameQueryPermissionDialog;
- (void)onCPPOpenSetting;
- (void)onGameOpenSystemPermTipDialog;
- (void)onCPPGetSetting;
- (void)onCPPGetApiVersion:(NSString *)name;
- (void)onCPPLoadSubpackage:(NSString *)root;
- (void)onCPPChooseImageBySource:(NSString *)sourceType withCount:(NSUInteger)count;
- (void)onCPPPreviewImage:(NSArray *)urls withIndex:(NSUInteger)currentIndex;
- (void)onCPPCallCustomCommand:(int)identifier info:(NSDictionary *)info;
- (void)onCPPRunScriptComplete:(id)listenerObj isSuccess:(BOOL)isSuccess returnType:(NSString *)returnType returnValue:(NSDictionary *)returnValue errorMsg:(NSString *)errMsg;
- (void)onCPPUpdateVConsole;
- (void)onCPPEnableVConsole:(BOOL)enable complete:(void(^)())setEnableComplete;
- (void)done;
@end
