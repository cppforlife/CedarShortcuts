#import <Cedar/Cedar.h>
#import "CDRSInsertImport.h"
#import "CDRSSymbolImportValidator.h"
#import "CDRSAlert.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CDRSInsertImportSpec)

describe(@"CDRSInsertImport", ^{
    __block CDRSInsertImport *subject;

    __block CDRSSymbolImportValidator *symbolValidator;

    __block XC(IDESourceCodeEditor) fakeEditor;
    __block XC(DVTSourceTextStorage) fakeTextStorage;
    __block XC(IDESourceCodeDocument) fakeSourceCodeDocument;

    beforeEach(^{
        symbolValidator = nice_fake_for([CDRSSymbolImportValidator class]);

        fakeSourceCodeDocument = nice_fake_for(@protocol(XCP(IDESourceCodeDocument)));
        fakeTextStorage = nice_fake_for(@protocol(XCP(DVTSourceTextStorage)));

        fakeEditor = nice_fake_for(@protocol(XCP(IDESourceCodeEditor)));
        fakeEditor stub_method(@selector(sourceCodeDocument)).and_return(fakeSourceCodeDocument);
        fakeSourceCodeDocument stub_method(@selector(textStorage)).and_return(fakeTextStorage);

        subject = [[CDRSInsertImport alloc] initWithEditor:fakeEditor symbolValidator:symbolValidator];
    });

    it(@"should have an insert symbol validator", ^{
        subject.symbolValidator should be_same_instance_as(symbolValidator);
    });

    describe(@"-insertImport", ^{
        context(@"when the symbol looking backwards from the cursor is not valid", ^{
            beforeEach(^{
                XC(DVTSourceExpression) firstSourceExpression = nice_fake_for(@protocol(XCP(DVTSourceExpression)));
                XC(DVTSourceExpression) secondSourceExpression = nice_fake_for(@protocol(XCP(DVTSourceExpression)));

                fakeTextStorage stub_method(@selector(nextExpressionFromIndex:forward:))
                    .with(0, NO)
                    .and_return((NSUInteger)4);
                fakeTextStorage stub_method(@selector(nextExpressionFromIndex:forward:))
                    .with(0, YES)
                    .and_return((NSUInteger)5);

                fakeEditor stub_method(@selector(_expressionAtCharacterIndex:))
                    .with((NSUInteger)4)
                    .and_return(firstSourceExpression);
                firstSourceExpression stub_method(@selector(symbolString)).and_return(@"BadSymbol");

                fakeEditor stub_method(@selector(_expressionAtCharacterIndex:))
                    .with((NSUInteger)5)
                    .and_return(secondSourceExpression);
                secondSourceExpression stub_method(@selector(symbolString)).and_return(@"GoodSymbol");

                symbolValidator stub_method(@selector(isValidSymbol:))
                    .with(@"BadSymbol")
                    .and_return(NO);

                symbolValidator stub_method(@selector(isValidSymbol:))
                    .with(@"GoodSymbol")
                    .and_return(YES);

                [subject insertImport];
            });

            it(@"should look at the symbol following the cursor", ^{
                fakeTextStorage should have_received(@selector(nextExpressionFromIndex:forward:))
                    .with(0, YES);
            });

            it(@"should insert the symbol following the cursor into the document", ^{
                fakeTextStorage should have_received(@selector(replaceCharactersInRange:withString:withUndoManager:))
                    .with(Arguments::anything, @"#import \"GoodSymbol.h\"\n", Arguments::anything);
            });
        });

        context(@"when neither the previous nor following symbol is valid", ^{
            beforeEach(^{
                spy_on([CDRSAlert class]);
            });

            afterEach(^{
                stop_spying_on([CDRSAlert class]);
            });

            beforeEach(^{
                symbolValidator stub_method(@selector(isValidSymbol:)).and_return(NO);

                [subject insertImport];
            });

            it(@"should not insert anything into the document", ^{
                fakeTextStorage should_not have_received(@selector(replaceCharactersInRange:withString:withUndoManager:));
            });

            it(@"should alert the user", ^{
                [CDRSAlert class] should have_received(@selector(flashMessage:)).with(@"Couldn't find something to import\n\t:-{");
            });
        });
    });

});

SPEC_END
