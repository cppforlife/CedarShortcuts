#import "CDRSSymbolImportChecker.h"

@interface CDRSSymbolImportChecker ()

@property (nonatomic) XC(DVTSourceTextStorage) textStorage;
@property (nonatomic, copy) NSString *formatString;

@end

@implementation CDRSSymbolImportChecker

- (instancetype)initWithTextStorage:(XC(DVTSourceTextStorage))textStorage
                       formatString:(NSString *)formatString {
    if (self = [super init]) {
        _textStorage = textStorage;
        _formatString = formatString;
    }

    return self;
}

- (BOOL)isSymbolImported:(NSString *)symbol {
    NSString *fullSymbol = [NSString stringWithFormat:self.formatString, symbol];
    NSArray<XC(DVTSourceLandmarkItem)> *landmarkItems = self.textStorage.importLandmarkItems;

    for (XC(DVTSourceLandmarkItem) importLocation in landmarkItems) {
        if ([importLocation.name rangeOfString:fullSymbol].location != NSNotFound)
            return YES;
    }

    if ([self.textStorage.string containsString:fullSymbol]) {
        return YES;
    }

    return NO;
}

#pragma mark - NSObject

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
