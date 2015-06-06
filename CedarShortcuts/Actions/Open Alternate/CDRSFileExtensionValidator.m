#import "CDRSFileExtensionValidator.h"

@implementation CDRSFileExtensionValidator

- (BOOL)isValidSourceFileExtension:(NSString *)fileExtension {
    if ([fileExtension isEqualToString:@"m"]) {
        return YES;
    }

    if ([fileExtension isEqualToString:@"swift"]) {
        return YES;
    }

    if ([fileExtension isEqualToString:@"mm"]) {
        return YES;
    }

    return NO;
}

@end
