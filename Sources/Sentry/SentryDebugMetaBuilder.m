#import "SentryDebugMetaBuilder.h"
#import "SentryCrashDynamicLinker.h"
#import "SentryDebugMeta.h"
#import "SentryLog.h"
#import <Foundation/Foundation.h>

@interface
SentryDebugMetaBuilder ()

@property (nonatomic, strong) id<SentryCrashBinaryImageProvider> binaryImageProvider;

@end

@implementation SentryDebugMetaBuilder

static inline NSString *
hexAddress(unsigned long long value)
{
    return [NSString stringWithFormat:@"0x%016llx", value];
}

- (id)initWithBinaryImageProvider:(id<SentryCrashBinaryImageProvider>)binaryImageProvider
{
    if (self = [super init]) {
        self.binaryImageProvider = binaryImageProvider;
    }
    return self;
}

- (NSArray<SentryDebugMeta *> *)buildDebugMeta
{
    NSMutableArray<SentryDebugMeta *> *debugMetas = [NSMutableArray new];

    const int imageCount = [self.binaryImageProvider getImageCount];
    for (int iImg = 0; iImg < imageCount; iImg++) {
        SentryCrashBinaryImage image = [self.binaryImageProvider getBinaryImage:iImg];

        SentryDebugMeta *debugMeta = [[SentryDebugMeta alloc] init];
        debugMeta.uuid = [SentryDebugMetaBuilder convertUUID:image.uuid];
        debugMeta.type = @"apple";
        if (image.vmAddress > 0) {
            debugMeta.imageVmAddress = hexAddress(image.vmAddress);
        }
//        TODO fix this
        debugMeta.imageAddress = hexAddress(image.address);
        debugMeta.imageSize = @(image.size);

        if (nil != image.name) {
            debugMeta.name = [[NSString alloc] initWithUTF8String:image.name];
        }

        [debugMetas addObject:debugMeta];
    }

    return debugMetas;
}

/**
 * Copied from SentryCrashReport.addUUIDElement. We don't want to change SentryCrashReport.
 */
+ (NSString *_Nullable)convertUUID:(const unsigned char *const)value
{
    if (nil == value) {
        return nil;
    }

    const unichar hexNybbles[]
        = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    unichar uuidBuffer[37];
    const unsigned char *src = value;
    unichar *dst = uuidBuffer;
    for (int i = 0; i < 4; i++) {
        *dst++ = hexNybbles[(*src >> 4) & 15];
        *dst++ = hexNybbles[(*src++) & 15];
    }
    *dst++ = '-';
    for (int i = 0; i < 2; i++) {
        *dst++ = hexNybbles[(*src >> 4) & 15];
        *dst++ = hexNybbles[(*src++) & 15];
    }
    *dst++ = '-';
    for (int i = 0; i < 2; i++) {
        *dst++ = hexNybbles[(*src >> 4) & 15];
        *dst++ = hexNybbles[(*src++) & 15];
    }
    *dst++ = '-';
    for (int i = 0; i < 2; i++) {
        *dst++ = hexNybbles[(*src >> 4) & 15];
        *dst++ = hexNybbles[(*src++) & 15];
    }
    *dst++ = '-';
    for (int i = 0; i < 6; i++) {
        *dst++ = hexNybbles[(*src >> 4) & 15];
        *dst++ = hexNybbles[(*src++) & 15];
    }

    // Only 36 because UUID has 32 hexadecimal digits and we use four
    // delimiters -
    return [[NSString alloc] initWithCharacters:uuidBuffer length:36];
}

@end