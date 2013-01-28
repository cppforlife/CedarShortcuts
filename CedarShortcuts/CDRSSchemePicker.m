#import "CDRSSchemePicker.h"
#import <Cocoa/Cocoa.h>

@interface CDRSSchemePicker (CDRClassDump)
- (id)runContextManager;

- (id)activeRunContext;
- (NSArray *)runContexts;

- (id)activeRunDestination;
- (NSArray *)availableRunDestinations;

- (void)setActiveRunContext:(id)content
    andRunDestination:(id)destination;

- (BOOL)isTestable;
- (NSString *)name;
- (NSString *)fullDisplayName;
@end

@interface CDRSSchemePicker ()
@property (nonatomic, retain) id workspace;
@property (nonatomic, retain) id foundScheme;
@property (nonatomic, retain) id foundDestination;
@end

@implementation CDRSSchemePicker

@synthesize
    workspace = _workspace,
    foundScheme = _foundScheme,
    foundDestination = _foundDestination;

- (id)initWithWorkspace:(id)workspace {
    if (self = [super init]) {
        self.workspace = workspace;
    }
    return self;
}

- (void)dealloc {
    self.workspace = nil;
    self.foundScheme = nil;
    self.foundDestination = nil;
    [super dealloc];
}

#pragma mark -

- (void)findSchemeForTests {
    self.foundScheme = [self _findTestableScheme];
    self.foundDestination = [self._runContextManager activeRunDestination];
}

- (id)_findTestableScheme {
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

- (BOOL)_isSchemeTestable:(id)scheme {
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

- (id)_runContextManager {
    return [self.workspace runContextManager];
}
@end
