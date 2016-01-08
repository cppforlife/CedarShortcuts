#import "CDRSEditMenu.h"
#import "CDRSInsertImport.h"
#import "CDRSXcode.h"
#import "CDRSFocusUnfocusSpec.h"
#import "CDRSSymbolImportValidator.h"
#import "CDRSSymbolImportChecker.h"

static NSString * const forwardDeclarationFormatString = @"@class %@;";
static NSString * const importDeclarationFormatString = @"import \"%@.h\"";

@implementation CDRSEditMenu

- (void)attach {
    NSMenu *editMenu = [CDRSXcode menuWithTitle:@"Edit"];
    [editMenu addItem:NSMenuItem.separatorItem];
    [editMenu addItem:[self insertImportItem]];
    [editMenu addItem:[self addForwardDeclarationItem]];
    [editMenu addItem:[self focusSpecItem]];
    [editMenu addItem:[self pendSpecItem]];
}

#pragma mark - Actions

- (void)insertImport:(id)sender {
    XC(IDESourceCodeEditor) editor = [CDRSXcode currentEditor];
    XC(DVTSourceTextStorage) textStorage = editor.sourceCodeDocument.textStorage;
    CDRSSymbolImportValidator *symbolValidator = [[CDRSSymbolImportValidator alloc] init];
    CDRSSymbolImportChecker *symbolChecker = [[CDRSSymbolImportChecker alloc] initWithTextStorage:textStorage
                                                                                     formatString:importDeclarationFormatString];
    CDRSInsertImport *insertImporter = [[CDRSInsertImport alloc] initWithEditor:editor
                                                                symbolValidator:symbolValidator
                                                                  symbolChecker:symbolChecker
                                                             importFormatString:importDeclarationFormatString];
    [insertImporter insertImport];
}

- (void)addForwardDeclaration:(id)sender {
    XC(IDESourceCodeEditor) editor = [CDRSXcode currentEditor];
    XC(DVTSourceTextStorage) textStorage = editor.sourceCodeDocument.textStorage;
    CDRSSymbolImportValidator *symbolValidator = [[CDRSSymbolImportValidator alloc] init];
    CDRSSymbolImportChecker *symbolChecker = [[CDRSSymbolImportChecker alloc] initWithTextStorage:textStorage
                                                                                     formatString:forwardDeclarationFormatString];
    CDRSInsertImport *insertImporter = [[CDRSInsertImport alloc] initWithEditor:editor
                                                                symbolValidator:symbolValidator
                                                                  symbolChecker:symbolChecker
                                                             importFormatString:forwardDeclarationFormatString];
    [insertImporter insertImport];
}

- (void)focusSpecUnderCursor:(id)sender {
    id editor = [CDRSXcode currentEditor];
    CDRSFocusUnfocusSpec *specFocuser = [[CDRSFocusUnfocusSpec alloc] initWithEditor:editor
                                                                     ignorablePrefix:@"x"
                                                                         prefixToAdd:@"f"
                                                                       functionNames:self.functionNames];
    [specFocuser focusOrUnfocusSpec];
}

- (void)pendSpecUnderCursor:(id)sender {
    id editor = [CDRSXcode currentEditor];
    CDRSFocusUnfocusSpec *specFocuser = [[CDRSFocusUnfocusSpec alloc] initWithEditor:editor
                                                                      ignorablePrefix:@"f"
                                                                          prefixToAdd:@"x"
                                                                        functionNames:self.functionNames];
    [specFocuser focusOrUnfocusSpec];
}

#pragma mark - Menu items

- (NSMenuItem *)insertImportItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Insert #import";
    item.target = self;
    item.action = @selector(insertImport:);
    item.keyEquivalent = @"i";
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask;
    return item;
}

- (NSMenuItem *)addForwardDeclarationItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Forward declare class";
    item.target = self;
    item.action = @selector(addForwardDeclaration:);
    item.keyEquivalent = @"c";
    item.keyEquivalentModifierMask = NSControlKeyMask | NSAlternateKeyMask;
    return item;
}

- (NSMenuItem *)focusSpecItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"Focus spec under cursor";
    item.target = self;
    item.action = @selector(focusSpecUnderCursor:);
    item.keyEquivalent = @"f";
    item.keyEquivalentModifierMask = NSControlKeyMask;
    return item;
}

- (NSMenuItem *)pendSpecItem {
    NSMenuItem *item = [[NSMenuItem alloc] init];
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
