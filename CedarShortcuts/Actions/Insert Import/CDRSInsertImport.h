#import "CDRSXcodeInterfaces.h"

@class CDRSSymbolImportValidator;
@class CDRSSymbolImportChecker;


@interface CDRSInsertImport : NSObject

@property (nonatomic, readonly) CDRSSymbolImportValidator *symbolValidator;
@property (nonatomic, readonly) CDRSSymbolImportChecker *symbolChecker;

- (instancetype)initWithEditor:(XC(IDESourceCodeEditor))editor
               symbolValidator:(CDRSSymbolImportValidator *)symbolValidator
                 symbolChecker:(CDRSSymbolImportChecker *)symbolChecker
            importFormatString:(NSString *)importFormatString NS_DESIGNATED_INITIALIZER;

- (void)insertImport;

@end

@interface CDRSInsertImport (UnavailableInitializers)

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
