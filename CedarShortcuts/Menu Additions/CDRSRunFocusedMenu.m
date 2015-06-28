#import "CDRSRunFocusedMenu.h"
#import "CDRSRunFocused.h"
#import "CDRSXcode.h"

@implementation CDRSRunFocusedMenu

- (void)runFocusedSpec:(id)sender {
    [[[CDRSRunFocused alloc] init] runFocusedSpec];
}

- (void)runFocusedFile:(id)sender {
    [[[CDRSRunFocused alloc] init] runFocusedFile];
}

- (void)runFocusedLast:(id)sender {
    [[[CDRSRunFocused alloc] init] runFocusedLast];
}

- (void)attach {
    NSMenu *productMenu = [CDRSXcode menuWithTitle:@"Product"];
    [productMenu addItem:NSMenuItem.separatorItem];
    [productMenu addItem:self._runFocusedSpecItem];
    [productMenu addItem:self._runFocusedFileItem];
    [productMenu addItem:self._runLastFocusedSpecItem];
}

#pragma mark - Menu items

static NSString * const focusedSpecKeyEquivalent = @"u";

- (NSMenuItem *)_runFocusedSpecItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Run Focused Spec";
    item.target = self;
    item.action = @selector(runFocusedSpec:);
    item.keyEquivalent = focusedSpecKeyEquivalent;
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask;
    return item;
}

- (NSMenuItem *)_runFocusedFileItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Run Focused File";
    item.target = self;
    item.action = @selector(runFocusedFile:);
    item.keyEquivalent = focusedSpecKeyEquivalent;
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
    return item;
}

- (NSMenuItem *)_runLastFocusedSpecItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Run Last Focused Spec(s)";
    item.target = self;
    item.action = @selector(runFocusedLast:);
    item.keyEquivalent = focusedSpecKeyEquivalent;
    item.keyEquivalentModifierMask = NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
    return item;
}
@end
