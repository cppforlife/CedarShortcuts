#import "CDRSXcodeInterfaces.h"

@interface CDRSInsertImport : NSObject {
    XC(IDESourceCodeEditor) _editor;
    XC(DVTSourceTextStorage) _textStorage;
}

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor;
- (void)insertImport;
@end
