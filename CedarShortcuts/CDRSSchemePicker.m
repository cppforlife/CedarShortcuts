#import "CDRSSchemePicker.h"
#import <Cocoa/Cocoa.h>

@interface NSApplication (ClassDump)
- (id)runActiveRunContext:(id)sender;
- (id)testActiveRunContext:(id)sender;
- (id)stopActiveRunContext:(id)sender;
@end

@interface CDRSSchemePicker ()
@property (nonatomic, strong) XC(Workspace) workspace;
@property (nonatomic, strong) XC(RunContext) foundScheme;
@property (nonatomic, strong) XC(RunDestination) foundDestination;
@end

@implementation CDRSSchemePicker
@synthesize
    workspace = _workspace,
    foundScheme = _foundScheme,
    foundDestination = _foundDestination;

+ (CDRSSchemePicker *)forWorkspace:(XC(Workspace))workspace {
    return [[self alloc] initWithWorkspace:workspace];
}

- (id)initWithWorkspace:(XC(Workspace))workspace {
    if (self = [super init]) {
        self.workspace = workspace;
    }
    return self;
}


#pragma mark -

- (void)findSchemeForTests {
    self.foundScheme = [self _findTestableScheme];
    self.foundDestination = [self._runContextManager activeRunDestination];
}

- (XC(RunContext))_findTestableScheme {
    NSMutableArray *schemes = [NSMutableArray array];
    // Look at currently selected scheme first
    // since it might have been selected on purpose
    [schemes addObject:[self._runContextManager activeRunContext]];
    [schemes addObjectsFromArray:[self._runContextManager runContexts]];

    for (id scheme in schemes) {
        if ([self _isSchemeTestable:scheme])
            return scheme;
    }
    return nil;
}

- (BOOL)_isSchemeTestable:(XC(RunContext))scheme {
    return [scheme isTestable] ||
        [[scheme name] hasSuffix:@"Tests"] ||
        [[scheme name] hasSuffix:@"Specs"];
}

#pragma mark - Running/testing

- (void)makeFoundSchemeAndDestinationActive {
    if (self.foundScheme && self.foundDestination) {
        NSLog(@"CDRSSchemePicker - switch: '%@'/'%@'",
            [self.foundScheme name],
            [self.foundDestination fullDisplayName]);
        [self._runContextManager
            setActiveRunContext:self.foundScheme
            andRunDestination:self.foundDestination];
    } else NSLog(@"CDRSSchemePicker - ignore switch");
}

- (void)testActiveSchemeAndDestination {
    SEL action = [self.foundScheme isTestable] ?
        @selector(testActiveRunContext:) : @selector(runActiveRunContext:);

    NSLog(@"CDRSSchemePicker - stop-run/test (%@) active scheme",
          NSStringFromSelector(action));
    [NSApp sendAction:@selector(stopActiveRunContext:) to:nil from:nil];
    [NSApp sendAction:action to:nil from:nil];
}

- (XC(RunContextManager))_runContextManager {
    return self.workspace.runContextManager;
}
@end
