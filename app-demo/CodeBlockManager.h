//
//  CodeBlockManager.h
//  app-demo
//
//  Created by 菅瑞霖 on 2021/1/14.
//

#ifndef CodeBlockManager_h
#define CodeBlockManager_h


#endif /* CodeBlockManager_h */
#import <Foundation/Foundation.h>


@interface CodeBlockManager : NSObject
@property(nonatomic,copy)NSString *iniType;             //初始化 1.是 0.否
@property(nonatomic,copy)NSString *quitType;             //退出 1.是 0.否
@property(nonatomic,copy)NSString *gameType;             //游戏类型 jeeke:平台 game:游戏
@property (nonatomic ,assign) BOOL EnableDebug;          //是否打开日志

+ (instancetype)shareCodeBlockManager;

//js交互方法
+ (void)mutualSubject:(id)handel paramter:(NSString *)par ;

//日志开关
+ (void)log:(NSString *)logstring;

@end
