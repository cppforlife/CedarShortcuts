#import "CDRSInsertImport.h"
#import "CDRSAlert.h"

@interface CDRSInsertImport ()
@property (nonatomic, strong) XC(IDESourceCodeEditor) editor;
@property (nonatomic, strong) XC(DVTSourceTextStorage) textStorage;
@end

@implementation CDRSInsertImport

static NSString * const importDeclarationFormatString = @"import \"%@.h\"";

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
    NSString *fullSymbol = [NSString stringWithFormat:importDeclarationFormatString, symbol];
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

    id symbol = [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)].symbolString;
    if (symbol == nil) {
        expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:YES];
        symbol = [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)].symbolString;
    }

    return symbol;
}

- (NSString *)_importDeclaration:(NSString *)symbol {
    NSString *importDeclaration = [NSString stringWithFormat:importDeclarationFormatString, symbol];
    return [NSString stringWithFormat:@"#%@\n", importDeclaration];
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
    id undoManager = self.editor.sourceCodeDocument.undoManager;
    [self.textStorage
        replaceCharactersInRange:NSMakeRange(index, 0)
        withString:declaration
        withUndoManager:undoManager];
}
@end
