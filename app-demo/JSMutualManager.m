//
//  JSMutualManager.m
//  app-demo
//
//  Created by 菅瑞霖 on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import "JSMutualManager.h"
#import "CodeBlockManager.h"

@interface JSMutualManager ()

@property (nonatomic , strong) id jsHandle;

@end


@implementation JSMutualManager

+ (instancetype)shareJsMutualManager {
    static JSMutualManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSMutualManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
      
    }
    return self;
}

#pragma - mark JS交互
- (void)jsMutualString:(id)prompt
            gameHandle:(id)handle{
    NSDictionary *readyDic;
    NSString *method;
    _jsHandle = handle;

//    @WeakObj(self);
    //Runtime游戏js交互
    readyDic = (NSDictionary *)prompt;
    method = [readyDic objectForKey:@"0"];
    readyDic = [self dictionaryWithJsonString:[readyDic objectForKey:@"1"]];
    NSLog(@"收到游戏消息：%@",prompt);
    NSString *jsmutualString;
    if ([method containsString:@"init"]) {
        //游戏初始化 非对战游戏
        jsmutualString = [NSString stringWithFormat:@"GameSDK.nativeCallback('onInit','%@')",[self jsonStringWithDict:@{@"error":@(0),@"userId":@"userId",@"nickName":@"Jianruilin",@"headUrl":@"",@"location":@"China",@"sex":@"x",@"age":@(12)} isTrans:NO]];
        
    }else if([method containsString:@"startCloudGame"]){
        jsmutualString = [NSString stringWithFormat:@"GameSDK.nativeCallback('onInit','%@')",[self jsonStringWithDict:@{@"error":@(0),@"userId":@"userId",@"nickName":@"Jianruilin",@"headUrl":@"",@"location":@"China",@"sex":@"x",@"age":@(12)} isTrans:NO]];
    }
    if (jsmutualString.length > 1) {
        //分类js交互 Native call JS
        [CodeBlockManager mutualSubject:handle paramter:jsmutualString];
    }
}

#pragma - mark Json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}

#pragma - mark 字典转Json字符串
- (NSString *)jsonStringWithDict:(NSDictionary *)dict isTrans:(BOOL)trans {
    NSError *error;
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
//        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    jsonString = mutStr;
    //转义字符...
    return jsonString;
}

@end
