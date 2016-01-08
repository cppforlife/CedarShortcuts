#import <Foundation/Foundation.h>
#import "CDRSXcodeInterfaces.h"

@interface CDRSSymbolImportChecker : NSObject

- (instancetype)initWithTextStorage:(XC(DVTSourceTextStorage))textStorage
                       formatString:(NSString *)formatString NS_DESIGNATED_INITIALIZER;

- (BOOL)isSymbolImported:(NSString *)symbol;

@end

@interface CDRSSymbolImportChecker (UnavailableMethods)

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
