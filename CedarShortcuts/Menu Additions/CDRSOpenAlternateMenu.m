#import "CDRSOpenAlternateMenu.h"
#import "CDRSOpenAlternate.h"
#import "CDRSXcode.h"
#import "CDRSFileExtensionValidator.h"
#import "CDRSAlert.h"

@interface CDRSOpenAlternateMenu ()
@property (strong, nonatomic) CDRSOpenAlternate *openAlternateAction;
@end

@implementation CDRSOpenAlternateMenu

- (instancetype)initWithOpenAlternateAction:(CDRSOpenAlternate *)openAlternateAction {
    if (self = [super init]) {
        self.openAlternateAction = openAlternateAction;
    }

    return self;
}

- (void)alternateBetweenSpec:(id)sender {
    @try {
        [self.openAlternateAction alternateBetweenSpec];
    }
    @catch (NSException *exception) {
        [CDRSAlert flashMessage:@"Aww shucks. (Something bad happened)"];
        NSLog(@"================> something bad happened while opening the alternate file.");
        NSLog(@"================> %@", [exception description]);
    }
}

- (void)openAlternateInAdjacentEditor:(id)sender {
    @try {
        [self.openAlternateAction openAlternateInAdjacentEditor];
    }
    @catch (NSException *exception) {
        [CDRSAlert flashMessage:@"Aww shucks. (Something bad happened)"];
        NSLog(@"================> something bad happened while opening the alternate file in the adjacent editor.");
        NSLog(@"================> %@", [exception description]);
    }
}

- (void)attach {
    NSMenu *navigateMenu = [CDRSXcode menuWithTitle:@"Navigate"];

    // Seems that bottom items in Navigate menu are manipulated at times
    // so let's just insert above specific item that's always there
    NSInteger index = [navigateMenu indexOfItemWithTitle:@"Jump to Selection"];

    // insert backwards
    [navigateMenu insertItem:NSMenuItem.separatorItem atIndex:index];
    [navigateMenu insertItem:self._openSpecOrImplInAdjacentEditorItem atIndex:index];
    [navigateMenu insertItem:self._alternateBetweenSpecItem atIndex:index];
}

#pragma mark - Menu items

static const unichar keyEquivalentUnichar = NSDownArrowFunctionKey;

- (NSMenuItem *)_openSpecOrImplInAdjacentEditorItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Open Spec/Impl in Adjacent Editor";
    item.target = self;
    item.action = @selector(openAlternateInAdjacentEditor:);
    item.keyEquivalent = [NSString stringWithCharacters:&keyEquivalentUnichar length:1];
    item.keyEquivalentModifierMask = NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
    return item;
}

- (NSMenuItem *)_alternateBetweenSpecItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Alternate Between Spec";
    item.target = self;
    item.action = @selector(alternateBetweenSpec:);
    item.keyEquivalent = [NSString stringWithCharacters:&keyEquivalentUnichar length:1];
    item.keyEquivalentModifierMask = NSShiftKeyMask | NSControlKeyMask | NSCommandKeyMask;
    return item;
}

#pragma mark - NSObject

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
