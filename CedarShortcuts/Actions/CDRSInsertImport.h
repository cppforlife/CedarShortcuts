#import "CDRSXcodeInterfaces.h"

@interface CDRSInsertImport : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEditor:(XC(IDESourceCodeEditor))editor NS_DESIGNATED_INITIALIZER;

- (void)insertImport;

@end
