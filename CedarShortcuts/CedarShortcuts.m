#import "CedarShortcuts.h"
#import "CDRSShortcutsFile.h"
#import "CDRSRunFocused.h"

@interface CedarShortcuts (ClassDump)
- (id)representingFilePath;
- (id)workspacePath;
- (NSString *)pathString;
@end

@interface CedarShortcuts ()
@property (strong, nonatomic) id keyPressMonitor;
@property (strong, nonatomic) CDRSShortcutsFile *shortcutsFile;
@end

@implementation CedarShortcuts
@synthesize keyPressMonitor = _keyPressMonitor, shortcutsFile = _shortcutsFile;

+ (void)pluginDidLoad:(NSBundle *)plugin {
	static id sharedPlugin = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedPlugin = [[self alloc] init];
	});
}

- (id)init {
	if (self = [super init]) {
		[self _observeKeyPresses];
	}
	return self;
}

- (void)dealloc {
    [NSEvent removeMonitor:self.keyPressMonitor];
    [_keyPressMonitor release];
    [_shortcutsFile release];
	[super dealloc];
}

- (void)_observeKeyPresses {
    self.keyPressMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^ NSEvent* (NSEvent *event) {
        if (event.modifierFlags & NSCommandKeyMask) {
            id workspace = self._currentWorkspace;
            if (workspace && [self _handleKeyPress:event workspace:workspace])
                return nil;
        }
        return event;
    }];
}

- (BOOL)_handleKeyPress:(NSEvent *)event workspace:(id)workspace {
    CDRSShortcut shortcut =
        [self.shortcutsFile
            commandForShortcut:event.charactersIgnoringModifiers
                      shiftKey:(event.modifierFlags & NSShiftKeyMask) != 0];

    CDRSRunFocused *command =
        [[[CDRSRunFocused alloc]
            initWithWorkspaceController:self._currentWorkspaceController] autorelease];

    switch (shortcut) {
        case CDRSShortcutNotMatch: return NO;
        case CDRSShortcutRunFocused: return [command runFocused];
        case CDRSShortcutRunFocusedLast: return [command runFocusedLast];
        case CDRSShortcutRunFocusedFile: return [command runFocusedFile];
    }
}

- (CDRSShortcutsFile *)shortcutsFile {
    if (!_shortcutsFile) {
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"CedarShortcuts"];
        _shortcutsFile = [[CDRSShortcutsFile alloc] initWithFilePath:filePath];
    }
    return _shortcutsFile;
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

