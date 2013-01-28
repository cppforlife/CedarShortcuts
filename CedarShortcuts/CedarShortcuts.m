#import "CedarShortcuts.h"
#import "CDRSRunFocusedMenu.h"
#import "CDRSOpenAlternateMenu.h"
#import "CDRSEditMenu.h"
#import "CDRSViewMenu.h"

@interface CedarShortcuts ()
@property (nonatomic, retain) CDRSRunFocusedMenu *runFocusedMenu;
@property (nonatomic, retain) CDRSOpenAlternateMenu *openAlternateMenu;
@property (nonatomic, retain) CDRSEditMenu *editMenu;
@property (nonatomic, retain) CDRSViewMenu *viewMenu;
@end

@implementation CedarShortcuts
@synthesize
    runFocusedMenu = _runFocusedMenu,
    openAlternateMenu = _openAlternateMenu,
    editMenu = _editMenu,
    viewMenu = _viewMenu;

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init {
    if (self = [super init]) {
        [(NSNotificationCenter *)[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(applicationDidFinishLaunching:)
             name:NSApplicationDidFinishLaunchingNotification
             object:NSApp];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.runFocusedMenu = nil;
    self.openAlternateMenu = nil;
    self.editMenu = nil;
    self.viewMenu = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [(NSNotificationCenter *)[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSApplicationDidFinishLaunchingNotification
         object:NSApp];

    self.runFocusedMenu = [[[CDRSRunFocusedMenu alloc] init] autorelease];
    [self.runFocusedMenu attach];

    self.openAlternateMenu = [[[CDRSOpenAlternateMenu alloc] init] autorelease];
    [self.openAlternateMenu attach];

    self.editMenu = [[[CDRSEditMenu alloc] init] autorelease];
    [self.editMenu attach];

    self.viewMenu = [[[CDRSViewMenu alloc] init] autorelease];
    [self.viewMenu attach];
}
@end
