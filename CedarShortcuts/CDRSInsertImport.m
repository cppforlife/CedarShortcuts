#import "CDRSInsertImport.h"
#import "CDRSXcode.h"

@interface CDRSInsertImport (CDRSClassDump)
- (id)importLandmarkItems;
- (NSArray *)currentSelectedDocumentLocations;
- (id)sourceCodeDocument;
- (id)_expressionAtCharacterIndex:(NSRange)range;
- (id)symbolString;
- (NSRange)characterRange;

- (NSUInteger)nextExpressionFromIndex:(unsigned long long)index
    forward:(BOOL)forward;

- (void)replaceCharactersInRange:(NSRange)range
    withString:(NSString *)string
    withUndoManager:(id)undoManager;
@end

@interface CDRSInsertImport ()
@property (nonatomic, retain) id sourceCodeEditor;
@property (nonatomic, retain) id textStorage;
@end

@implementation CDRSInsertImport
@synthesize sourceCodeEditor = _sourceCodeEditor, textStorage = _textStorage;

- (id)init {
    if (self = [super init]) {
        self.sourceCodeEditor = [CDRSXcode currentSourceCodeEditor];
        self.textStorage = [[self.sourceCodeEditor sourceCodeDocument] textStorage];
    }
    return self;
}

- (void)dealloc {
    self.sourceCodeEditor = nil;
    self.textStorage = nil;
    [super dealloc];
}

- (void)insertImport {
    NSString *symbol = self._symbolUnderCursor;

    if ([self _isSymbolImported:symbol]) {
        [CDRSXcode flashAlertMessage:@"#import declaration exists"];
    } else {
        NSString *declaration = [self _importDeclaration:symbol];
        NSUInteger index = [self _nextImportDeclarationIndex];

        [self _insertImportDeclaration:declaration atIndex:index];
        [CDRSXcode flashAlertMessage:@"Added #import declaration"];
    }
}

#pragma mark - Import declaration

- (BOOL)_isSymbolImported:(NSString *)symbol {
    NSString *fullSymbol = [NSString stringWithFormat:@"%@.h", symbol];
    for (id importLocation in [self.textStorage importLandmarkItems]) {
        if ([[importLocation name] rangeOfString:fullSymbol].location != NSNotFound)
            return YES;
    }
    return NO;
}

- (NSString *)_symbolUnderCursor {
    id documentLocations = [self.sourceCodeEditor currentSelectedDocumentLocations];
    NSUInteger cursorIndex = [[documentLocations lastObject] characterRange].location;
    NSUInteger expressionIndex = [self.textStorage nextExpressionFromIndex:cursorIndex forward:NO];
    return [[self.sourceCodeEditor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)] symbolString];
}

- (NSString *)_importDeclaration:(NSString *)symbol {
    return [NSString stringWithFormat:@"#import \"%@.h\"\n", symbol];
}

#pragma mark - Document editing

- (NSUInteger)_nextImportDeclarationIndex {
    id lastImportLocation = [[self.textStorage importLandmarkItems] lastObject];
    if (lastImportLocation) {
        NSRange range = [lastImportLocation range];
        return range.location + range.length + 1;
    }
    return 0;
}

- (void)_insertImportDeclaration:(NSString *)declaration atIndex:(NSUInteger)index {
    id undoManager = [[self.sourceCodeEditor sourceCodeDocument] valueForKey:@"_dvtUndoManager"];
    [self.textStorage
        replaceCharactersInRange:NSMakeRange(index, 0)
        withString:declaration
        withUndoManager:undoManager];
}
@end
