#import <Cocoa/Cocoa.h>

@interface CDRSFilePathNavigator : NSObject 
@end

@interface CDRSFilePathNavigator (Editors)
+ (id)editorContextShowingFilePath:(NSString *)filePath;
+ (void)editorContext:(void(^)(id))editorContextBlock
    forFilePath:(NSString *)filePath
    adjacent:(BOOL)openAdjacent;
@end

@interface CDRSFilePathNavigator (Navigation)
+ (void)openFilePath:(NSString *)filePath
    lineNumber:(NSUInteger)lineNumber
    inEditorContext:(id)editorContext;

+ (void)openAdjacentEditorContextTo:(id)editorContext
    callback:(void(^)(id))editorContextBlock;
@end
