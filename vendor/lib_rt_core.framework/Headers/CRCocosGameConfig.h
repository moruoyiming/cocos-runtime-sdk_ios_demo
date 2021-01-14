#import <Foundation/Foundation.h>

@protocol CRCocosGameConfig <NSObject>

- (NSString *)deviceOrientation;

- (BOOL)showStatusBar;

- (NSString *)runtimeVersion;

- (NSArray<NSDictionary *> *)subpackages;

- (NSArray<NSDictionary *> *)plugins;

@end
