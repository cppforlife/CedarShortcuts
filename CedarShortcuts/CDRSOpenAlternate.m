#import "CDRSOpenAlternate.h"
#import "CDRSFilePathNavigator.h"

@interface CDRSOpenAlternate (CDRSClassDump)
- (id)editor;
- (id)editorArea;
- (id)lastActiveEditorContext;
- (id)sourceCodeDocument;

//
- (id)workspace;
- (id)executionEnvironment;

//
- (id)representingCustomDataStore;
- (NSString *)sdefSupport_projectDirectory;
@end

@implementation CDRSOpenAlternate

- (void)openAlternateInAdjacentEditor {
    [self _openAlternateAdjacent:YES];
}

- (void)alternateBetweenSpec {
    [self _openAlternateAdjacent:NO];
}

- (void)_openAlternateAdjacent:(BOOL)openInAdjacentEditor {
    NSString * filePath = [self _alternateFilePath];
    if (nil != filePath) {
        [CDRSFilePathNavigator editorContext:^(id editorContext) {
            [CDRSFilePathNavigator openFilePath:filePath lineNumber:NSNotFound inEditorContext:editorContext];
        } forFilePath:filePath adjacent:openInAdjacentEditor];
    }
}

- (NSString *)_alternateFilePath {
    NSString *rootPath = [self _searchRootPath];
    NSString *alternateFileBaseName = [self _alternateFileBaseName];
    NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:rootPath];
    NSString *relativeFilePath = nil;
    while (relativeFilePath = [dirEnumerator nextObject]) {
        if ([[relativeFilePath pathExtension] hasPrefix:@"m"] &&
            [[[relativeFilePath stringByDeletingPathExtension] lastPathComponent] isEqualToString:alternateFileBaseName]) {
            return [rootPath stringByAppendingPathComponent:relativeFilePath];
        }
    }
    return nil;
}

static NSString * const specFileSuffix = @"Spec";

- (NSString *)_alternateFileBaseName {
    NSString * currentFileBaseName = [[self._currentFilePath lastPathComponent] stringByDeletingPathExtension];
    if ([currentFileBaseName hasSuffix:specFileSuffix]) {
        NSUInteger suffixLength = [specFileSuffix length];
        NSRange suffixRange = NSMakeRange([currentFileBaseName length] - suffixLength, suffixLength);
        return [currentFileBaseName stringByReplacingCharactersInRange:suffixRange withString:@""];
    } else {
        return [currentFileBaseName stringByAppendingString:specFileSuffix];
    }
}

#pragma mark - Project

- (NSString *)_searchRootPath {
    return [[self _currentWorkspaceProject] sdefSupport_projectDirectory];
}

- (id)_currentWorkspaceProject {
    return [[[self _lastActiveEditorContext] workspace] representingCustomDataStore];
}

#pragma mark - Editor

- (NSString *)_currentFilePath {
    return [[self._currentSourceCodeDocument fileURL] path];
}

#pragma mark - Workspace

- (id)_currentWorkspaceController {
    id workspaceController = [[NSApp keyWindow] windowController];
    if ([workspaceController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        return workspaceController;
    }
    return nil;
}

- (id)_lastActiveEditorContext {
    id editorArea = [self._currentWorkspaceController editorArea];  // IDEEditorArea
    return [editorArea lastActiveEditorContext];                    // IDEEditorContext
}

- (id)_currentSourceCodeEditor {
    return [self._lastActiveEditorContext editor];                  // IDESourceCodeEditor
}

- (id)_currentSourceCodeDocument {
    // IDESourceCodeDocument < IDEEditorDocument
    return [self._currentSourceCodeEditor sourceCodeDocument];
}

@end
