#import "CDRSRunFocused.h"
#import "IDELaunchSession_CDRSCustomize.h"

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]

@interface CDRSRunFocused (CDRSClassDump)
- (id)editor;
- (id)editorArea;
- (id)lastActiveEditorContext;
- (id)sourceCodeDocument;
- (long long)_currentOneBasedLineNubmer;

- (id)runContextManager;
- (id)activeRunContext;
- (BOOL)isTestable;
@end

@implementation CDRSRunFocused

static NSString *__lastFocusedRun = nil;

- (BOOL)runFocusedSpec {
    return [self _run:F(@"%@:%lld", self._currentFilePath, self._currentLineNumber)];
}

- (BOOL)runFocusedFile {
    return [self _run:F(@"%@:0", self._currentFilePath)];
}

- (BOOL)runFocusedLast {
    return __lastFocusedRun ? [self _run:__lastFocusedRun] : NO;
}

- (BOOL)_run:(NSString *)filePathAndLineNumber {
    if (!filePathAndLineNumber) return NO;

    static NSString *CDRSRunFocused_EnvironmentVariableName = @"CEDAR_SPEC_FILE";

    [IDELaunchSession_CDRSCustomize customizeNextLaunchSession:^(id launchSession){
        NSLog(@"CedarShortcuts - Running spec: %@", filePathAndLineNumber);

        // retain then release since it could be itself
        [filePathAndLineNumber retain];
        [__lastFocusedRun release];
        __lastFocusedRun = filePathAndLineNumber;

        id params = [launchSession launchParameters];

        // Used with 'Run' context
        id runEnv = [params environmentVariables];
        [runEnv setObject:filePathAndLineNumber forKey:CDRSRunFocused_EnvironmentVariableName];

        // Used with 'Test' context
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

- (NSString *)_currentFilePath {
    NSString *fullPath = [[self._currentSourceCodeDocument fileURL] absoluteString];
    return [fullPath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
}

- (long long)_currentLineNumber {
    return [self._currentSourceCodeEditor _currentOneBasedLineNubmer];
}

#pragma mark - Workspace

- (id)_currentWorkspaceController {
    id workspaceController = [[NSApp keyWindow] windowController];
    if ([workspaceController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        return workspaceController;
    }
    return nil;
}

- (id)_currentWorkspace {
    return [self._currentWorkspaceController valueForKeyPath:@"_workspace"];
}

- (id)_currentSourceCodeEditor {
    id editorArea = [self._currentWorkspaceController editorArea];  // IDEEditorArea
    id editorContext = [editorArea lastActiveEditorContext];        // IDEEditorContext
    return [editorContext editor];                                  // IDESourceCodeEditor
}

- (id)_currentSourceCodeDocument {
    // IDESourceCodeDocument < IDEEditorDocument
    return [self._currentSourceCodeEditor sourceCodeDocument];
}

- (id)_currentScheme {
    id workspace = [self._currentWorkspaceController valueForKey:@"_workspace"];
    id runContextManager = [workspace runContextManager];           // IDEWorkspace
    return [runContextManager activeRunContext];                    // IDEScheme
}
@end
