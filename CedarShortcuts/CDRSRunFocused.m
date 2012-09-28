#import "CDRSRunFocused.h"
#import "IDELaunchSession_Customize.h"

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]

@interface CDRSRunFocused (ClassDump)
- (id)editor;
- (id)editorArea;
- (id)primaryEditorContext;
- (id)sourceCodeDocument;
- (long long)_currentOneBasedLineNubmer;
@end

@interface CDRSRunFocused ()
@property (retain, nonatomic) id workspaceController;
@end

@implementation CDRSRunFocused
@synthesize workspaceController = _workspaceController;

- (id)initWithWorkspaceController:(id)workspaceController {
    if (self = [super init]) {
        self.workspaceController = workspaceController;
        [IDELaunchSession_Customize setUp];
    }
    return self;
}

- (void)dealloc {
    [_workspaceController release];
    [super dealloc];
}

static NSString *__lastFocusedRun = nil;

- (BOOL)runFocused {
    return [self _run:F(@"%@:%lld", self._currentFilePath, self._currentLineNumber)];
}

- (BOOL)runFocusedLast {
    return __lastFocusedRun ? [self _run:__lastFocusedRun] : NO;
}

- (BOOL)runFocusedFile {
    return [self _run:F(@"%@:0", self._currentFilePath)];
}

- (BOOL)_run:(NSString *)filePathAndLineNumber {
    if (!filePathAndLineNumber) return NO;

    [IDELaunchSession_Customize customizeNextLaunchSession:^(id launchSession){
        NSLog(@"Running spec: %@", filePathAndLineNumber);

        // retain then release since it could be itself
        [filePathAndLineNumber retain];
        [__lastFocusedRun release];
        __lastFocusedRun = filePathAndLineNumber;

        id env = [[launchSession launchParameters] environmentVariables];
        [env setObject:filePathAndLineNumber forKey:@"CEDAR_SPEC_FILE"];
    }];

    [NSApp sendAction:@selector(runActiveRunContext:) to:nil from:nil];
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

- (id)_currentSourceCodeEditor {
    id editorArea = [self.workspaceController editorArea];      // IDEEditorArea
    id editorContext = [editorArea primaryEditorContext];       // IDEEditorContext
    return [editorContext editor];                              // IDESourceCodeEditor
}

- (id)_currentSourceCodeDocument {
    // IDESourceCodeDocument < IDEEditorDocument
    return [self._currentSourceCodeEditor sourceCodeDocument];
}
@end
