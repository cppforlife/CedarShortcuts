#import "CDRSInsertImport.h"
#import "CDRSAlert.h"

@interface CDRSInsertImport ()
@property (nonatomic, strong) XC(IDESourceCodeEditor) editor;
@property (nonatomic, strong) XC(DVTSourceTextStorage) textStorage;
@end

@implementation CDRSInsertImport
@synthesize
    editor = _editor,
    textStorage = _textStorage;

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor {
    if (self = [super init]) {
        self.editor = editor;
        self.textStorage = self.editor.sourceCodeDocument.textStorage;
    }
    return self;
}


- (void)insertImport {
    NSString *symbol = self._symbolUnderCursor;

    if ([self _isSymbolImported:symbol]) {
        [CDRSAlert flashMessage:@"#import declaration exists"];
    } else {
        NSString *declaration = [self _importDeclaration:symbol];
        NSUInteger index = [self _nextImportDeclarationIndex];
        [self _insertImportDeclaration:declaration atIndex:index];
        [CDRSAlert flashMessage:@"Added #import declaration"];
    }
}

#pragma mark - Import declaration

- (BOOL)_isSymbolImported:(NSString *)symbol {
    NSString *fullSymbol = [NSString stringWithFormat:@"%@.h", symbol];
    for (XC(DVTSourceLandmarkItem) importLocation in self.textStorage.importLandmarkItems) {
        if ([importLocation.name rangeOfString:fullSymbol].location != NSNotFound)
            return YES;
    }
    return NO;
}

- (NSString *)_symbolUnderCursor {
    XC(DVTTextDocumentLocation) currentLocation =
        self.editor.currentSelectedDocumentLocations.lastObject;
    NSUInteger cursorIndex = currentLocation.characterRange.location;
    NSUInteger expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:NO];
    return [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)].symbolString;
}

- (NSString *)_importDeclaration:(NSString *)symbol {
    return [NSString stringWithFormat:@"#import \"%@.h\"\n", symbol];
}

#pragma mark - Document editing

- (NSUInteger)_nextImportDeclarationIndex {
    XC(DVTSourceLandmarkItem) lastImportLocation =
        self.textStorage.importLandmarkItems.lastObject;
    if (lastImportLocation) {
        NSRange range = lastImportLocation.range;
        return range.location + range.length + 1;
    }
    return 0;
}

- (void)_insertImportDeclaration:(NSString *)declaration atIndex:(NSUInteger)index {
    id undoManager = [(id)self.editor.sourceCodeDocument valueForKey:@"_dvtUndoManager"];
    [self.textStorage
        replaceCharactersInRange:NSMakeRange(index, 0)
        withString:declaration
        withUndoManager:undoManager];
}
@end
