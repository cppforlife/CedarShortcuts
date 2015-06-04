#import "CDRSEditMenu.h"
#import "CDRSInsertImport.h"
#import "CDRSXcode.h"
#import "CDRSFocusUnfocusSpec.h"

@implementation CDRSEditMenu

- (void)insertImport:(id)sender {
    id editor = [CDRSXcode currentEditor];
    CDRSInsertImport *insertImporter = [[[CDRSInsertImport alloc] initWithEditor:editor] autorelease];
    [insertImporter insertImport];
}

- (void)focusSpecUnderCursor:(id)sender {
    id editor = [CDRSXcode currentEditor];
    NSArray *functionNames = @[@"it", @"describe", @"context"];
    CDRSFocusUnfocusSpec *specFocuser = [[[CDRSFocusUnfocusSpec alloc] initWithEditor:editor
                                                                     ignorablePrefix:@"x"
                                                                         prefixToAdd:@"f"
                                                                       functionNames:functionNames] autorelease];
    [specFocuser focusOrUnfocusSpec];
}

- (void)attach {
    NSMenu *editMenu = [CDRSXcode menuWithTitle:@"Edit"];
    [editMenu addItem:NSMenuItem.separatorItem];
    [editMenu addItem:self._insertImportItem];
    [editMenu addItem:self._focusSpecItem];
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

- (NSMenuItem *)_focusSpecItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Focus spec under cursor";
    item.target = self;
    item.action = @selector(focusSpecUnderCursor:);
    item.keyEquivalent = @"f";
    item.keyEquivalentModifierMask = NSControlKeyMask;
    return item;
}
@end
