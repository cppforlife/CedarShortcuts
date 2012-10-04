#import "CedarShortcuts.h"
#import "CDRSRunFocused.h"

static NSString * const focusedSpecKeyEquivalent = @"u";
static const NSUInteger focusedSpecModifiers = NSControlKeyMask | NSAlternateKeyMask;
static const NSUInteger focusedFileModifiers = NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
static const NSUInteger lastFocusedModifiers = NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;

@interface CedarShortcuts (ClassDump)
- (id)representingFilePath;
- (id)workspacePath;
- (NSString *)pathString;
@end

@interface CedarShortcuts ()
- (void)addMenuItems;
- (void)runFocusedSpec:(id)sender;
- (void)runFocusedFile:(id)sender;
- (void)runFocusedLast:(id)sender;
- (void)applicationDidFinishLaunching:(NSNotification *)notification;
@end

@implementation CedarShortcuts

+ (void)pluginDidLoad:(NSBundle *)plugin {
	static id sharedPlugin = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedPlugin = [[self alloc] init];
	});

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:sharedPlugin
                           selector:@selector(applicationDidFinishLaunching:)
                               name:NSApplicationDidFinishLaunchingNotification
                             object:NSApp];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:NSApplicationDidFinishLaunchingNotification
                                object:NSApp];
    [self addMenuItems];
}

#pragma mark - private Menu action methods

- (void)runFocusedSpec:(id)sender
{
    [[[[CDRSRunFocused alloc] initWithWorkspaceController:self._currentWorkspaceController] autorelease] runFocused];
}

- (void)runFocusedFile:(id)sender
{
    [[[[CDRSRunFocused alloc] initWithWorkspaceController:self._currentWorkspaceController] autorelease] runFocusedFile];
}

- (void)runFocusedLast:(id)sender
{
    [[[[CDRSRunFocused alloc] initWithWorkspaceController:self._currentWorkspaceController] autorelease] runFocusedLast];
}

#pragma mark - private

- (void)addMenuItems
{
    NSMenu *menu = [NSApp mainMenu];
    NSArray *items = [menu itemArray];
    for (NSMenuItem *item in items) {
        if ([[item title] isEqualToString:@"Product"]) {
            NSMenu *productMenu = [item submenu];
            [productMenu addItem:[NSMenuItem separatorItem]];

            NSMenuItem *runFocusedSpecItem = [[NSMenuItem alloc] initWithTitle:@"Run Focused Spec"
                                                                        action:@selector(runFocusedSpec:)
                                                                 keyEquivalent:@""];
            [runFocusedSpecItem setKeyEquivalent:focusedSpecKeyEquivalent];
            [runFocusedSpecItem setKeyEquivalentModifierMask:focusedSpecModifiers];
            [productMenu addItem:runFocusedSpecItem];
            [runFocusedSpecItem setTarget:self];

            NSMenuItem *runFocusedFileItem = [[NSMenuItem alloc] initWithTitle:@"Run Focused File"
                                                                        action:@selector(runFocusedFile:)
                                                                 keyEquivalent:@""];
            [runFocusedFileItem setKeyEquivalent:focusedSpecKeyEquivalent];
            [runFocusedFileItem setKeyEquivalentModifierMask:focusedFileModifiers];
            [productMenu addItem:runFocusedFileItem];
            [runFocusedFileItem setTarget:self];

            NSMenuItem *runLastFocusedSpecItem = [[NSMenuItem alloc] initWithTitle:@"Run Last Focused Spec(s)"
                                                                            action:@selector(runFocusedLast:)
                                                                     keyEquivalent:@""];
            [runLastFocusedSpecItem setKeyEquivalent:focusedSpecKeyEquivalent];
            [runLastFocusedSpecItem setKeyEquivalentModifierMask:lastFocusedModifiers];
            [productMenu addItem:runLastFocusedSpecItem];
            [runLastFocusedSpecItem setTarget:self];
        }
    }
}

#pragma mark -

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
@end

