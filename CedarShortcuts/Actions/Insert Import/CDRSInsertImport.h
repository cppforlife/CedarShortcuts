#import "CDRSXcodeInterfaces.h"

@class CDRSSymbolImportValidator;

@interface CDRSInsertImport : NSObject

@property (nonatomic, readonly) CDRSSymbolImportValidator *symbolValidator;

- (instancetype)initWithEditor:(XC(IDESourceCodeEditor))editor
               symbolValidator:(CDRSSymbolImportValidator *)symbolValidator NS_DESIGNATED_INITIALIZER;

- (void)insertImport;

@end

@interface CDRSInsertImport (UnavailableInitializers)

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
