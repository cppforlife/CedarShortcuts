#import "CDRSSymbolImportValidator.h"

@implementation CDRSSymbolImportValidator

- (BOOL)isValidSymbol:(NSString *)symbolString {
    if (!symbolString) {
        return NO;
    }

    if ([symbolString isEqualToString:@"@protocol"]) {
        return NO;
    }

    return YES;
}

@end
