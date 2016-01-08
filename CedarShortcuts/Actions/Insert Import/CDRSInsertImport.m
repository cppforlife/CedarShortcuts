#import "CDRSInsertImport.h"
#import "CDRSSymbolImportValidator.h"
#import "CDRSAlert.h"


@interface CDRSInsertImport ()

@property (nonatomic) XC(IDESourceCodeEditor) editor;
@property (nonatomic) XC(DVTSourceTextStorage) textStorage;
@property (nonatomic) CDRSSymbolImportValidator *symbolValidator;

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
    NSString *symbol = self.symbolUnderCursor;

    if (!symbol) {
        [CDRSAlert flashMessage:@"Couldn't find something to import\n\t:-{"];
        return;
    }

    if ([self isSymbolImported:symbol]) {
        [CDRSAlert flashMessage:@"#import declaration exists"];
    } else {
        NSString *declaration = [self importDeclaration:symbol];
        NSUInteger index = [self nextImportDeclarationIndex];
        [self insertImportDeclaration:declaration atIndex:index];
        [CDRSAlert flashMessage:@"Added #import declaration"];
    }
}

#pragma mark - Import declaration

- (BOOL)isSymbolImported:(NSString *)symbol {
    NSString *fullSymbol = [NSString stringWithFormat:importDeclarationFormatString, symbol];
    for (XC(DVTSourceLandmarkItem) importLocation in self.textStorage.importLandmarkItems) {
        if ([importLocation.name rangeOfString:fullSymbol].location != NSNotFound)
            return YES;
    }
    return NO;
}

- (NSString *)symbolUnderCursor {
    XC(DVTTextDocumentLocation) currentLocation =
        self.editor.currentSelectedDocumentLocations.lastObject;
    NSUInteger cursorIndex = currentLocation.characterRange.location;
    NSUInteger expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:NO];

    NSRange cursorRange = NSMakeRange(expressionIndex, 0);
    XC(DVTSourceExpression) expression = [self.editor _expressionAtCharacterIndex:cursorRange];

    if (![self.symbolValidator isValidSymbol:expression.symbolString]) {
        expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:YES];
        cursorRange = NSMakeRange(expressionIndex, 0);

        expression = [self.editor _expressionAtCharacterIndex:cursorRange];
    }

    if ([self.symbolValidator isValidSymbol:expression.symbolString]) {
        return expression.symbolString;
    }

    return nil;
}

- (NSString *)importDeclaration:(NSString *)symbol {
    NSString *importDeclaration = [NSString stringWithFormat:importDeclarationFormatString, symbol];
    return [NSString stringWithFormat:@"#%@\n", importDeclaration];
}

#pragma mark - Document editing

- (NSUInteger)nextImportDeclarationIndex {
    XC(DVTSourceLandmarkItem) lastImportLocation =
        self.textStorage.importLandmarkItems.lastObject;
    if (lastImportLocation) {
        NSRange range = lastImportLocation.range;
        return range.location + range.length + 1;
    }
    return 0;
}

- (void)insertImportDeclaration:(NSString *)declaration atIndex:(NSUInteger)index {
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
