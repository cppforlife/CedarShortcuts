#import "CDRSOpenAlternate.h"
#import "CDRSFilePathNavigator.h"
#import "CDRSXcode.h"
#import "CDRSUtils.h"
#import "CDRSFileExtensionValidator.h"

@interface CDRSOpenAlternate ()

@property (nonatomic, strong) CDRSFileExtensionValidator *fileExtensionValidator;

@end

@implementation CDRSOpenAlternate

- (instancetype)initWithFileExtensionValidator:(CDRSFileExtensionValidator *)fileExtensionValidator {
    if (self = [super init]) {
        self.fileExtensionValidator = fileExtensionValidator;
    }

    return self;
}

- (void)openAlternateInAdjacentEditor {
    [self _openAlternateAdjacent:YES];
}

- (void)alternateBetweenSpec {
    [self _openAlternateAdjacent:NO];
}

#pragma mark - Private

- (void)_openAlternateAdjacent:(BOOL)openInAdjacentEditor {
    NSString *filePath = CDRSXcode.currentSourceCodeDocumentFileURL.path;
    NSString *alternateFilePath = [self _alternateFilePathForFilePath:filePath];

    if (alternateFilePath) {
        [CDRSFilePathNavigator editorContext:^(id editorContext) {
            [CDRSFilePathNavigator
                openFilePath:alternateFilePath
                lineNumber:NSNotFound
                inEditorContext:editorContext];
        } forFilePath:alternateFilePath adjacent:openInAdjacentEditor];
    }
}

#pragma mark - Alternative file paths

- (NSString *)_alternateFilePathForFilePath:(NSString *)filePath {
    NSString *alternateFilePath = nil;
    NSString *alternateFileBaseName = [self _alternateFileBaseNameForFilePath:filePath];
    NSString *rootPath = self._searchRootPath;

    NSDirectoryEnumerator *dirEnumerator =
        [[NSFileManager defaultManager] enumeratorAtPath:rootPath];

    CDRSTimeLog(@"CDRSOpenAlternate - _alternateFilePathForFilePath") {
        for (NSString *relativeFilePath in dirEnumerator) {
            // Skip .git in root and *.build dirs
            if ([relativeFilePath characterAtIndex:0] == '.' ||
                [relativeFilePath.pathExtension isEqualToString:@"build"]) {
                [dirEnumerator skipDescendents];
                continue;
            }

            NSString *extension = relativeFilePath.pathExtension;
            if (![self.fileExtensionValidator isValidSourceFileExtension:extension]) {
                continue;
            }

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
    XC(DVTFilePath) workspaceFilePath = CDRSXcode.currentWorkspace.representingFilePath;
    return [workspaceFilePath.pathString stringByDeletingLastPathComponent];
}
@end
