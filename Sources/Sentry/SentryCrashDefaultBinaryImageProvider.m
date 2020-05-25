#import "SentryCrashDefaultBinaryImageProvider.h"
#import "SentryCrashBinaryImageProvider.h"
#import "SentryCrashDynamicLinker.h"
#import <Foundation/Foundation.h>

@implementation SentryCrashDefaultBinaryImageProvider

- (NSUInteger)getImageCount
{
    return sentrycrashdl_imageCount();
}

- (SentryCrashBinaryImage)getBinaryImage:(int)index
{
    SentryCrashBinaryImage image = { 0 };
    sentrycrashdl_getBinaryImage(index, &image);
    return image;
}

@end
