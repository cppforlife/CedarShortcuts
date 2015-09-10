#import "CDRSXcodeInterfaces.h"

@class CDRSSymbolImportValidator;

@interface CDRSInsertImport : NSObject

@property (nonatomic, readonly) CDRSSymbolImportValidator *symbolValidator;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithEditor:(XC(IDESourceCodeEditor))editor
               symbolValidator:(CDRSSymbolImportValidator *)symbolValidator NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)insertImport;

@end
