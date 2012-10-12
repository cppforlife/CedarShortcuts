#import "CDRSEditMenu.h"
#import "CDRSInsertImport.h"
#import "CDRSXcode.h"

@implementation CDRSEditMenu

- (void)insertImport:(id)sender {
    [[[[CDRSInsertImport alloc] init] autorelease] insertImport];
}

- (void)attach {
    NSMenu *editMenu = [CDRSXcode menuWithTitle:@"Edit"];
    [editMenu addItem:NSMenuItem.separatorItem];
    [editMenu addItem:self._insertImportItem];
}

#pragma mark - Menu items

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
