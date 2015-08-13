#import <Cedar/Cedar.h>
#import "CDRSInsertImport.h"
#import "CDRSSymbolImportValidator.h"

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
                XC(DVTSourceExpression) fakeSourceExpression = nice_fake_for(@protocol(XCP(DVTSourceExpression)));
                fakeEditor stub_method(@selector(_expressionAtCharacterIndex:))
                    .and_return(fakeSourceExpression);
                fakeSourceExpression stub_method(@selector(symbolString)).and_return(@"bad-symbol");
                symbolValidator stub_method(@selector(isValidSymbol:))
                    .with(@"bad-symbol")
                    .and_return(NO);

                [subject insertImport];
            });

            it(@"should look at the symbol following the cursor", ^{
                fakeTextStorage should have_received(@selector(nextExpressionFromIndex:forward:))
                    .with(0, YES);
            });
        });
    });

});

SPEC_END
