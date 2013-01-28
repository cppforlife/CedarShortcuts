#import "CDRSRunFocused.h"
#import "IDELaunchSession_CDRSCustomize.h"
#import "CDRSXcode.h"

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]

@interface CDRSRunFocused (CDRSClassDump)
- (id)sourceCodeDocument;
- (long long)_currentOneBasedLineNubmer;

- (id)runContextManager;
- (id)activeRunContext;
- (BOOL)isTestable;
@end

@implementation CDRSRunFocused

- (BOOL)runFocusedSpec {
    self.lastFocusedRunPath = F(@"%@:%lld", self._currentFilePath, self._currentLineNumber);
    return [self _runFilePathAndLineNumber:self.lastFocusedRunPath];
}

- (BOOL)runFocusedFile {
    self.lastFocusedRunPath = F(@"%@:0", self._currentFilePath);
    return [self _runFilePathAndLineNumber:self.lastFocusedRunPath];
}

- (BOOL)runFocusedLast {
    if (self.lastFocusedRunPath) {
        return [self _runFilePathAndLineNumber:self.lastFocusedRunPath];
    } return NO;
}

#pragma mark -

- (BOOL)_runFilePathAndLineNumber:(NSString *)filePathAndLineNumber {
    if (!filePathAndLineNumber) return NO;

    static NSString *CDRSRunFocused_EnvironmentVariableName = @"CEDAR_SPEC_FILE";

    [IDELaunchSession_CDRSCustomize customizeNextLaunchSession:^(id launchSession){
        NSLog(@"CedarShortcuts - Running spec: %@", filePathAndLineNumber);
        id params = [launchSession launchParameters];

        // Used with 'Run' context (i.e. separate Test target)
        id runEnv = [params environmentVariables];
        [runEnv setObject:filePathAndLineNumber forKey:CDRSRunFocused_EnvironmentVariableName];

        // Used with 'Test' context (i.e. Test Bundles)
        NSMutableDictionary *testEnv = [[params testingEnvironmentVariables] mutableCopy];
        [testEnv setObject:filePathAndLineNumber forKey:CDRSRunFocused_EnvironmentVariableName];
        [params setTestingEnvironmentVariables:testEnv];
    }];

    if ([self._currentScheme isTestable]) {
        [NSApp sendAction:@selector(testActiveRunContext:) to:nil from:nil];
    } else {
        [NSApp sendAction:@selector(runActiveRunContext:) to:nil from:nil];
    }
    return YES;
}

#pragma mark - Editor
#pragma mark - Editor's file path & line number

- (NSString *)_currentFilePath {
    NSString *fullPath = [[self._currentSourceCodeDocument fileURL] absoluteString];
    return [fullPath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
}

- (long long)_currentLineNumber {
    return [[CDRSXcode currentSourceCodeEditor] _currentOneBasedLineNubmer];
}

#pragma mark - Last focused run path

static NSString *__lastFocusedRunPath = nil;

- (NSString *)lastFocusedRunPath {
    return __lastFocusedRunPath;
}

- (void)setLastFocusedRunPath:(NSString *)path {
    NSString *lastPath = __lastFocusedRunPath;
    __lastFocusedRunPath = [path copy];
    [lastPath release];
}

#pragma mark - Workspace

- (id)_currentSourceCodeDocument {
    // IDESourceCodeDocument < IDEEditorDocument
    return [[CDRSXcode currentSourceCodeEditor] sourceCodeDocument];
}

- (id)_currentWorkspace {
    return [[CDRSXcode currentWorkspaceController] valueForKey:@"_workspace"];
}

- (id)_currentScheme {
    id runContextManager = [self._currentWorkspace runContextManager]; // IDEWorkspace
    return [runContextManager activeRunContext];                       // IDEScheme
}
@end
