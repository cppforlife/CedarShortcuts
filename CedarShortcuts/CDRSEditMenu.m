#import "CDRSEditMenu.h"
#import "CDRSInsertImport.h"

@implementation CDRSEditMenu

- (void)insertImport:(id)sender {
    [[[[CDRSInsertImport alloc] init] autorelease] insertImport];
}

- (void)attach {
    NSMenu *mainMenu = [NSApp mainMenu];

    for (NSMenuItem *item in mainMenu.itemArray) {
        if ([item.title isEqualToString:@"Edit"]) {
            NSMenu *productMenu = item.submenu;
            [productMenu addItem:NSMenuItem.separatorItem];
            [productMenu addItem:self._insertImportItem];
            return;
        }
    }
}

- (NSMenuItem *)_insertImportItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Insert #import";
    item.target = self;
    item.action = @selector(insertImport:);
    item.keyEquivalent = @"i";
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask;
    return item;
}
@end
