#import "CDRSOpenAlternate.h"
#import "CDRSFilePathNavigator.h"
#import "CDRSXcode.h"
#import "CDRSUtils.h"

@interface CDRSOpenAlternate (CDRSClassDump)
- (id)editorArea;
- (id)lastActiveEditorContext;
- (id)sourceCodeDocument;
- (id)representingFilePath;
- (NSString *)pathString;
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
    NSString *alternateFilePath = nil;
    NSString *alternateFileBaseName = [self _alternateFileBaseNameForFilePath:filePath];
    NSString *rootPath = self._searchRootPath;

    NSLog(@"CedarShortcuts - Searching for %@ in %@", alternateFileBaseName, rootPath);

    NSDirectoryEnumerator *dirEnumerator =
        [[NSFileManager defaultManager] enumeratorAtPath:rootPath];

    CDRSTimeLog(@"CedarShortcuts - _alternateFilePathForFilePath") {
        for (NSString *relativeFilePath in dirEnumerator) {
            // Skip .git in root and *.build dirs
            if ([relativeFilePath characterAtIndex:0] == '.' ||
                [relativeFilePath.pathExtension isEqualToString:@"build"]) {
                [dirEnumerator skipDescendents];
                continue;
            }

            if (![relativeFilePath.pathExtension hasPrefix:@"m"]) continue;

            NSString *relativeFileBaseName = [relativeFilePath stringByDeletingPathExtension].lastPathComponent;
            if ([relativeFileBaseName isEqualToString:alternateFileBaseName]) {
                alternateFilePath = [rootPath stringByAppendingPathComponent:relativeFilePath];
                break;
            }
        }
    }
    return alternateFilePath;
}

// Doesn't work with implementation files that end on Spec, e.g. CDRSpec.m -> CDRSpecSpec
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
    id workspaceFilePath = [self._currentWorkspace representingFilePath];
    return [[workspaceFilePath pathString] stringByDeletingLastPathComponent];
}

- (id)_currentWorkspace {
    id workspaceController = [CDRSXcode currentWorkspaceController];
    return [workspaceController valueForKeyPath:@"_workspace"];
}

#pragma mark - Editor

- (NSString *)_currentFilePath {
    id currentSourceCodeEditor = [CDRSXcode currentSourceCodeEditor];
    return [[currentSourceCodeEditor sourceCodeDocument] fileURL].path;
}
@end
