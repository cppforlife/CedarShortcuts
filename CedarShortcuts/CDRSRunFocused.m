#import "CDRSRunFocused.h"
#import "CDRSSchemePicker.h"
#import "IDELaunchSession_CDRSCustomize.h"
#import "CDRSXcode.h"

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]

@implementation CDRSRunFocused

- (BOOL)runFocusedSpec {
    self.lastFocusedRunPath =
        F(@"%@:%lld", self._currentFilePath, self._currentLineNumber);
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

    [IDELaunchSession_CDRSCustomize customizeNextLaunchSession:^(XC(IDELaunchSession) launchSession){
        NSLog(@"CedarShortcuts - Running spec: %@", filePathAndLineNumber);
        XC(IDELaunchParametersSnapshot) params = launchSession.launchParameters;

        // Used with 'Run' context (i.e. separate Test target)
        NSMutableDictionary *runEnv = params.environmentVariables;
        [runEnv setObject:filePathAndLineNumber forKey:CDRSRunFocused_EnvironmentVariableName];

        // Used with 'Test' context (i.e. Test Bundles)
        NSMutableDictionary *testEnv = [params.testingEnvironmentVariables mutableCopy];
        [testEnv setObject:filePathAndLineNumber forKey:CDRSRunFocused_EnvironmentVariableName];
        [params setTestingEnvironmentVariables:testEnv];
    }];

    [self _runTests];
    return YES;
}

- (void)_runTests {
    CDRSSchemePicker *runner =
        [[[CDRSSchemePicker alloc]
            initWithWorkspace:[CDRSXcode currentWorkspace]] autorelease];
    [runner findSchemeForTests];
    [runner makeFoundSchemeAndDestinationActive];
    [runner testActiveSchemeAndDestination];
}

#pragma mark - Editor's file path & line number

- (NSString *)_currentFilePath {
    NSString *fullPath = CDRSXcode.currentSourceCodeDocumentFileURL.absoluteString;
    return [fullPath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
}

- (long long)_currentLineNumber {
    return CDRSXcode.currentSourceCodeEditor._currentOneBasedLineNubmer;
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
@end
