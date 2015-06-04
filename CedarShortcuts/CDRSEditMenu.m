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
    CDRSFocusUnfocusSpec *specFocuser = [[[CDRSFocusUnfocusSpec alloc] initWithEditor:editor
                                                                     ignorablePrefix:@"x"
                                                                         prefixToAdd:@"f"
                                                                       functionNames:self.functionNames] autorelease];
    [specFocuser focusOrUnfocusSpec];
}

- (void)pendSpecUnderCursor:(id)sender {
    id editor = [CDRSXcode currentEditor];
    CDRSFocusUnfocusSpec *specFocuser = [[[CDRSFocusUnfocusSpec alloc] initWithEditor:editor
                                                                      ignorablePrefix:@"f"
                                                                          prefixToAdd:@"x"
                                                                        functionNames:self.functionNames] autorelease];
    [specFocuser focusOrUnfocusSpec];
}

- (void)attach {
    NSMenu *editMenu = [CDRSXcode menuWithTitle:@"Edit"];
    [editMenu addItem:NSMenuItem.separatorItem];
    [editMenu addItem:self._insertImportItem];
    [editMenu addItem:self._focusSpecItem];
    [editMenu addItem:self._pendSpecItem];
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

- (NSMenuItem *)_pendSpecItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Pend spec under cursor";
    item.target = self;
    item.action = @selector(pendSpecUnderCursor:);
    item.keyEquivalent = @"x";
    item.keyEquivalentModifierMask = NSControlKeyMask;
    return item;
}

#pragma mark - Cedar method names

- (NSArray *)functionNames {
    return @[@"it", @"describe", @"context"];
}

@end
