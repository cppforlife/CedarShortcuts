#import "CDRSInsertImport.h"
#import "CDRSSymbolImportValidator.h"
#import "CDRSAlert.h"
#import "CDRSSymbolImportChecker.h"


@interface CDRSInsertImport ()

@property (nonatomic) XC(IDESourceCodeEditor) editor;
@property (nonatomic) XC(DVTSourceTextStorage) textStorage;
@property (nonatomic) CDRSSymbolImportValidator *symbolValidator;
@property (nonatomic) CDRSSymbolImportChecker *symbolChecker;
@property (nonatomic, copy) NSString *importFormatString;

@end


@implementation CDRSInsertImport

- (instancetype)initWithEditor:(XC(IDESourceCodeEditor))editor
               symbolValidator:(CDRSSymbolImportValidator *)symbolValidator
                 symbolChecker:(CDRSSymbolImportChecker *)symbolChecker
            importFormatString:(NSString *)importFormatString {
    if (self = [super init]) {
        _editor = editor;
        _symbolValidator = symbolValidator;
        _textStorage = editor.sourceCodeDocument.textStorage;
        _symbolChecker = symbolChecker;
        _importFormatString = importFormatString;
    }
    return self;
}

- (void)insertImport {
    NSString *symbol = self.symbolUnderCursor;

    if (!symbol) {
        [CDRSAlert flashMessage:@"Couldn't find something to import"];
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
    return [self.symbolChecker isSymbolImported:symbol];
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
    NSString *importDeclaration = [NSString stringWithFormat:self.importFormatString, symbol];
    return [NSString stringWithFormat:@"%@\n", importDeclaration];
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
