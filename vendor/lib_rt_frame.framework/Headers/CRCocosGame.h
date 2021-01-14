//
//  CRCocosGame.h
//  rt-frame
//
//  Created by wdzhang on 2018/12/13.
//

#import <Foundation/Foundation.h>

@protocol CRCocosGameRuntime;
@protocol CRRuntimeInitializeListener;

@interface CRCocosGame : NSObject
+(void)initRuntime:(NSString *)userId options:(NSDictionary *)options listener:(NSObject<CRRuntimeInitializeListener> *)listener;
+ (id<CRCocosGameRuntime>)getRuntime;
@end
