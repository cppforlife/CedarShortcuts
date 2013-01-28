#import <Cocoa/Cocoa.h>
#import "CDRSXcode.h"

@interface CDRSInsertImport : NSObject {
    XC(IDESourceCodeEditor) _editor;
    XC(DVTSourceTextStorage) _textStorage;
}
- (void)insertImport;
@end
