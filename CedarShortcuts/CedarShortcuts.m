#import "CedarShortcuts.h"
#import "CDRSRunFocusedMenu.h"
#import "CDRSOpenAlternateMenu.h"
#import "CDRSEditMenu.h"
#import "CDRSViewMenu.h"

@interface CedarShortcuts ()
@property (nonatomic, strong) CDRSRunFocusedMenu *runFocusedMenu;
@property (nonatomic, strong) CDRSOpenAlternateMenu *openAlternateMenu;
@property (nonatomic, strong) CDRSEditMenu *editMenu;
@property (nonatomic, strong) CDRSViewMenu *viewMenu;
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
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [(NSNotificationCenter *)[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSApplicationDidFinishLaunchingNotification
         object:NSApp];

    self.runFocusedMenu = [[CDRSRunFocusedMenu alloc] init];
    [self.runFocusedMenu attach];

    self.openAlternateMenu = [[CDRSOpenAlternateMenu alloc] init];
    [self.openAlternateMenu attach];

    self.editMenu = [[CDRSEditMenu alloc] init];
    [self.editMenu attach];

    self.viewMenu = [[CDRSViewMenu alloc] init];
    [self.viewMenu attach];
}
@end
