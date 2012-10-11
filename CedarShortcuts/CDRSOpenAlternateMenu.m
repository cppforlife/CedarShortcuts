#import "CDRSOpenAlternateMenu.h"
#import "CDRSOpenAlternate.h"

@implementation CDRSOpenAlternateMenu

- (void)alternateBetweenSpec:(id)sender {
    [[[[CDRSOpenAlternate alloc] init] autorelease] alternateBetweenSpec];
}

- (void)openAlternateInAdjacentEditor:(id)sender {
    [[[[CDRSOpenAlternate alloc] init] autorelease] openAlternateInAdjacentEditor];
}

#pragma mark - Menu items

- (void)attach {
    NSMenu *mainMenu = [NSApp mainMenu];

    for (NSMenuItem *item in mainMenu.itemArray) {
        //I wanted to use Navigate menu, but for some reason our menu items don't appear there
        if ([item.title isEqualToString:@"File"]) {
            NSMenu *fileMenu = item.submenu;
            [fileMenu addItem:NSMenuItem.separatorItem];
            [fileMenu addItem:self._alternateBetweenSpecItem];
            [fileMenu addItem:self._openSpecOrImplInAdjacentEditorItem];
            return;
        }
    }
}

static const unichar keyEquivalentUnichar = NSDownArrowFunctionKey;

- (NSMenuItem *)_openSpecOrImplInAdjacentEditorItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Open Spec/Impl in adjacent editor";
    item.target = self;
    item.action = @selector(openAlternateInAdjacentEditor:);
    item.keyEquivalent = [NSString stringWithCharacters:&keyEquivalentUnichar length:1];
    item.keyEquivalentModifierMask = NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
    return item;
}

- (NSMenuItem *)_alternateBetweenSpecItem {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = @"Alternate between Spec";
    item.target = self;
    item.action = @selector(alternateBetweenSpec:);
    item.keyEquivalent = [NSString stringWithCharacters:&keyEquivalentUnichar length:1];
    item.keyEquivalentModifierMask = NSShiftKeyMask | NSControlKeyMask | NSCommandKeyMask;
    return item;
}

@end
