#import <Foundation/Foundation.h>

@protocol CRGameListListener;

@protocol CRPluginCheckVersionListener <NSObject>

- (void)onCheckPluginVersionStart:(NSDictionary *)info;

- (void)onCheckPluginSuccess:(NSDictionary *)info;

- (void)onCheckPluginFailure:(NSDictionary *)info error:(NSError *)error;

@end

@protocol CRPluginInstallListener <NSObject>

- (void)onPluginInstallStart:(NSDictionary *)info;

- (void)onPluginDownloadProgress:(NSDictionary *)info downloadSize:(long)downloadedSize totalSize:(long)totalSize;

- (void)onPluginDownloadRetry:(NSDictionary *)info retryNo:(long)retryNo;

- (void)onPluginInstallSuccess:(NSDictionary *)info;

- (void)onPluginInstallFailure:(NSDictionary *)info error:(NSError *)error;

@end

@protocol CRPluginRemoveListener <NSObject>

- (void)onPluginRemoveStart:(NSDictionary *)info;

- (void)onPluginRemoveFinish:(NSDictionary *)info;

- (void)onPluginRemoveSuccess:(NSArray<NSDictionary *> *)removeList;

- (void)onPluginRemoveFailure:(NSError *)error;

@end

@protocol CRCocosGamePluginManager <NSObject>

- (void)checkPluginVersion:(NSDictionary *)info listener:(id<CRPluginCheckVersionListener>)listener;

- (void)installPlugin:(NSDictionary *)info listener:(id<CRPluginInstallListener>)listener;

- (void)listPlugin:(id<CRGameListListener>)listener;

- (void)removePluginList:(NSArray<NSDictionary *> *)list listener:(id<CRPluginRemoveListener>)listener;

- (void)cancelPluginRequest;

@end
