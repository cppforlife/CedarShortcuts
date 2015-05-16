#import "CDRSXcodeInterfaces.h"

@interface CDRSFocusUnfocusSpec : NSObject {
    XC(IDESourceCodeEditor) _editor;
    XC(DVTSourceTextStorage) _textStorage;
}

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor;
- (void)focusOrUnfocusSpec;
@end
