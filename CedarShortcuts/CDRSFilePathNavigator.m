#import "CDRSFilePathNavigator.h"
#import <objc/runtime.h>

@interface CDRSFilePathNavigator (CDRSClassDump)
- (id)initWithDocumentURL:(NSURL *)url
        timestamp:(id)timestamp lineRange:(NSRange)lineRange;
- (id)structureEditorOpenSpecifierForDocumentLocation:(id)location
        inWorkspace:(id)workspace error:(id*)error;
- (void)openEditorOpenSpecifier:(id)openSpecifier;

- (void)_doOpenIn_Ask_withWorkspaceTabController:(id)workspaceTabController
    editorContext:(id)editorContext
    documentURL:(id)url
    initialSelection:(id)selection
    options:(id)options
    usingBlock:(id)block;

- (void)_doOpenIn_AdjacentEditor_withWorkspaceTabController:(id)workspaceTabController
    editorContext:(id)editorContext
    documentURL:(id)url
    usingBlock:(id)block;

- (id)lastActiveWorkspaceWindowController;
- (id)windowController;
- (id)workspace;
- (id)document;
- (id)editorArea;
- (id)lastActiveEditorContext;
- (id)_currentEditorArea;
- (id)_editorContexts;
- (id)editor;
- (id)filePath;
- (NSString *)pathString;
@end

@implementation CDRSFilePathNavigator
@end

@implementation CDRSFilePathNavigator (Editors)

+ (void)editorContext:(void(^)(id))editorContextBlock
    forFilePath:(NSString *)filePath
    adjacent:(BOOL)openAdjacent {

    id showingEditorContext = [CDRSFilePathNavigator editorContextShowingFilePath:filePath];
    if (showingEditorContext) return editorContextBlock(showingEditorContext);

    id editorArea = [self _currentEditorArea];
    id lastEditorContext = [editorArea lastActiveEditorContext];

    if (openAdjacent) {
        [self openAdjacentEditorContextTo:lastEditorContext callback:editorContextBlock];
    } else editorContextBlock(lastEditorContext);
}

+ (id)editorContextShowingFilePath:(NSString *)filePath {
    id editorArea = [CDRSFilePathNavigator _currentEditorArea];
    for (id editorContext in [editorArea _editorContexts]) {
        id document = [[editorContext editor] document];
        if ([[[document filePath] pathString] isEqualToString:filePath])
            return editorContext;
    }
    return nil;
}

+ (id)_currentEditorArea {
    id workspaceWindowController = [NSClassFromString(@"IDEWorkspaceWindow") lastActiveWorkspaceWindowController];
    return [workspaceWindowController editorArea];
}
@end

@implementation CDRSFilePathNavigator (Navigation)

+ (void)openFilePath:(NSString *)filePath
    lineNumber:(NSUInteger)lineNumber
    inEditorContext:(id)editorContext {

    id location =
        [[NSClassFromString(@"DVTTextDocumentLocation") alloc]
            initWithDocumentURL:[NSURL fileURLWithPath:filePath]
            timestamp:nil
            lineRange:NSMakeRange(MAX(0, lineNumber-1), 1)];

    [editorContext openEditorOpenSpecifier:
        [NSClassFromString(@"IDEEditorOpenSpecifier")
            structureEditorOpenSpecifierForDocumentLocation:location
            inWorkspace:[editorContext workspace]
            error:NULL]];
}

+ (void)openAdjacentEditorContextTo:(id)editorContext
    callback:(void(^)(id))editorContextBlock {

    [NSClassFromString(@"IDEEditorCoordinator")
        _doOpenIn_AdjacentEditor_withWorkspaceTabController:nil
        editorContext:editorContext
        documentURL:nil
        usingBlock:editorContextBlock];
}
@end
