#import "CDRSSymbolImportValidator.h"

@implementation CDRSSymbolImportValidator

- (BOOL)isValidSymbol:(NSString *)symbolString {
    if (!symbolString) {
        return NO;
    }

    if ([symbolString isEqualToString:@"@protocol"]) {
        return NO;
    }

    unichar firstCharater = [symbolString characterAtIndex:0];
    NSCharacterSet *uppercaseCharacterSet = [NSCharacterSet uppercaseLetterCharacterSet];
    BOOL isUpcased = [uppercaseCharacterSet characterIsMember:firstCharater];
    if (!isUpcased) {
        return NO;
    }

    return YES;
}

@end
