//
//  CRGameRuntime.h
//  rt-core
//
//  Created by wdzhang on 2018/12/13.
//

#import <Foundation/Foundation.h>

@protocol CRCocosGameRuntime;
@protocol CRRuntimeInitializeListener;
@class CRGameRuntime;

@interface CRGameRuntime : NSObject <CRCocosGameRuntime>
+(CRGameRuntime *)getInstance;
-(void)create:(NSString *)userId options:(NSDictionary *)options listener:(NSObject<CRRuntimeInitializeListener> *)listener;
- (NSString *)getAppPackageCache;
- (void)done;
@end
