#import "CDRSFocusUnfocusSpec.h"
#import "CDRSAlert.h"

@interface CDRSFocusUnfocusSpec ()
@property (nonatomic, retain) XC(IDESourceCodeEditor) editor;
@property (nonatomic, retain) XC(DVTSourceTextStorage) textStorage;
@end

@implementation CDRSFocusUnfocusSpec

@synthesize editor = _editor;
@synthesize textStorage = _textStorage;

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor {
    if (self = [super init]) {
        self.editor = editor;
        self.textStorage = self.editor.sourceCodeDocument.textStorage;
    }
    return self;
}

- (void)dealloc {
    self.editor = nil;
    self.textStorage = nil;
    [super dealloc];
}

- (void)focusOrUnfocusSpec {
    XC(DVTTextDocumentLocation) currentLocation = self.editor.currentSelectedDocumentLocations.firstObject;
    NSUInteger index = currentLocation.characterRange.location;

    if (index > self.textStorage.string.length) {
        [CDRSAlert flashMessage:@"failed to find an 'it', 'describe', or 'context'"];
        return;
    }

    while(index > 0) {
        id <XCP(DVTSourceExpression)> expression = [self previousExpressionAtIndex:index];
        NSString *symbol = expression.symbolString;
        NSUInteger location = expression.expressionRange.location;

        if ([self isCedarFunction:symbol]) {
            [self addFocusToSymbol:symbol AtIndex:location];
            return;
        } else if ([self isFocusedCedarFunction:symbol]) {
            [self removeFocusFromSymbol:symbol AtIndex:location];
            return;
        }

        index = location - 1;
        if (index > self.textStorage.string.length) {
            [CDRSAlert flashMessage:@"failed to find an 'it', 'describe', or 'context'"];
            break;
        }
    }
}

#pragma mark - Private

- (id <XCP(DVTSourceExpression)>)previousExpressionAtIndex:(NSUInteger)index {
    NSUInteger expressionIndex = [self.textStorage nextExpressionFromIndex:index forward:NO];
    return [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)];
}

#pragma mark - Identifying Cedar functions

- (BOOL)isCedarFunction:(NSString *)symbolName {
    NSArray *functionNames = @[@"it", @"describe", @"context"];
    return [functionNames indexOfObject:symbolName] != NSNotFound;
}

- (BOOL)isFocusedCedarFunction:(NSString *)symbolName {
    return [self isCedarFunction:[symbolName substringFromIndex:1]];
}

#pragma mark - Document editing

- (void)addFocusToSymbol:(NSString *)symbol AtIndex:(NSUInteger)index {
    id undoManager = [(id)self.editor.sourceCodeDocument valueForKey:@"_dvtUndoManager"];
    [self.textStorage replaceCharactersInRange:NSMakeRange(index, symbol.length)
                                    withString:[NSString stringWithFormat:@"f%@", symbol]
                               withUndoManager:undoManager];
}

- (void)removeFocusFromSymbol:(NSString *)symbol AtIndex:(NSUInteger)index {
    id undoManager = [(id)self.editor.sourceCodeDocument valueForKey:@"_dvtUndoManager"];
    [self.textStorage replaceCharactersInRange:NSMakeRange(index, symbol.length)
                                    withString:[symbol substringFromIndex:1]
                               withUndoManager:undoManager];
}

@end
