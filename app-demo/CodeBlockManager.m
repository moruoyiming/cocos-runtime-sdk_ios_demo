//
//  CodeBlockManager.m
//  app-demo
//
//  Created by 菅瑞霖 on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import "CodeBlockManager.h"
#import <lib_rt_core/CRCocosGameHandle.h>
#import "JSMutualManager.h"


@interface CodeBlockManager ()<CRGameRunScriptListener>

@property (nonatomic, strong) NSDate *beginPlayDate;


@end



@implementation CodeBlockManager

+ (instancetype)shareCodeBlockManager {
    static CodeBlockManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CodeBlockManager alloc]init];
    });
    return manager;
}

#pragma mark - js交互
+ (void)mutualSubject:(id)handel paramter:(NSString *)par {
    NSLog(@"发送消息给游戏：%@",par);
    CodeBlockManager *code = [CodeBlockManager shareCodeBlockManager];
    [code mutualMainSubject:handel paramter:par];
}

- (void)mutualMainSubject:(id)handel paramter:(NSString *)par {
        //runtime
        id<CRCocosGameHandle> gameHandle = handel;
        [gameHandle runScript:par listener:self];
}

#pragma mark - CRGameRunScriptListener
- (void)onRunScriptSuccess:(NSString *)returnType returnInfo:(NSDictionary *)returnValue {
}

- (void)onRunScriptFailure:(NSString *)error {
}


#pragma mark - 日志
+ (void)log:(NSString *)logstring {
    if ([CodeBlockManager shareCodeBlockManager].EnableDebug) {
        NSLog(@"%@",logstring);
    }
}

@end
