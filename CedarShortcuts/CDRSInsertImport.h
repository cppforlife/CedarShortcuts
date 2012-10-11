#import <Cocoa/Cocoa.h>

@interface CDRSInsertImport : NSObject {
    id _sourceCodeEditor;
    id _textStorage;
}
- (void)insertImport;
@end
