#import "CDRSFocusUnfocusSpec.h"
#import "CDRSAlert.h"

@interface CDRSFocusUnfocusSpec ()

@property (nonatomic, strong) XC(IDESourceCodeEditor) editor;
@property (nonatomic, strong) XC(DVTSourceTextStorage) textStorage;

@property (nonatomic, copy) NSString *cedarPrefixToAdd;
@property (nonatomic, copy) NSString *cedarIgnorablePrefix;
@property (nonatomic, copy) NSArray *cedarFunctions;

@end

@implementation CDRSFocusUnfocusSpec

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor
     ignorablePrefix:(NSString *)ignorablePrefix
         prefixToAdd:(NSString *)prefixToAdd
       functionNames:(NSArray *)functionNames {

    if (self = [super init]) {
        self.editor = editor;
        self.cedarFunctions = functionNames;
        self.cedarIgnorablePrefix = ignorablePrefix;
        self.cedarPrefixToAdd = prefixToAdd;
        self.textStorage = self.editor.sourceCodeDocument.textStorage;
    }
    return self;
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

        NSString *newSymbol = [self replacementForCedarFunction:symbol];
        if (newSymbol) {
            [self replaceExpression:expression withString:newSymbol];
            break;
        }

        index = location - 1;
        if (index > self.textStorage.string.length) {
            [CDRSAlert flashMessage:@"failed to find an 'it', 'describe', or 'context'"];
            break;
        }
    }
}

#pragma mark - Private

- (NSString *)replacementForCedarFunction:(NSString *)functionName {
    if ([self isCedarFunction:functionName]) {
        return [self.cedarPrefixToAdd stringByAppendingString:functionName];

    } else if ([self isFocusedCedarFunction:functionName]) {
        return [functionName substringFromIndex:self.cedarPrefixToAdd.length];

    } else if ([self isPendingCedarFunction:functionName]) {
        NSString *cedarFunction = [functionName substringFromIndex:self.cedarPrefixToAdd.length];
        return [self.cedarPrefixToAdd stringByAppendingString:cedarFunction];
    }

    return nil;
}

#pragma mark - Cedar functions

- (BOOL)isCedarFunction:(NSString *)symbolName {
    return [self.cedarFunctions indexOfObject:symbolName] != NSNotFound;
}

- (BOOL)isFocusedCedarFunction:(NSString *)symbolName {
    BOOL focused = [symbolName hasPrefix:self.cedarPrefixToAdd];

    NSString *substring = [symbolName substringFromIndex:self.cedarPrefixToAdd.length];
    return focused && [self isCedarFunction:substring];
}

- (BOOL)isPendingCedarFunction:(NSString *)symbolName {
    BOOL pending = [symbolName hasPrefix:self.cedarIgnorablePrefix];

    NSString *substring = [symbolName substringFromIndex:self.cedarIgnorablePrefix.length];
    return pending && [self isCedarFunction:substring];
}

#pragma mark - Document searching

- (id <XCP(DVTSourceExpression)>)previousExpressionAtIndex:(NSUInteger)index {
    NSUInteger expressionIndex = [self.textStorage nextExpressionFromIndex:index forward:NO];
    return [self.editor _expressionAtCharacterIndex:NSMakeRange(expressionIndex, 0)];
}

#pragma mark - Document editing

- (void)replaceExpression:(id <XCP(DVTSourceExpression)>)expression withString:(NSString *)replacementString {
    id undoManager = self.editor.sourceCodeDocument.undoManager;
    [self.textStorage replaceCharactersInRange:expression.expressionRange
                                    withString:replacementString
                               withUndoManager:undoManager];
}

@end
