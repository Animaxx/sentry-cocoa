#import "SentryCrashDynamicLinker.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SentryCrashBinaryImageProvider <NSObject>

- (NSUInteger)getImageCount;

- (SentryCrashBinaryImage)getBinaryImage:(int)index;

@end

NS_ASSUME_NONNULL_END
