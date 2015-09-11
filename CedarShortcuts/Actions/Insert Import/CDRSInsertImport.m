#import "CDRSInsertImport.h"
#import "CDRSAlert.h"
#import "CDRSSymbolImportValidator.h"

@interface CDRSInsertImport ()
@property (nonatomic, strong) XC(IDESourceCodeEditor) editor;
@property (nonatomic, strong) XC(DVTSourceTextStorage) textStorage;
@property (nonatomic, strong) CDRSSymbolImportValidator *symbolValidator;
@end

@implementation CDRSInsertImport

static NSString * const importDeclarationFormatString = @"import \"%@.h\"";

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor
     symbolValidator:(CDRSSymbolImportValidator *)symbolValidator {
    if (self = [super init]) {
        self.editor = editor;
        self.symbolValidator = symbolValidator;
        self.textStorage = self.editor.sourceCodeDocument.textStorage;
    }
    return self;
}


- (void)insertImport {
    NSString *symbol = self._symbolUnderCursor;

    if (!symbol) {
        [CDRSAlert flashMessage:@"Couldn't find something to import\n\t:-{"];
        return;
    }

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

    NSString *symbol = [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)].symbolString;
    if (![self.symbolValidator isValidSymbol:symbol]) {
        expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:YES];
        symbol = [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)].symbolString;
    }

    if ([self.symbolValidator isValidSymbol:symbol]) {
        return symbol;
    }

    return nil;
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

#pragma mark - NSObject

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
