#import "CDRSOpenAlternate.h"
#import "CDRSFilePathNavigator.h"
#import "CDRSXcode.h"

@interface CDRSOpenAlternate (CDRSClassDump)
- (id)editorArea;
- (id)lastActiveEditorContext;
- (id)sourceCodeDocument;

- (id)workspace;
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
    NSString *filePath = [self _alternateFilePathForFilePath:self._currentFilePath];

    if (filePath) {
        [CDRSFilePathNavigator editorContext:^(id editorContext) {
            [CDRSFilePathNavigator openFilePath:filePath lineNumber:NSNotFound inEditorContext:editorContext];
        } forFilePath:filePath adjacent:openInAdjacentEditor];
    }
}

#pragma mark - Alternative file paths

- (NSString *)_alternateFilePathForFilePath:(NSString *)filePath {
    NSString *alternateFileBaseName = [self _alternateFileBaseNameForFilePath:filePath];
    NSString *rootPath = self._searchRootPath;

    NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:rootPath];
    NSString *relativeFilePath = nil;

    while (relativeFilePath = [dirEnumerator nextObject]) {
        BOOL isMFile = [relativeFilePath.pathExtension hasPrefix:@"m"];
        if (!isMFile) continue;

        NSString *relativeFileBaseName = [relativeFilePath stringByDeletingPathExtension].lastPathComponent;
        if ([relativeFileBaseName isEqualToString:alternateFileBaseName]) {
            return [rootPath stringByAppendingPathComponent:relativeFilePath];
        }
    }
    return nil;
}

- (NSString *)_alternateFileBaseNameForFilePath:(NSString *)filePath {
    static NSString * const specFileSuffix = @"Spec";
    NSString *fileBaseName = [filePath.lastPathComponent stringByDeletingPathExtension];

    if ([fileBaseName hasSuffix:specFileSuffix]) {
        NSUInteger toIndex = fileBaseName.length - specFileSuffix.length;
        return [fileBaseName substringToIndex:toIndex];
    } else {
        return [fileBaseName stringByAppendingString:specFileSuffix];
    }
}

#pragma mark - Project

- (NSString *)_searchRootPath {
    return [[self _currentWorkspaceProject] sdefSupport_projectDirectory];
}

- (id)_currentWorkspaceProject {
    id workspaceController = [CDRSXcode currentWorkspaceController];
    id workspace = [workspaceController valueForKeyPath:@"_workspace"];
    return [workspace representingCustomDataStore];
}

#pragma mark - Editor

- (NSString *)_currentFilePath {
    id currentSourceCodeEditor = [CDRSXcode currentSourceCodeEditor];
    return [[currentSourceCodeEditor sourceCodeDocument] fileURL].path;
}
@end
