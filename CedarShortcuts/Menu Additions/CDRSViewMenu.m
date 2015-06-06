#import "CDRSViewMenu.h"
#import "CDRSShowRecentFiles.h"
#import "CDRSXcode.h"

@implementation CDRSViewMenu

- (void)showRecentFiles:(id)sender {
    [[[[CDRSShowRecentFiles alloc] init] autorelease] showMenu];
}

- (void)attach {
    NSMenu *viewMenu = [CDRSXcode menuWithTitle:@"View"];
    NSMenu *standardEditorMenu =
        [[viewMenu itemWithTitle:@"Standard Editor"] submenu];
    [standardEditorMenu addItem:self._showRecentFilesItem];
}

#pragma mark - Menu items

- (NSMenuItem *)_showRecentFilesItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Show Recent Files";
    item.target = self;
    item.action = @selector(showRecentFiles:);
    item.keyEquivalent = @"e";
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask;
    return item;
}
@end
