#import "CedarShortcuts.h"
#import "CDRSRunFocusedMenu.h"

@interface CedarShortcuts ()
@property (nonatomic, retain) CDRSRunFocusedMenu *runFocusedMenu;
@end

@implementation CedarShortcuts
@synthesize runFocusedMenu = _runFocusedMenu;

+ (void)pluginDidLoad:(NSBundle *)plugin {
	static id sharedPlugin = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedPlugin = [[self alloc] init];
	});
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(applicationDidFinishLaunching:)
             name:NSApplicationDidFinishLaunchingNotification
             object:NSApp];
    }
    return self;
}

- (void)dealloc {
    [_runFocusedMenu release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSApplicationDidFinishLaunchingNotification
         object:NSApp];

    self.runFocusedMenu = [[[CDRSRunFocusedMenu alloc] init] autorelease];
    [self.runFocusedMenu attach];
}
@end
