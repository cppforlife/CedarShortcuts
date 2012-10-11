#import "CedarShortcuts.h"
#import "CDRSRunFocusedMenu.h"
#import "CDRSOpenAlternateMenu.h"

@interface CedarShortcuts ()
@property (nonatomic, retain) CDRSRunFocusedMenu *runFocusedMenu;
@property (nonatomic, retain) CDRSEditMenu *editMenu;
@property (nonatomic, retain) CDRSOpenAlternateMenu *openAlternateMenu;
@end

@implementation CedarShortcuts
@synthesize runFocusedMenu = _runFocusedMenu, editMenu = _editMenu, openAlternateMenu = _openAlternateMenu;

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
    [_openAlternateMenu release];
    [_editMenu release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSApplicationDidFinishLaunchingNotification
         object:NSApp];

    self.runFocusedMenu = [[[CDRSRunFocusedMenu alloc] init] autorelease];
    [self.runFocusedMenu attach];

    self.openAlternateMenu = [[[CDRSOpenAlternateMenu alloc] init] autorelease];
    [self.openAlternateMenu attach];

    self.editMenu = [[[CDRSEditMenu alloc] init] autorelease];
    [self.editMenu attach];
}
@end
