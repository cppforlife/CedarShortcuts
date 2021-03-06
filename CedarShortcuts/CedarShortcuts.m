#import "CedarShortcuts.h"
#import "CDRSRunFocusedMenu.h"
#import "CDRSOpenAlternateMenu.h"
#import "CDRSEditMenu.h"
#import "CDRSViewMenu.h"
#import "CDRSFileExtensionValidator.h"
#import "CDRSOpenAlternate.h"

@interface CedarShortcuts ()

@property (nonatomic) CDRSRunFocusedMenu *runFocusedMenu;
@property (nonatomic) CDRSOpenAlternateMenu *openAlternateMenu;
@property (nonatomic) CDRSEditMenu *editMenu;
@property (nonatomic) CDRSViewMenu *viewMenu;

@end


@implementation CedarShortcuts

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (instancetype)init {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSApplicationDidFinishLaunchingNotification
         object:NSApp];

    // attach menus on next tick of run loop to avoid clobbering existing menu items
    // e.g.: Jump To Instruction Pointer (https://github.com/cppforlife/CedarShortcuts/issues/19)
    [self performSelector:@selector(attachMenus) withObject:nil afterDelay:0.0f];
}

- (void)attachMenus {
    self.runFocusedMenu = [[CDRSRunFocusedMenu alloc] init];
    [self.runFocusedMenu attach];

    CDRSFileExtensionValidator *fileExtensionValidator = [[CDRSFileExtensionValidator alloc] init];
    CDRSOpenAlternate *openAlternateAction = [[CDRSOpenAlternate alloc] initWithFileExtensionValidator:fileExtensionValidator];
    self.openAlternateMenu = [[CDRSOpenAlternateMenu alloc] initWithOpenAlternateAction:openAlternateAction];
    [self.openAlternateMenu attach];

    self.editMenu = [[CDRSEditMenu alloc] init];
    [self.editMenu attach];

    self.viewMenu = [[CDRSViewMenu alloc] init];
    [self.viewMenu attach];
}

@end
