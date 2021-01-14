//
//  JSMutualManager.h
//  app-demo
//
//  Created by 菅瑞霖 on 2021/1/14.
//

#ifndef JSMutualManager_h
#define JSMutualManager_h


#endif /* JSMutualManager_h */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSMutualManager : NSObject

+ (instancetype)shareJsMutualManager;


//收到js消息处理
- (void)jsMutualString:(id)prompt
            gameHandle:(id)handle;


//Json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//字典转Json字符串
- (NSString *)jsonStringWithDict:(NSDictionary *)dict isTrans:(BOOL)trans;


@end

NS_ASSUME_NONNULL_END
